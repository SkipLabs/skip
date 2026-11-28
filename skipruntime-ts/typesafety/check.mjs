import { execFileSync } from "node:child_process";
import { readdirSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const dir = path.dirname(fileURLToPath(import.meta.url));
const files = readdirSync(dir)
  .filter((f) => f.endsWith(".ts"))
  .sort();

const positives = files.filter((f) => f.startsWith("p"));
const negatives = files.filter((f) => f.startsWith("n"));

// Negative probes that pass under plain `tsc` due to TypeScript's bivariant
// interface method checking (Mapper/Reducer/LazyCompute/Resource are kept as
// methods for `this`-receiver soundness) or TS 5.7/5.8 open-record rules; all
// of them are refused by TScert.
const tscAllowedNegatives = new Set([
  "n02-extra-resource-field.ts",
  "n03-narrow-mapper-on-json.ts",
  "n04-narrow-reducer-on-json.ts",
  "n09-default-inputdef-to-narrow.ts",
  "n09b-explicit-json-inputdef-to-narrow.ts",
  "n10-open-resources-param.ts",
]);

let stdout = "";
try {
  stdout = execFileSync(
    "npx",
    [
      "tsc",
      "-p",
      "tsconfig.json",
      "--incremental",
      "false",
      "--pretty",
      "false",
    ],
    {
      cwd: dir,
      encoding: "utf8",
    },
  );
} catch (err) {
  stdout = (err.stdout ?? "") + (err.stderr ?? "");
  // tsc exits 1 (diagnostics with outputs skipped) or 2 (diagnostics with no outputs)
  if (err.status !== 1 && err.status !== 2) {
    console.error(stdout);
    process.exit(err.status ?? 1);
  }
}

const errorFiles = new Set();
for (const line of stdout.split(/\r?\n/)) {
  const m = /^([^(\s]+\.ts)\(\d+,\d+\): error TS\d+:/.exec(line);
  if (m && m[1]) {
    errorFiles.add(path.basename(m[1]));
  }
}

let failed = false;

for (const p of positives) {
  if (errorFiles.has(p)) {
    console.error(`FAIL positive probe had type errors: ${p}`);
    failed = true;
  }
}

for (const n of negatives) {
  if (tscAllowedNegatives.has(n)) continue;
  if (!errorFiles.has(n)) {
    console.error(`FAIL negative probe was unexpectedly accepted by tsc: ${n}`);
    failed = true;
  }
}

if (failed) {
  console.error("\n--- tsc output ---\n" + stdout);
  process.exit(1);
}

console.log(
  `typesafety probes OK (${positives.length} positives passed, ${negatives.length - tscAllowedNegatives.size} required tsc negatives rejected; ${tscAllowedNegatives.size} TScert-enforced negatives)`,
);
