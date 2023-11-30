# Instructions to build & run skdb-cli

Relative to `/path/to/skdb_repo/sql/ts/` (i.e. the directory with this README
in):

1. Build `sknpm` with `make -C ../.. build/sknpm`
2. Build the CLI: `../../build/sknpm build`
3. Run the CLI: `../../build/sknpm run -- cli -- <args>`
