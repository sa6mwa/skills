# AGENTS.md

## Scope

This repository is a library of **Agent Skills**. Each skill is defined by a directory containing a `SKILL.md` file with YAML front-matter and a Markdown body.

Skills are treated as a **stable interface** consumed by agents. Changes here propagate downstream and must preserve correctness, predictability, and verifiability.

## What counts as the “ABI”

The only hard ABI is the **YAML front-matter** at the top of `SKILL.md`.

The body of the document is intentionally flexible Markdown. Do not impose a rigid global section schema that would defeat progressive disclosure.

Agents must respect this distinction.

## Repository layout

Agents MUST follow this layout and must not invent new top-level conventions.

- `<skill-name>/`
  - `SKILL.md` (required)
  - `scripts/` (optional; deterministic helpers)
  - `references/` (optional; supporting documentation)
  - `assets/` (optional; templates, data files)
- `.infra/eval/` (optional; cross-skill regression prompts or fixtures, not part of skill payload)
- `README.md`
- `CHANGELOG.md`

Within a skill directory, prefer these directories over creating new ones unless there is a strong reason.

Top-level directory names reserved for repository infrastructure are:

- `.git`
- `.infra`

## Front-matter rules (non-negotiable)

Agents MUST ensure that `SKILL.md` front-matter is valid.

Required:
- `name`
- `description`

Rules:
- `name` must match the skill directory name
- lowercase letters, digits, and hyphens only
- no leading/trailing hyphen
- no consecutive hyphens

`description` must clearly communicate both **what the skill does** and **when it should be used**. Write it for routing and selection, not marketing.

Optional fields (if used) must remain concise and stable. Do not embed operational instructions in front-matter.

## Progressive disclosure discipline

Skills should be structured so that:

1. **Metadata** is cheap to load and sufficient for routing.
2. **Body content** is read only when the skill is activated.
3. **Referenced resources** are loaded only when required.

Implication: the `description` is an index key, not a tutorial.

## Body conventions (soft ABI)

While the body is free-form Markdown, this repository enforces **conventional structure** for clarity and machine usefulness.

Each skill body SHOULD include, in a readable order:

- Objective: a precise statement of intent
- Activation cues: signals or user phrases that should trigger the skill
- Procedure: step-by-step operational instructions
- Inputs and outputs: formats, examples, and invariants
- Failure modes: how errors are detected and handled
- Verification: how correctness is established
- References to local resources (scripts, assets, docs)

Avoid vague language. Replace “should” and “try” with explicit conditions and outcomes.

## File reference rules

When referencing other files from `SKILL.md`:

- Use relative paths from the skill root
- Keep reference depth shallow
- Do not chain references across many files

Skills should remain locally understandable.

## Safety and side effects

If a skill performs side effects (filesystem writes, network calls, destructive actions), the body MUST document:

- Preconditions
- Abort conditions
- Idempotency or non-idempotency
- Validation or dry-run behavior when feasible
- Tool or environment assumptions

Do not assume access to credentials, network, or binaries unless explicitly stated.

## Versioning and change discipline

If versioning is used, place it under `metadata`.

Treat changes to:
- expected inputs or outputs
- side effects
- procedural guarantees
as **breaking changes**.

Behavior must not drift silently. Update examples and verification guidance whenever behavior changes.

## Acceptance bar for changes

A skill may be added or modified only if:

- front-matter validates and matches directory name
- description is precise enough for routing
- body includes procedure and verification guidance
- all referenced resources exist

If a skill cannot be mechanically verified, it must define explicit observable acceptance criteria.

## Final note to agents

This repository is infrastructure.

Treat it as you would a public API, file format, or compiler interface.  
Ambiguity here becomes technical debt everywhere else.
