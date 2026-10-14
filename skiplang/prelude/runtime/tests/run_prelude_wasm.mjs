// Usage: node run_prelude_wasm.mjs path/to/test.wasm [name filter]
import { readFileSync } from 'node:fs';
import { loadWasm } from '../../ts/wasm/dist/src/sk_types.js';
import { environment } from '../../ts/wasm/dist/src/sk_node.js';
import { init as runtime } from '../../ts/wasm/dist/src/sk_runtime.js';
import { init as posix } from '../../ts/wasm/dist/src/sk_posix.js';

const env = environment();
const runner = await loadWasm(
  readFileSync(process.argv[2]),
  [await runtime(env), await posix(env)],
  env,
);
const output = runner.main(process.argv.slice(3), '');
process.stdout.write(output);
