import type { Opt } from "std";
import type { Accumulator, ReactiveResponse } from "./skipruntime_api.js";

export class Sum implements Accumulator<number, number> {
  default = 0;

  accumulate(acc: number, value: number): number {
    return acc + value;
  }

  dismiss(acc: number, value: number): Opt<number> {
    return acc - value;
  }
}

export class Min implements Accumulator<number, number> {
  default = null;

  accumulate(acc: Opt<number>, value: number): number {
    return acc === null ? value : Math.min(acc, value);
  }

  dismiss(acc: number, value: number): Opt<number> {
    return value > acc ? acc : null;
  }
}

export class Max implements Accumulator<number, number> {
  default = null;

  accumulate(acc: Opt<number>, value: number): number {
    return acc === null ? value : Math.max(acc, value);
  }

  dismiss(acc: number, value: number): Opt<number> {
    return value < acc ? acc : null;
  }
}

export function getReactiveResponse(
  httpHeaders: Headers,
): ReactiveResponse | undefined {
  const strReactiveResponse = httpHeaders.get("Skip-Reactive-Response-Token");
  if (!strReactiveResponse) return undefined;
  return JSON.parse(strReactiveResponse, (key: string, value: string) => {
    if (key == "watermark") return BigInt(value);
    return value;
  }) as ReactiveResponse;
}
