# Instructions to build & run skdb-cli

1. Build `sknpm` from the repo root: `make -C ../.. build/sknpm`
2. Use `sknpm` to build the typescript project: `../../build/sknpm build`
3. Install external dependencies: `(cd ../target/wasm32/dev/npm && npm install)`
4. Run with `sknpm`: `../../build/sknpm run -- cli -- <args>`
