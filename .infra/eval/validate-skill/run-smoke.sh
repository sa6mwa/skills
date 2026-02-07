#!/bin/sh
set -eu

repo_root="$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)"
validator="$repo_root/validate-skill/scripts/validate-skill"

if [ ! -x "$validator" ]; then
  echo "error: validator not executable: $validator" >&2
  exit 1
fi

echo "[1/3] validating in-repo skills"
(
  cd "$repo_root"
  "$validator" subsystem-architecture-audit/SKILL.md
  "$validator" validate-skill/SKILL.md
)

tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT INT TERM

echo "[2/3] validating known-good fixture"
cp -R "$repo_root/.infra/eval/validate-skill/fixtures/valid-skill" "$tmp_root/valid-skill"
(
  cd "$tmp_root"
  "$validator" valid-skill/SKILL.md
)

echo "[3/3] validating known-bad fixture (expect failure)"
cp -R "$repo_root/.infra/eval/validate-skill/fixtures/invalid-name" "$tmp_root/invalid-name"
if (
  cd "$tmp_root"
  "$validator" invalid-name/SKILL.md
); then
  echo "error: invalid fixture unexpectedly passed validation" >&2
  exit 1
fi

echo "ok: validate-skill smoke eval passed"
