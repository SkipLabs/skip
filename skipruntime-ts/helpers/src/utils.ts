import type { Nullable } from "@skip-wasm/std";
import { ManyToOneMapper } from "@skipruntime/api";
import type {
  Reducer,
  NonEmptyIterator,
  ReactiveResponse,
  Json,
} from "@skipruntime/api";

export class Sum implements Reducer<number, number> {
  default = 0;

  add(acc: number, value: number): number {
    return acc + value;
  }

  remove(acc: number, value: number): Nullable<number> {
    return acc - value;
  }
}

export class Min implements Reducer<number, number> {
  default = null;

  add(acc: Nullable<number>, value: number): number {
    return acc === null ? value : Math.min(acc, value);
  }

  remove(acc: number, value: number): Nullable<number> {
    return value > acc ? acc : null;
  }
}

export class Max implements Reducer<number, number> {
  default = null;

  add(acc: Nullable<number>, value: number): number {
    return acc === null ? value : Math.max(acc, value);
  }

  remove(acc: number, value: number): Nullable<number> {
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
