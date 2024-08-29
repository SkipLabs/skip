
SKARGO_PROFILE?=release

../build/sknpm:
	cd .. && make build/sknpm

.PHONY: check-src
check-src:
	cd ts/src && npm install
	cd ts/src && tsc
	cd ts/src && npm run lint

.PHONY: check-all
check-all: check-src check

build: ../build/sknpm
	cd ts/examples && bun install
	../build/sknpm b -r --out-dir ts/examples/node_modules/skruntime

bunrun-%: ../build/sknpm
	cd ts/examples && bun install
	../build/sknpm b -r --out-dir ts/examples/node_modules/skruntime
	bun run ts/examples/wmain.ts -f ts/examples/$*.ts -m io

check: ../build/sknpm
	cd ts/examples && npm install
	../build/sknpm b -r --nowasm --out-dir ts/examples/node_modules/skruntime
	tsc --project ts/examples/tsconfig.json

noderun-%: ../build/sknpm
	cd ts/examples && npm install
	../build/sknpm b -r --out-dir ts/examples/node_modules/skruntime
	tsc --project ts/examples/tsconfig.json
	cd ts/examples && node dist/wmain.js -f dist/$*.js -m io

bunplay-%: ../build/sknpm
	cd ts/examples && bun install
	../build/sknpm b -r --out-dir ts/examples/node_modules/skruntime
	echo "play 1\nexit\n" | bun run ts/examples/wmain.ts -f ts/examples/$*.ts -m io

nodeplay-%: ../build/sknpm
	cd ts/examples && npm install
	../build/sknpm b -r --out-dir ts/examples/node_modules/skruntime
	tsc --project ts/examples/tsconfig.json
	cd ts/examples && echo "play 1\nexit\n" | node dist/wmain.js -f  dist/$*.js -m io

