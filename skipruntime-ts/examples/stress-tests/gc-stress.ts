import type {
  EagerCollection,
  Json,
  Mapper,
  Resource,
  ServiceInstance,
  SkipService,
  Values,
} from "@skipruntime/core";
import { initService } from "@skipruntime/native";

// Service definition

type StressInputs = { input: EagerCollection<string, number> };

class StressResource implements Resource<StressInputs> {
  private readonly value: number;

  constructor(params: Json) {
    const v = (params as { value: number }).value;
    this.value = v;
  }

  instantiate(cs: StressInputs): EagerCollection<string, number> {
    void this.value;
    return cs.input;
  }
}

class IdentityMapper implements Mapper<string, number, string, number> {
  mapEntry(key: string, values: Values<number>): Iterable<[string, number]> {
    const out: [string, number][] = [];
    for (const v of values) out.push([key, v]);
    return out;
  }
}

class StressResourceWithMap implements Resource<StressInputs> {
  private readonly value: number;

  constructor(params: Json) {
    this.value = (params as { value: number }).value;
  }

  instantiate(cs: StressInputs): EagerCollection<string, number> {
    void this.value;
    return cs.input.map(IdentityMapper);
  }
}

class StressResourceWithNMaps implements Resource<StressInputs> {
  private readonly value: number;
  private readonly n: number;

  constructor(params: Json) {
    const obj = params as { value: number; n: number };
    this.value = obj.value;
    this.n = obj.n;
  }

  instantiate(cs: StressInputs): EagerCollection<string, number> {
    void this.value;
    let result = cs.input;
    for (let i = 0; i < this.n; i++) {
      result = result.map(IdentityMapper);
    }
    return result;
  }
}

let runtimeGcLogs = false;

const stressService: SkipService<StressInputs, StressInputs> = {
  initialData: { input: [] },
  resources: {
    stress: StressResource,
    stressWithMap: StressResourceWithMap,
    stressWithNMaps: StressResourceWithNMaps,
  },
  createGraph: (inputs: StressInputs) => inputs,
  gcConfig: () => ({
    enabled: true,
    ttlMillis: 30_000,
    maxGarbageSize: 100,
    logsEnabled: runtimeGcLogs,
  }),
};

// CLI arg parsing

type Options = {
  full: boolean;
  trace: boolean;
  gcLogs: boolean;
};

function parseArgs(): Options {
  const args = process.argv.slice(2);
  const opts: Options = { full: false, trace: false, gcLogs: false };
  for (const arg of args) {
    if (arg === "-f" || arg === "--full") opts.full = true;
    else if (arg === "--trace") opts.trace = true;
    else if (arg === "--gclogs") opts.gcLogs = true;
    else if (arg === "-h" || arg === "--help") {
      console.log("Usage: gc-stress [options]");
      console.log("  -f, --full     Run long, exhaustive tests");
      console.log("      --trace    Print intermediate memory measurements");
      console.log("      --gclogs   Enable internal GC logs");
      console.log("  -h, --help     Show this help");
      process.exit(0);
    }
  }
  return opts;
}

// Measurement and slope calculation

type Point = { cycle: number; skipMem: number };

type TestResult = {
  name: string;
  cycles: number;
  startMem: number;
  endMem: number;
  minStable: number;
  maxStable: number;
  avgStable: number;
  slope: number;
  threshold: number;
  passed: boolean;
  durationSec: number;
};

// Least squares linear regression. Returns slope in y-units per x-unit.
function linearSlope(points: Point[]): number {
  const n = points.length;
  if (n < 2) return 0;
  const meanX = points.reduce((s, p) => s + p.cycle, 0) / n;
  const meanY = points.reduce((s, p) => s + p.skipMem, 0) / n;
  let num = 0,
    den = 0;
  for (const p of points) {
    num += (p.cycle - meanX) * (p.skipMem - meanY);
    den += (p.cycle - meanX) * (p.cycle - meanX);
  }
  return den === 0 ? 0 : num / den;
}

function fmtBytes(n: number): string {
  if (Math.abs(n) >= 1024 * 1024) return (n / 1024 / 1024).toFixed(2) + " MB";
  if (Math.abs(n) >= 1024) return (n / 1024).toFixed(2) + " KB";
  return n.toFixed(0) + " B";
}

// Test runner

