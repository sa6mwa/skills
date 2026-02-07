---
name: validate-skill
description: Validate a skill directory at repository top-level by checking SKILL.md front-matter fields, naming rules, and canonical path layout.
license: MIT
metadata:
  author: shared
  version: "0.1"
---

# Objective

Provide deterministic validation for skill metadata and canonical layout so skills remain routable and stable.

# Activation Cues

Use this skill when the user asks to:

- validate a new or edited skill
- check SKILL.md front-matter correctness
- confirm naming/layout compliance before commit

# Inputs

Required:

- Path to a `SKILL.md` file in canonical repo layout: `<skill-name>/SKILL.md`.

# Procedure

1. Run:
   - `validate-skill/scripts/validate-skill <skill-name>/SKILL.md`
2. If validation fails:
   - Fix the reported path/front-matter issues.
   - Re-run until clean exit.
3. If adding or renaming a skill:
   - Validate every changed `SKILL.md`.

# Validation Guarantees

The script checks:

- Canonical path format: `<skill-name>/SKILL.md`
- Required front-matter fields: `name`, `description`
- `name` constraints:
  - 1-64 chars
  - lowercase letters, digits, hyphens
  - no leading/trailing hyphen
  - no consecutive hyphens
- `name` equals skill directory name
- `description` length: 1-1024 chars
- Front-matter delimiter presence (`---` start/end)

# Failure Modes

- Multi-line/complex YAML front-matter may produce warnings because only simple key/value validation is performed.
- Non-canonical file paths are rejected even if content is valid.

# Verification

For each changed skill:

1. Run validator.
2. Confirm zero exit code.
3. Confirm no unresolved errors in output.

# Local Resources

- `scripts/validate-skill`
