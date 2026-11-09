#!/usr/bin/env bash
# Applies apps/api/seeds/*.sql to the local PostgreSQL container, in order.
# Local development only.
set -euo pipefail

cd "$(dirname "$0")/.."

shopt -s nullglob
files=(apps/api/seeds/*.sql)

if [ ${#files[@]} -eq 0 ]; then
  echo "seed: no seed files in apps/api/seeds/ — nothing to apply."
  exit 0
fi

for file in "${files[@]}"; do
  echo "seed: applying ${file}"
  docker compose exec -T postgres sh -c \
    'psql -v ON_ERROR_STOP=1 --quiet -U "$POSTGRES_USER" -d "$POSTGRES_DB"' < "${file}"
done

echo "seed: done (${#files[@]} file(s))."
