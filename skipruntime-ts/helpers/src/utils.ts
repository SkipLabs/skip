import type { Opt } from "@skip-wasm/std";
import { ManyToOneMapper } from "@skipruntime/api";
import type {
  Accumulator,
  NonEmptyIterator,
  ReactiveResponse,
  Json,
} from "@skipruntime/api";

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

export class CountMapper<
  K extends Json,
  V extends Json,
> extends ManyToOneMapper<K, V, number> {
  mapValues(values: NonEmptyIterator<V>): number {
    return values.toArray().length;
  }
}

export function parseReactiveResponse(
  header: Headers | string,
): ReactiveResponse | undefined {
  const strReactiveResponse =
    typeof header == "string"
      ? header
      : header.get("Skip-Reactive-Response-Token");
  if (!strReactiveResponse) return undefined;
  return JSON.parse(strReactiveResponse) as ReactiveResponse;
}

export function reactiveResponseHeader(
  reactiveResponse: ReactiveResponse,
): [string, string] {
  return ["Skip-Reactive-Response-Token", JSON.stringify(reactiveResponse)];
}
