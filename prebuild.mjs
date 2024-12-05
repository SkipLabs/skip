import * as fs from "fs";
import * as path from "path";
import { fileURLToPath } from "url";

const symlinks = {
  "skiplang-std": "./skiplang/prelude/ts/binding/src",
  "skipwasm-std": "./skiplang/prelude/ts/wasm/src",
  "skipwasm-worker": "./skiplang/prelude/ts/worker/src",
  "skipwasm-date": "./skiplang/skdate/ts/src",
  "skiplang-json": "./skiplang/skjson/ts/binding/src",
  "skipwasm-json": "./skiplang/skjson/ts/wasm/src",
  "skipwasm-monitor": "./skiplang/skmonitor/ts/src",
};

const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);

export function link(packages) {
  for (const [symlink, target] of Object.entries(symlinks)) {
    if (!packages.has(symlink)) continue;
    const rand = new Uint32Array(1);
    crypto.getRandomValues(rand);
    const tmp = "tmp" + rand.toString("hex");
    fs.symlinkSync(path.resolve(dirname, target), tmp, "dir");
    fs.renameSync(tmp, symlink);
  }
}

if (process.argv.length <= 2) {
  const thisBin = process.argv[1];
  console.log(`Usage: ${thisBin} <worspace-package>...`);
  process.exit(0);
}

const packages = new Set(process.argv.slice(2));

link(packages);
