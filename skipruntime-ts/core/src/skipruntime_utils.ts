import type { Opt } from "std";
import type { Accumulator, ReactiveResponse } from "./skipruntime_api.js";
import {
  check,
  isSkFrozen,
  sk_freeze,
} from "./internals/skipruntime_module.js";
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

export function parseReactiveResponse(
  header: Headers | string,
): ReactiveResponse | undefined {
  const strReactiveResponse =
    typeof header == "string"
      ? header
      : header.get("Skip-Reactive-Response-Token");
  if (!strReactiveResponse) return undefined;
  return JSON.parse(strReactiveResponse, (key: string, value: string) => {
    if (key == "watermark") return BigInt(value);
    return value;
  }) as ReactiveResponse;
}

export function reactiveResponseHeader(
  reactiveResponse: ReactiveResponse,
): [string, string] {
  return [
    "Skip-Reactive-Response-Token",
    JSON.stringify(reactiveResponse, (_key: string, value: unknown) =>
      typeof value === "bigint" ? value.toString() : value,
    ),
  ];
}

/**
 * _Deep-freeze_ an object, returning the same object that was passed in.
 *
 * This function is similar to
 * {@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze | `Object.freeze()`}
 * but freezes the object and deep-freezes all its properties,
 * recursively. The object is then not only _immutable_ but also
 * _constant_. Note that as a result all objects reachable from the
 * parameter will be frozen and no longer mutable or extensible, even from
 * other references.
 *
 * The primary use for this function is to satisfy the requirement that all
 * parameters to Skip `Mapper` constructors must be deep-frozen: objects
 * that have not been constructed by Skip can be passed to `freeze()` before
 * passing them to a `Mapper` constructor.
 *
 * @param value - The object to deep-freeze.
 * @returns The same object that was passed in.
 */
export function freeze<T>(value: T): T {
  if (
    typeof value == "string" ||
    typeof value == "number" ||
    typeof value == "boolean"
  ) {
    return value;
  } else if (typeof value == "object") {
    if (value === null) {
      return value;
    } else if (isSkFrozen(value)) {
      return value;
    } else if (Object.isFrozen(value)) {
      check(value);
      return value;
    } else if (Array.isArray(value)) {
      const length: number = value.length;
      for (let i = 0; i < length; i++) {
        value[i] = freeze(value[i]);
      }
      return Object.freeze(sk_freeze(value));
    } else {
      const jso = value as Record<string, any>;
      for (const key of Object.keys(jso)) {
        jso[key] = freeze(jso[key]);
      }
      return Object.freeze(sk_freeze(jso)) as T;
    }
  } else {
    throw new Error(`'${typeof value}' cannot be frozen.`);
  }
}
