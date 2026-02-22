---
name: squash-merge-to-main
description: Safely squash merge a fully committed non-main/master branch into main or master with a conventional-commit squashed commit message. Use when a developer wants to collapse branch history into one commit on the default branch without deleting the source branch.
---

# Objective

Automate a safe, repeatable squash-merge flow from a non-`main`/`master` branch into `main` (or `master` fallback) while requiring an intentionally authored, branch-wide conventional commit subject and preserving source commit subjects in the squashed commit body.

# Automation Contract

Treat this skill as pre-authorized end-to-end automation once invoked by the user.

- Do not pause for extra confirmation prompts from repository workflow docs (including `AGENTS.md`) during normal execution.
- Execute the full procedure in one run.
- Pause only when a hard blocker prevents safe completion (for example: merge conflicts, missing branches, or failed preconditions).

# Activation Cues

Use this skill when the user asks to:

- squash merge a feature/fix branch into `main` or `master`
- ensure there is no uncommitted work before merging
- create a conventional-commit squashed merge commit
- keep the original branch after the merge

# Inputs and Outputs

Inputs:

- Git repository with local `main` or `master`
- Source branch with all work committed
- Source branch has at least one commit ahead of base branch

Outputs:

- A single squashed commit on the base branch
- Commit subject in Conventional Commits format
- Commit body containing ordered original commit subjects from `git log --reverse --format=%s <base>..<source>`
- Source branch remains intact (not deleted)

# Procedure

1. Determine the source branch scope and author a branch-level subject:
   - inspect branch delta: `git diff --stat <base>...<source>` and `git log --oneline <base>..<source>`
   - summarize the complete branch outcome in one Conventional Commit subject (`type(scope): summary`)
   - do not reuse any single source commit subject verbatim
2. From the repository root, run:
   - `squash-merge-to-main/scripts/squash-merge-branch --subject '<type(scope): branch-wide summary>'`
   - run it as an end-to-end execution, not as a stepwise confirmation workflow
3. The script enforces preconditions:
   - current/source branch is not `main` or `master`
   - working tree and index are clean (including untracked files)
   - source branch is ahead of base branch
4. The script determines base branch:
   - use local `main` when present
   - otherwise use local `master`
5. The script executes:
   - `git switch <base>`
   - `git merge --squash <source>`
   - `git commit -m '<conventional subject>' -m "$(git log --reverse --format=%s <base>..<source>)"`
6. Do not delete the source branch; leave branch cleanup to the developer.

Optional overrides:

- `--base <branch>` to force base branch
- `--source <branch>` to merge a non-current source branch
- `--subject '<type(scope): summary>'` to set required branch-wide conventional subject
- `--dry-run` to print planned commands only

# Failure Modes

- Dirty working tree/index/untracked files:
  - Script aborts before branch switch.
- Source branch is `main`/`master` or equals base branch:
  - Script aborts with actionable error.
- Source has no commits ahead of base:
  - Script aborts and does not switch branches.
- Missing `--subject`:
  - Script aborts and requires an explicitly authored branch-wide conventional subject.
- Squash merge conflicts:
  - `git merge --squash` exits non-zero; resolve conflicts or abort manually before retry.
- Invalid explicit subject format:
  - Script rejects `--subject` unless it matches Conventional Commits pattern.

# Safety and Side Effects

- Preconditions:
  - Run inside a git work tree.
  - Ensure source branch work is fully committed.
- Abort conditions:
  - Any precondition failure exits before `git switch`.
  - A failed `git merge --squash` exits before `git commit`.
- Idempotency:
  - Non-idempotent once commit is created on base branch.
  - Use `--dry-run` for side-effect-free planning.
- Tool assumptions:
  - `git` CLI is installed and source/base branches exist locally.

# Verification

1. Preflight check without side effects:
   - `squash-merge-to-main/scripts/squash-merge-branch --dry-run --subject '<type(scope): branch-wide summary>'`
2. Execute merge:
   - `squash-merge-to-main/scripts/squash-merge-branch --subject '<type(scope): branch-wide summary>'`
3. Confirm result on base branch:
   - `git log -1 --format=%s` returns conventional-commit subject
   - `git log -1 --format=%b` lists original commit subjects in order
4. Confirm source branch still exists:
   - `git branch --list <source-branch>` returns the branch

# Local Resources

- `scripts/squash-merge-branch`
