#!/usr/bin/env bash
# Smoke test for the local Keycloak realm (local development only).
#
# For each local test user it performs a real Authorization Code + PKCE login
# against the web client, exchanges the code for tokens, and asserts the
# access token issuer, API audience, and realm role. It also asserts that
# insecure flows are rejected. Tokens are never printed.
#
# Requires: curl, openssl, python3. Reads KEYCLOAK_* from the environment
# (the Makefile exports .env).
set -euo pipefail

KC_URL="http://localhost:${KEYCLOAK_PORT:-8081}"
REALM="${KEYCLOAK_REALM:-reptile-collection}"
CLIENT_ID="reptile-collection-web"
API_AUDIENCE="reptile-collection-api"
REDIRECT_URI="http://localhost:${WEB_PORT:-3000}/auth/callback"
PASSWORD="${KEYCLOAK_TEST_USER_PASSWORD:?KEYCLOAK_TEST_USER_PASSWORD must be set (see .env)}"
OIDC="${KC_URL}/realms/${REALM}/protocol/openid-connect"

workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT

failures=0
pass() { echo "  ok   $1"; }
fail() { echo "  FAIL $1"; failures=$((failures + 1)); }

b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }

# login <username> <expected-role>
login() {
  local username="$1" role="$2" jar="${workdir}/cookies-$1"
  local verifier challenge page action location code tokens

  verifier="$(openssl rand 48 | b64url)"
  challenge="$(printf '%s' "${verifier}" | openssl dgst -sha256 -binary | b64url)"

  page="$(curl -fsS -c "${jar}" -b "${jar}" -G "${OIDC}/auth" \
    --data-urlencode "client_id=${CLIENT_ID}" \
    --data-urlencode "response_type=code" \
    --data-urlencode "scope=openid" \
    --data-urlencode "redirect_uri=${REDIRECT_URI}" \
    --data-urlencode "state=smoke-test" \
    --data-urlencode "code_challenge=${challenge}" \
    --data-urlencode "code_challenge_method=S256")"

  action="$(printf '%s' "${page}" | python3 -c '
import html, re, sys
m = re.search(r"<form[^>]*id=\"kc-form-login\"[^>]*action=\"([^\"]+)\"", sys.stdin.read())
print(html.unescape(m.group(1)) if m else "")')"
  if [ -z "${action}" ]; then fail "${username}: login form not found"; return; fi

  location="$(curl -sS -o /dev/null -w '%{redirect_url}' -c "${jar}" -b "${jar}" \
    --data-urlencode "username=${username}" \
    --data-urlencode "password=${PASSWORD}" \
    "${action}")"

  code="$(printf '%s' "${location}" | python3 -c '
import sys, urllib.parse
q = urllib.parse.parse_qs(urllib.parse.urlparse(sys.stdin.read().strip()).query)
print(q.get("code", [""])[0])')"
  if [ -z "${code}" ]; then fail "${username}: no authorization code (wrong password or user missing)"; return; fi

  tokens="$(curl -fsS "${OIDC}/token" \
    --data-urlencode "grant_type=authorization_code" \
    --data-urlencode "client_id=${CLIENT_ID}" \
    --data-urlencode "code=${code}" \
    --data-urlencode "redirect_uri=${REDIRECT_URI}" \
    --data-urlencode "code_verifier=${verifier}")"

  if printf '%s' "${tokens}" | EXPECTED_ISS="${KC_URL}/realms/${REALM}" \
      EXPECTED_AUD="${API_AUDIENCE}" EXPECTED_ROLE="${role}" python3 -c '
import base64, json, os, sys
access = json.load(sys.stdin)["access_token"]
payload = access.split(".")[1]
claims = json.loads(base64.urlsafe_b64decode(payload + "=" * (-len(payload) % 4)))
aud = claims.get("aud", [])
aud = [aud] if isinstance(aud, str) else aud
roles = claims.get("realm_access", {}).get("roles", [])
errors = []
if claims.get("iss") != os.environ["EXPECTED_ISS"]:
    errors.append("iss=%s" % claims.get("iss"))
if os.environ["EXPECTED_AUD"] not in aud:
    errors.append("aud=%s" % aud)
if os.environ["EXPECTED_ROLE"] not in roles:
    errors.append("roles=%s" % roles)
if errors:
    print("    " + ", ".join(errors))
    sys.exit(1)
'; then
    pass "${username}: PKCE login, iss, aud=${API_AUDIENCE}, role=${role}"
  else
    fail "${username}: unexpected access token claims"
  fi
}

echo "Keycloak realm '${REALM}' at ${KC_URL}"

if curl -fsS "${KC_URL}/realms/${REALM}/.well-known/openid-configuration" >/dev/null; then
  pass "realm discovery document"
else
  fail "realm '${REALM}' not found (was it imported? see infrastructure/keycloak/README.md)"
  exit 1
fi

login "member@example.test" "member"
login "editor@example.test" "editor"
login "admin@example.test" "administrator"

# The password grant must be disabled for the browser client.
status="$(curl -sS -o /dev/null -w '%{http_code}' "${OIDC}/token" \
  --data-urlencode "grant_type=password" --data-urlencode "client_id=${CLIENT_ID}" \
  --data-urlencode "username=member@example.test" --data-urlencode "password=${PASSWORD}")"
if [ "${status}" != "200" ]; then pass "password grant rejected (HTTP ${status})"; else fail "password grant is enabled"; fi

# Authorization requests without PKCE must be rejected.
location="$(curl -sS -o /dev/null -w '%{redirect_url}' -G "${OIDC}/auth" \
  --data-urlencode "client_id=${CLIENT_ID}" --data-urlencode "response_type=code" \
  --data-urlencode "scope=openid" --data-urlencode "redirect_uri=${REDIRECT_URI}")"
if [[ "${location}" == *"error="* ]]; then pass "request without PKCE rejected"; else fail "request without PKCE accepted"; fi

# Redirects outside the allowed origin must be rejected.
status="$(curl -sS -o /dev/null -w '%{http_code}' -G "${OIDC}/auth" \
  --data-urlencode "client_id=${CLIENT_ID}" --data-urlencode "response_type=code" \
  --data-urlencode "scope=openid" --data-urlencode "redirect_uri=https://evil.example/callback" \
  --data-urlencode "code_challenge=abc" --data-urlencode "code_challenge_method=S256")"
if [ "${status}" = "400" ]; then pass "foreign redirect_uri rejected"; else fail "foreign redirect_uri returned HTTP ${status}"; fi

if [ "${failures}" -ne 0 ]; then
  echo "keycloak-check: ${failures} check(s) failed."
  exit 1
fi
echo "keycloak-check: all checks passed."
