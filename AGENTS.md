# AGENTS.md

Entry point for AI coding assistants other than Claude Code (Codex, Cursor, GitHub Copilot, Gemini CLI, Aider, …). Claude Code reads `CLAUDE.md` directly; everyone else starts here.

This file deliberately contains **no rules of its own** — it points to the single sources of truth, so nothing drifts.

## Read in this order

1. **[CLAUDE.md](CLAUDE.md)** — binding project rules: architecture, stack, phases, security, testing, definition of done, prohibited practices. Despite the name, it applies to every assistant and every human.
2. **[ROADMAP.md](ROADMAP.md)** — current state. Start with **"Session handoff"**: it says exactly where the last session stopped and what to do next.
3. **The skills for your task** — `.claude/skills/<name>/SKILL.md`. They are plain Markdown standards (ignore the YAML frontmatter if your tool does not use it). `CLAUDE.md` §20 and the orchestrator skill explain which skill applies to which task. Read only the relevant ones.
4. **Procedures** — `.claude/commands/*.md` are reusable step-by-step procedures (`plan-feature`, `implement-feature`, `fix-bug`, `review-code`, `validate-project`, `finish-task`, …). Follow them as checklists; `$ARGUMENTS` means "the task you were given".

## Non-negotiables (summary — CLAUDE.md wins on any conflict)

- Work only inside the current phase (see ROADMAP.md). Never start the next phase without explicit instruction.
- Before changing files: present a short plan (objective, scope, files, risks, tests, done criteria).
- Validate for real: `make validate` (and `make up`, `make migrate`, `make keycloak-check`, `make tf-apply-local` when relevant). Never claim "it should work".
- Never create real AWS resources or use real credentials; local Terraform/AWS CLI calls go to LocalStack only.
- Never commit secrets; `.env` is local only. Commit/push only when the owner asks.
- At the end of each increment: update ROADMAP.md (Done/Next and **Session handoff**), the phase document under `docs/product/phases/`, and README/runbooks if commands or URLs changed. Record important decisions as ADRs in `docs/adr/`.

## Quick start

```bash
cp .env.example .env
make bootstrap && make up && make migrate && make tf-apply-local && make seed
make validate
make help        # every available command
```
