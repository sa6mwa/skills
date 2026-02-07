---
name: subsystem-architecture-audit
description: Analyze a repository by subsystem to document purpose and architecture, identify non-style quality improvements, and produce a prioritized, testable chunked TODO plan.
license: MIT
metadata:
  author: shared
  version: "0.1"
---

# Objective

Produce subsystem-level analysis that is actionable for implementation and closeout:

- Explain each subsystem's purpose.
- Explain architectural and programmatic behavior from real code paths.
- Identify concrete quality improvements (bug fixes, security hardening, reliability, correctness, performance, operability), not style edits.
- Convert findings into a descending-priority TODO with chunked, testable implementation gates.

# Activation Cues

Use this skill when the user asks for any combination of:

- "analyze this repo deeply"
- "document subsystem architecture / behavior"
- "find improvements (not style)"
- "create a prioritized TODO/roadmap from analysis"
- "chunk implementation with targeted tests before full suites"

# Inputs

Required:

- Repository root path.
- Output location for subsystem docs (for example `docs/subsystems/`).

Optional but recommended:

- Existing architecture docs and runbooks.
- Required quality gates (unit, lint, integration commands).
- Constraints on integration test runtime and batching strategy.

# Procedure

1. Confirm scope and constraints before bulk edits.
2. Build the inventory:
   - Discover documentation: `rg --files -g '*.md'`.
   - Discover candidate subsystem boundaries from package/layout and entrypoints.
3. Propose subsystem map and get alignment if boundaries are ambiguous.
4. For each subsystem, analyze docs and code together:
   - Purpose and responsibility boundaries.
   - Entry points, interfaces, key types, core flows.
   - Data/consistency model and error handling paths.
   - Concurrency, retries, idempotency, and failure behavior.
   - Existing tests and verification signal.
5. Draft one markdown file per subsystem at `docs/subsystems/<subsystem>.md`.
   - Start from `assets/subsystem-report-template.md`.
6. Record improvement candidates:
   - Include at least 3 non-style, non-"new feature" improvements backed by evidence.
   - Add optional feature improvements only after core quality items.
7. Build prioritized execution plan in `TODO.md`:
   - Descending priority with `- [ ]` checklist items.
   - Group into chunks that can be validated with unit tests + targeted integration suites.
   - Defer full integration sweep to a release gate.
   - Start from `assets/todo-priority-template.md`.
8. Verify artifacts and consistency:
   - Every subsystem doc exists and follows required sections.
   - TODO entries are testable and include concrete validation commands or suites.
9. Finalize after chunk implementation is complete:
   - Append an implementation summary to `CHANGELOG.md` with completed chunks and commit references (`<hash> <message>`).
   - Remove `TODO.md` when all planned chunks are complete.
   - Update each subsystem doc's non-style improvement section from proposed findings to implemented changes.
   - Keep unresolved items under feature-aligned improvements or follow-up notes.

# Output Contract

Primary outputs:

- `docs/subsystems/<subsystem>.md` for each subsystem in scope.
- `TODO.md` with descending, test-gated checklist chunks.

Finalization outputs (after implementation completion):

- `CHANGELOG.md` appended with chunk summary and commit list.
- `TODO.md` removed once all chunk items are complete.
- Subsystem docs updated so Section 3 reflects landed fixes instead of proposed fixes.

Each subsystem doc must include:

- Purpose
- Architecture and programmatic details
- Quality improvements (non-style; concrete and testable)
- Optional feature improvements aligned to current feature set

# Improvement Quality Bar

Do not count these as improvements:

- Pure naming/style cleanups.
- Reformatting-only changes.
- New features presented as bug fixes without evidence of defect/risk.

Valid improvements are tied to one or more:

- Correctness bug or latent bug.
- Security exposure or weak default.
- Reliability/availability failure mode.
- Data consistency/integrity risk.
- Significant performance/operability issue with measurable impact.

# Failure Modes

- Unclear subsystem boundaries:
  - Pause and ask for alignment before generating many files.
- Insufficient evidence for a claimed issue:
  - Label as hypothesis and include a validation step instead of asserting as fact.
- Overly broad TODO chunks:
  - Split by regression boundary so targeted tests can isolate failures.
- Missing docs for part of codebase:
  - Derive from code and explicitly mark "code-derived" assumptions.

# Verification

Minimum verification:

1. Structural:
   - Subsystem docs exist under the requested output path.
   - Each includes the required sections.
2. Content:
   - Improvements are concrete, non-style, and reference observable behavior or code locations.
3. Plan quality:
   - `TODO.md` is descending priority, checklist format, and each chunk has a test gate.
4. If implementation is requested:
   - Per chunk: unit tests + targeted integration suites.
   - Once all chunks land: full gate (`go test ./...`, lint/vet, full integration suites as applicable).
5. If finalization is requested:
   - Confirm changelog entry exists and includes chunks plus commit hashes/messages.
   - Confirm `TODO.md` is removed only when all chunk items are done.
   - Confirm subsystem docs reflect implemented improvements, not speculative ones.

# Local Resources

- `assets/subsystem-report-template.md`
- `assets/todo-priority-template.md`
