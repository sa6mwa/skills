# Agent Skills Repository

This repository is a curated library of **Agent Skills**: small, composable, versioned capabilities intended to be loaded by agents via a spec-compliant `SKILL.md` (YAML front-matter + Markdown body).

Skills are an API surface. Selection is driven by front-matter metadata; operational detail lives in the Markdown body and referenced resources.

## Repository layout

- AGENTS.md
- CHANGELOG.md
- README.md
- `<skill-name>`/
  - SKILL.md
  - scripts/ (optional)
  - references/ (optional)
  - assets/ (optional)
- .infra/
  - eval/
    - `<skill-name>`/ (optional per-skill eval fixtures and smoke checks)

## Skill format

Each `SKILL.md` must begin with YAML front-matter delimited by `---` and include at minimum:

- `name`
- `description`

`name` must:
- match the directory name `<name>/`
- use only `a-z`, `0-9`, and `-`
- avoid leading/trailing hyphens and consecutive hyphens
- be 1–64 characters

`description` must:
- be 1–1024 characters
- describe what the skill does and when to use it (routing signal, not marketing)

The Markdown body is free-form, but should be operational: procedure, inputs/outputs, failure modes, verification, and any resource references.

## Adding a new skill

1. Create a directory:

```
mkdir -p <skill-name>
```

2. Add `<skill-name>/SKILL.md` with valid front-matter:

```
---
name: <skill-name>
description: <what it does and when to use it>
license: MIT
metadata:
  author: <you-or-org>
  version: "0.1"
---
```

3. Add optional resources:
- `scripts/` for deterministic helpers
- `assets/` for templates/data
- `references/` for supporting notes

4. Validate:

```
validate-skill/scripts/validate-skill <skill-name>/SKILL.md
```

## Validation

Run:

```
validate-skill/scripts/validate-skill <skill-name>/SKILL.md
```

The validator is intentionally strict about canonical paths (it refuses to validate random files) and validates the minimal routing-critical front-matter invariants.

It does not attempt to fully parse YAML; multi-line YAML constructs may be warned about and are discouraged for routing-critical fields.

## Design guidance

Defaults that keep the library useful at scale:

- Prefer narrow, composable skills over “do everything” skills.
- Make side effects explicit (writes, network calls, destructive operations).
- Document failure modes and abort conditions.
- Prefer deterministic procedures; if nondeterministic, define acceptance criteria.
- Include verification guidance: how an agent can prove the result is correct.
- Keep evaluation artifacts under `.infra/eval/` so installer-facing skill directories stay runtime-focused.

## Links

- AgentSkills specification: <https://agentskills.io/specification>

## Current skills

- `subsystem-architecture-audit`
  - Path: `subsystem-architecture-audit/SKILL.md`
  - Use when you need repository-wide subsystem analysis, architecture/behavior documentation, quality-attribute improvement discovery, and a prioritized chunked TODO plan with targeted test gates.
- `validate-skill`
  - Path: `validate-skill/SKILL.md`
  - Use when you need deterministic validation of a skill's canonical path and `SKILL.md` front-matter invariants.
- `squash-merge-to-main`
  - Path: `squash-merge-to-main/SKILL.md`
  - Use when you need to squash-merge a fully committed non-main/master branch into `main` or `master` with a conventional-commit squashed commit while keeping the source branch.