async function runMemoryTest(
  service: ServiceInstance,
  testName: string,
  resourceName: string,
  resourceParams: (i: number) => Json,
  cycles: number,
  threshold: number,
  opts: Options,
): Promise<TestResult> {
  const startTime = Date.now();
  const points: Point[] = [];
  const numMeasurements = 20;
  const measureInterval = Math.max(1, Math.floor(cycles / numMeasurements));

  const startMem = service.getSkipPersistentSize();
  points.push({ cycle: 0, skipMem: startMem });

  if (opts.trace) {
    console.log(`  [${testName}] cycle 0: skipMem=${fmtBytes(startMem)}`);
  }

  for (let i = 0; i < cycles; i++) {
    const uuid = `${testName}-${i}`;
    await service.instantiateResource(uuid, resourceName, resourceParams(i));
    service.closeResourceInstance(uuid);

    if ((i + 1) % measureInterval === 0) {
      const mem = service.getSkipPersistentSize();
      points.push({ cycle: i + 1, skipMem: mem });
      if (opts.trace) {
        console.log(`  [${testName}] cycle ${i + 1}: skipMem=${fmtBytes(mem)}`);
      }
    }
  }

  const endMem = service.getSkipPersistentSize();
  const lastPoint = points[points.length - 1];
  if (lastPoint && lastPoint.cycle !== cycles) {
    points.push({ cycle: cycles, skipMem: endMem });
  }

  // Ignore first 10% to skip warmup oscillations
  const skipCount = Math.floor(points.length * 0.1);
  const stablePoints = points.slice(skipCount);
  const slope = linearSlope(stablePoints);

  const durationSec = (Date.now() - startTime) / 1000;

  // Compute stats on the stable phase (post-warmup)
  const stableMems = stablePoints.map((p) => p.skipMem);
  const minStable = Math.min(...stableMems);
  const maxStable = Math.max(...stableMems);
  const avgStable = stableMems.reduce((s, m) => s + m, 0) / stableMems.length;

  return {
    name: testName,
    cycles,
    startMem,
    endMem,
    minStable,
    maxStable,
    avgStable,
    slope,
    threshold,
    passed: Math.abs(slope) <= threshold,
    durationSec,
  };
}

function printResult(result: TestResult): void {
  const symbol = result.passed ? "✓" : "✗";
  const status = result.passed ? "PASS" : "FAIL";

  let analysis: string;
  if (result.passed) {
    analysis = "stable memory usage, oscillates within a fixed range";
  } else {
    const kbPer1k = (result.slope * 1000) / 1024;
    analysis = `linear growth of ~${result.slope.toFixed(0)} bytes/cycle (~${kbPer1k.toFixed(1)} KB per 1000 cycles)`;
  }

  console.log(`[${result.name}]`);
  console.log(`  cycles:        ${result.cycles}`);
  console.log(
    `  initial mem:   ${fmtBytes(result.startMem)} (before any operations)`,
  );
  console.log(
    `  stable mem:    min=${fmtBytes(result.minStable)}, max=${fmtBytes(result.maxStable)}, avg=${fmtBytes(result.avgStable)} (during operations)`,
  );
  console.log(`  final mem:     ${fmtBytes(result.endMem)}`);
  console.log(
    `  slope:         ${result.slope >= 0 ? "+" : ""}${result.slope.toFixed(2)} bytes/cycle (threshold: ±${result.threshold} bytes/cycle)`,
  );
  console.log(`  analysis:      ${analysis}`);
  console.log(`  duration:      ${result.durationSec.toFixed(1)}s`);
  console.log(`  RESULT:        ${status} ${symbol}`);
  console.log("");
}

// Main

async function main(): Promise<void> {
  const opts = parseArgs();

  const numTests = opts.full ? 3 : 2;
  const estimatedDuration = opts.full ? "3-5 minutes" : "30-60 seconds";

  console.log(
    "==================================================================",
  );
  console.log(
    `gc-stress: regression test for Skip memory leaks${opts.full ? " (full mode)" : ""}`,
  );
  console.log(
    "==================================================================",
  );
  console.log("");
  console.log(
    `Running ${numTests} test${numTests > 1 ? "s" : ""}, estimated duration: ${estimatedDuration}.`,
  );
  if (!opts.trace) {
    console.log(
      "Tests run silently. Use --trace to see intermediate measurements.",
    );
  }
  console.log("");

  runtimeGcLogs = opts.gcLogs;
  const service = await initService(stressService);

  const results: TestResult[] = [];
  const totalStart = Date.now();

  // ---- Default tests ----

  const readsLeakCycles = opts.full ? 200_000 : 30_000;
  results.push(
    await runMemoryTest(
      service,
      "instantiate-close-no-map",
      "stress",
      (i) => ({ value: i }),
      readsLeakCycles,
      100,
      opts,
    ),
  );

  const deletedDirCycles = opts.full ? 200_000 : 30_000;
  results.push(
    await runMemoryTest(
      service,
      "instantiate-close-with-map",
      "stressWithMap",
      (i) => ({ value: i }),
      deletedDirCycles,
      100,
      opts,
    ),
  );

  // ---- Full mode extra test ----

  if (opts.full) {
    results.push(
      await runMemoryTest(
        service,
        "instantiate-close-with-5-maps",
        "stressWithNMaps",
        (i) => ({ value: i, n: 5 }),
        200_000,
        500, // higher threshold for stacked maps (more allocations, more variance)
        opts,
      ),
    );
  }

  // ---- Results ----

  console.log("");
  console.log(
    "==================================================================",
  );
  console.log("Results");
  console.log(
    "==================================================================",
  );
  console.log("");

  for (const result of results) {
    printResult(result);
  }

  const passed = results.filter((r) => r.passed).length;
  const total = results.length;
  const totalDuration = (Date.now() - totalStart) / 1000;
  const overallPass = passed === total;

  console.log(
    "==================================================================",
  );
  console.log(
    `Overall: ${overallPass ? "PASS ✓" : "FAIL ✗"} (${passed}/${total} tests passed) in ${totalDuration.toFixed(1)}s`,
  );
  console.log(
    "==================================================================",
  );

  await service.close();

  process.exit(overallPass ? 0 : 1);
}

main().catch((err: unknown) => {
  console.error("[gc-stress] fatal error:", err);
  process.exit(2);
});
