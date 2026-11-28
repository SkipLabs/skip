import { expect } from "earl";
import type { Entry, Json } from "@skipruntime/core";
import { SkipUnknownResourceError } from "@skipruntime/core";
import { PolledExternalService } from "@skipruntime/helpers";
import { describe, it, beforeEach, afterEach } from "mocha";

type FetchHandler = (
  input: string | URL | Request,
  init?: RequestInit,
) => Promise<Response> | Response;

function jsonResponse(body: Json | null, status = 200): Response {
  if (body === null) {
    return new Response("", { status, statusText: "OK" });
  }
  return new Response(JSON.stringify(body), {
    status,
    statusText: "OK",
    headers: { "Content-Type": "application/json" },
  });
}

function wait(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function waitFor(
  predicate: () => boolean,
  timeoutMs = 2000,
): Promise<void> {
  const deadline = Date.now() + timeoutMs;
  while (!predicate()) {
    if (Date.now() >= deadline) {
      throw new Error(`Timed out after ${timeoutMs}ms waiting for condition`);
    }
    await wait(5);
  }
}

async function withCapturedConsoleError(
  f: (calls: unknown[][]) => Promise<void>,
): Promise<void> {
  const calls: unknown[][] = [];
  const orig = console.error;
  console.error = (...args: unknown[]) => {
    calls.push(args);
  };
  try {
    await f(calls);
  } finally {
    console.error = orig;
  }
}

function convValue(data: Json): Entry<Json, Json>[] {
  return [["value", [data]]];
}

describe("PolledExternalService unit tests", function () {
  const origFetch = globalThis.fetch;
  let fetchHandler: FetchHandler;
  let requestedUrls: string[];
  let servicesToClean: PolledExternalService[];

  beforeEach(function () {
    requestedUrls = [];
    servicesToClean = [];
    fetchHandler = () => jsonResponse({ ok: true });
    globalThis.fetch = (async (
      input: string | URL | Request,
      init?: RequestInit,
    ) => {
      const url =
        typeof input === "string"
          ? input
          : input instanceof URL
            ? input.toString()
            : input.url;
      requestedUrls.push(url);
      return await fetchHandler(input, init);
    }) as typeof fetch;
  });

  afterEach(async function () {
    for (const service of servicesToClean) {
      await service.shutdown();
    }
    globalThis.fetch = origFetch;
  });

  function track(service: PolledExternalService): PolledExternalService {
    servicesToClean.push(service);
    return service;
  }

  it("throws SkipUnknownResourceError for an unknown resource", async function () {
    const service = track(new PolledExternalService({}));
    await expect(
      service.subscribe(
        "inst-1",
        "missing",
        {},
        {
          update: () => Promise.resolve(),
          error: () => {},
        },
      ),
    ).toBeRejectedWith(SkipUnknownResourceError);
  });

  it("supports a fixed numeric polling interval", async function () {
    let count = 0;
    fetchHandler = () => jsonResponse({ n: ++count });

    const service = track(
      new PolledExternalService({
        items: {
          url: "http://example.test/items",
          interval: 20,
          conv: convValue,
        },
      }),
    );

    const updates: { entries: Entry<Json, Json>[]; isInit: boolean }[] = [];
    await service.subscribe(
      "inst-1",
      "items",
      { id: 1 },
      {
        update: (entries, isInit) => {
          updates.push({ entries, isInit });
          return Promise.resolve();
        },
        error: () => {},
      },
    );

    expect(updates.length).toEqual(1);
    expect(updates[0]).toEqual({
      entries: [["value", [{ n: 1 }]]],
      isInit: true,
    });
    expect(requestedUrls[0]).toEqual("http://example.test/items?id=1");

    await waitFor(() => updates.length >= 3);
    service.unsubscribe("inst-1");

    expect(updates[1]?.isInit).toEqual(false);
    expect(updates[2]?.isInit).toEqual(false);
    expect(updates[1]?.entries).toEqual([["value", [{ n: 2 }]]]);
    expect(updates[2]?.entries).toEqual([["value", [{ n: 3 }]]]);
  });

  it("supports a polling interval function based on params", async function () {
    const fastHits: number[] = [];
    const slowHits: number[] = [];
    fetchHandler = (input) => {
      const url = typeof input === "string" ? input : "";
      if (url.includes("tier=fast")) {
        fastHits.push(Date.now());
      } else {
        slowHits.push(Date.now());
      }
      return jsonResponse({ url });
    };

    const seenParams: Json[] = [];
    const service = track(
      new PolledExternalService({
        feed: {
          url: "http://example.test/feed",
          interval: (params) => {
            seenParams.push(params);
            const tier =
              typeof params === "object" && !Array.isArray(params)
                ? params["tier"]
                : undefined;
            return tier === "fast" ? 15 : 150;
          },
          conv: convValue,
        },
      }),
    );

    const noop = {
      update: () => Promise.resolve(),
      error: () => {},
    };
    await service.subscribe("fast-inst", "feed", { tier: "fast" }, noop);
    await service.subscribe("slow-inst", "feed", { tier: "slow" }, noop);

    await waitFor(() => fastHits.length >= 4);
    expect(slowHits.length).toBeLessThan(fastHits.length);
    expect(seenParams).toInclude({ tier: "fast" }, { tier: "slow" });
  });

  it("supports a dynamic polling interval driven by the latest response payload", async function () {
    const responses = [
      { seq: 1, nextMs: 15 },
      { seq: 2, nextMs: 60 },
      { seq: 3, nextMs: null },
    ];
    let idx = 0;
    const timestamps: number[] = [];
    fetchHandler = () => {
      timestamps.push(Date.now());
      const body = responses[idx] ?? { seq: 99, nextMs: null };
      idx++;
      return jsonResponse(body);
    };

    const callbackArgs: { params: Json; lastData: Json | null }[] = [];
    const service = track(
      new PolledExternalService({
        dynamic: {
          url: "http://example.test/dynamic",
          interval: (params, lastData) => {
            callbackArgs.push({ params, lastData });
            if (
              lastData !== null &&
              typeof lastData === "object" &&
              !Array.isArray(lastData)
            ) {
              const next = lastData["nextMs"];
              return typeof next === "number" ? next : null;
            }
            return null;
          },
          conv: convValue,
        },
      }),
    );

    await service.subscribe(
      "dyn-1",
      "dynamic",
      { key: "k" },
      {
        update: () => Promise.resolve(),
        error: () => {},
      },
    );

    await waitFor(() => timestamps.length === 3);
    // Returning null on the 3rd response must stop further polling.
    await wait(80);
    expect(timestamps.length).toEqual(3);

    expect(callbackArgs).toEqual([
      { params: { key: "k" }, lastData: { seq: 1, nextMs: 15 } },
      { params: { key: "k" }, lastData: { seq: 2, nextMs: 60 } },
      { params: { key: "k" }, lastData: { seq: 3, nextMs: null } },
    ]);

    const secondDelay = timestamps[2]! - timestamps[1]!;
    expect(secondDelay).toBeGreaterThanOrEqual(45);
  });

  it("supports a 0-argument interval function and stops on non-positive or non-finite delays", async function () {
    const delays = [15, 0];
    let step = 0;
    let fetches = 0;
    fetchHandler = () => {
      fetches++;
      return jsonResponse({ fetches });
    };

    const service = track(
      new PolledExternalService({
        limited: {
          url: "http://example.test/limited",
          interval: () => delays[step++] ?? Number.NaN,
          conv: convValue,
        },
      }),
    );

    await service.subscribe(
      "lim-1",
      "limited",
      {},
      {
        update: () => Promise.resolve(),
        error: () => {},
      },
    );

    await waitFor(() => fetches === 2);
    await wait(60);
    expect(fetches).toEqual(2);
  });

  it("does not overlap slow in-flight requests", async function () {
    let inFlight = 0;
    let maxInFlight = 0;
    let completed = 0;

    fetchHandler = async () => {
      inFlight++;
      if (inFlight > maxInFlight) maxInFlight = inFlight;
      await wait(40);
      inFlight--;
      completed++;
      return jsonResponse({ completed });
    };

    const service = track(
      new PolledExternalService({
        slow: {
          url: "http://example.test/slow",
          interval: 10,
          conv: convValue,
        },
      }),
    );

    await service.subscribe(
      "slow-1",
      "slow",
      {},
      {
        update: () => Promise.resolve(),
        error: () => {},
      },
    );

    await waitFor(() => completed >= 3);
    service.unsubscribe("slow-1");
    expect(maxInFlight).toEqual(1);
  });

  it("passes null lastData to interval callback on poll errors and continues polling", async function () {
    await withCapturedConsoleError(async (consoleCalls) => {
      let attempt = 0;
      fetchHandler = () => {
        attempt++;
        if (attempt === 2) {
          return new Response("boom", {
            status: 500,
            statusText: "Internal Server Error",
          });
        }
        return jsonResponse({ attempt });
      };

      const seenLastData: (Json | null)[] = [];
      const errors: unknown[] = [];
      const updates: Entry<Json, Json>[][] = [];

      const service = track(
        new PolledExternalService({
          flaky: {
            url: "http://example.test/flaky",
            interval: (_params, lastData) => {
              seenLastData.push(lastData);
              return seenLastData.length >= 3 ? null : 15;
            },
            conv: convValue,
          },
        }),
      );

      await service.subscribe(
        "flaky-1",
        "flaky",
        {},
        {
          update: (entries) => {
            updates.push(entries);
            return Promise.resolve();
          },
          error: (e) => {
            errors.push(e);
          },
        },
      );

      await waitFor(() => seenLastData.length === 3);
      expect(seenLastData).toEqual([{ attempt: 1 }, null, { attempt: 3 }]);
      expect(errors.length).toEqual(1);
      expect(consoleCalls.length).toEqual(1);
      expect(updates).toEqual([
        [["value", [{ attempt: 1 }]]],
        [["value", [{ attempt: 3 }]]],
      ]);
    });
  });

  it("reports and stops polling if the interval callback throws", async function () {
    await withCapturedConsoleError(async (consoleCalls) => {
      let fetches = 0;
      fetchHandler = () => {
        fetches++;
        return jsonResponse({ fetches });
      };

      const errors: unknown[] = [];
      const service = track(
        new PolledExternalService({
          broken: {
            url: "http://example.test/broken",
            interval: () => {
              throw new Error("bad interval");
            },
            conv: convValue,
          },
        }),
      );

      await service.subscribe(
        "broken-1",
        "broken",
        {},
        {
          update: () => Promise.resolve(),
          error: (e) => {
            errors.push(e);
          },
        },
      );

      await wait(50);
      expect(fetches).toEqual(1);
      expect(errors.length).toEqual(1);
      expect(consoleCalls.length).toEqual(1);
    });
  });

  it("prevents an in-flight poll from updating or rescheduling after unsubscribe", async function () {
    let fetchCount = 0;
    let releaseSecondFetch: (() => void) | null = null;

    fetchHandler = async () => {
      fetchCount++;
      if (fetchCount === 2) {
        await new Promise<void>((resolve) => {
          releaseSecondFetch = resolve;
        });
      }
      return jsonResponse({ fetchCount });
    };

    const updates: Entry<Json, Json>[][] = [];
    const service = track(
      new PolledExternalService({
        race: {
          url: "http://example.test/race",
          interval: 15,
          conv: convValue,
        },
      }),
    );

    await service.subscribe(
      "race-1",
      "race",
      {},
      {
        update: (entries) => {
          updates.push(entries);
          return Promise.resolve();
        },
        error: () => {},
      },
    );

    await waitFor(() => releaseSecondFetch !== null);
    service.unsubscribe("race-1");
    releaseSecondFetch!();

    await wait(60);
    expect(fetchCount).toEqual(2);
    expect(updates.length).toEqual(1);
  });

  it("clears all active timers on shutdown", async function () {
    let fetches = 0;
    fetchHandler = () => {
      fetches++;
      return jsonResponse({ fetches });
    };

    const service = track(
      new PolledExternalService({
        a: { url: "http://example.test/a", interval: 15, conv: convValue },
        b: {
          url: "http://example.test/b",
          interval: () => 15,
          conv: convValue,
        },
      }),
    );

    const noop = {
      update: () => Promise.resolve(),
      error: () => {},
    };
    await service.subscribe("inst-a", "a", {}, noop);
    await service.subscribe("inst-b", "b", {}, noop);
    await waitFor(() => fetches >= 4);

    await service.shutdown();
    const countAfterShutdown = fetches;
    await wait(70);
    expect(fetches).toEqual(countAfterShutdown);
  });
});
