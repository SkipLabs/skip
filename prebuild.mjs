import * as fs from "fs";
import * as path from "path";
import { fileURLToPath } from "url";

const symlinks = {
  "skiplang-std": "./skiplang/prelude/ts/binding/src",
  "skipwasm-std": "./skiplang/prelude/ts/wasm/src",
  "skipwasm-date": "./skiplang/skdate/ts/src",
  "skiplang-json": "./skiplang/skjson/ts/binding/src",
  "skipwasm-json": "./skiplang/skjson/ts/wasm/src",
};

const filename = fileURLToPath(import.meta.url);
const dirname = path.dirname(filename);

export function link(packages) {
  for (const [simlink, target] of Object.entries(symlinks)) {
    if (!packages.has(simlink)) continue;
    if (!fs.existsSync(simlink)) {
      fs.symlinkSync(path.resolve(dirname, target), simlink, "dir");
    }
  }
}

if (process.argv.length <= 2) {
  const thisBin = process.argv[1];
  console.log(`Usage: ${thisBin} <worspace-package>...`);
  process.exit(0);
}

const packages = new Set(process.argv.slice(2));

link(packages);
