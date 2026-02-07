# TODO

Use descending priority from top to bottom.

- [ ] P0 / Chunk 1: <Highest-risk quality fix group>. Scope: <bounded scope>. Unit tests: `<cmd>`. Targeted integration: `<cmd>`. Regression boundary: <what this chunk can break>.
- [ ] P0 / Chunk 2: <Next highest-risk quality fix group>. Scope: <bounded scope>. Unit tests: `<cmd>`. Targeted integration: `<cmd>`. Regression boundary: <what this chunk can break>.
- [ ] P1 / Chunk 3: <Medium priority fix group>. Scope: <bounded scope>. Unit tests: `<cmd>`. Targeted integration: `<cmd>`. Regression boundary: <what this chunk can break>.
- [ ] P1 / Chunk 4: <Medium priority fix group>. Scope: <bounded scope>. Unit tests: `<cmd>`. Targeted integration: `<cmd>`. Regression boundary: <what this chunk can break>.
- [ ] P2 / Chunk N: <Lower priority hardening/backfill>. Scope: <bounded scope>. Unit tests: `<cmd>`. Targeted integration: `<cmd>`. Regression boundary: <what this chunk can break>.
- [ ] Release gate: run full verification once after all chunks land together (`go test ./...`, `go vet ./...`, project lint, full integration suite).
