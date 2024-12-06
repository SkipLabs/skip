import type { int, Wrk } from "./sk_types.js";

export class Wrappable {
  wrappedId?: int;
}

class UnmanagedMessage extends Error {}

export class Function {
  constructor(
    public fn: string,
    public parameters: any[],
    public wrap?: { wrap: boolean; autoremove: boolean },
  ) {}

  static as(obj: object) {
    if (!("fn" in obj) || !("parameters" in obj)) return null;
    const wrap =
      "wrap" in obj
        ? (obj.wrap! as { wrap: boolean; autoremove: boolean })
        : undefined;
    const fn = new Function(obj.fn! as string, obj.parameters! as any[], wrap);
    return fn;
  }

  static isValid(obj: object) {
    return "fn" in obj && "parameters" in obj;
  }
}

export class Caller {
  constructor(
    public wrapped: number,
    public fn: string,
    public parameters: any[],
    public remove: boolean = false,
  ) {}

  static convert(obj: object) {
    if (
      !("wrapped" in obj) ||
      !("fn" in obj) ||
      !("parameters" in obj) ||
      !("remove" in obj)
    )
      return null;
    const fn = new Caller(
      obj.wrapped! as number,
      obj.fn! as string,
      obj.parameters! as any[],
      obj.remove! as boolean,
    );
    return fn;
  }

  static isValid(obj: object) {
    return "fn" in obj && "parameters" in obj;
  }
}

export class Return {
  constructor(
    public success: boolean,
    public value: any,
  ) {}

  static as(obj: object) {
    if (!("success" in obj) || !("value" in obj)) return null;
    return new Return(obj.success! as boolean, obj.value);
  }
}

export class MessageId {
  constructor(
    public source: number,
    public id: number,
  ) {}

  static as(obj: object) {
    if (!("source" in obj) || !("id" in obj)) return null;
    return new MessageId(obj.source! as number, obj.id! as number);
  }
}

export class Wrapped {
  constructor(public wrapped: number) {}

  static as(obj: object) {
    if (!("wrapped" in obj)) return null;
    return new Wrapped(obj.wrapped! as number);
  }
}

function asKey(messageId: MessageId) {
  return `${messageId.source}:${messageId.id}`;
}

export class Sender {
  constructor(
    public close: () => void,
    public send: <T>() => Promise<T>,
  ) {}
}

export class Message {
  constructor(
    public id: MessageId,
    public payload: unknown,
  ) {}

  private static convert(f: (_: object) => unknown, obj: object) {
    if (!("id" in obj && typeof obj.id === "object")) return null;
    if (!("payload" in obj && typeof obj.payload === "object")) return null;
    const { id, payload } = obj as { id: object; payload: object };
    const messageId = MessageId.as(id);
    const messagePayload = f(payload);
    if (!messageId || !messagePayload) return null;
    return new Message(messageId, messagePayload);
  }

  static asFunction(obj: object) {
    return Message.convert((x) => Function.as(x), obj);
  }

  static asCaller(obj: object) {
    return Message.convert((x) => Caller.convert(x), obj);
  }

  static asReturn(obj: object) {
    return Message.convert((x) => Return.as(x), obj);
  }
}

let sourcesLastId = 0;

export class PromiseWorker {
  private lastId: number;
  private source: number;
  private worker: Wrk;
  private callbacks: Map<string, (...args: any[]) => any>;
  private subscriptions: Map<string, (...args: any[]) => void>;

  post: (fn: Function) => Sender;
  onMessage: (message: MessageEvent) => void;

  constructor(worker: Wrk) {
    this.lastId = 0;
    this.worker = worker;
    this.source = ++sourcesLastId;
    this.callbacks = new Map();
    this.subscriptions = new Map();
    // eslint-disable-next-line @typescript-eslint/no-this-alias
    const self = this;
    this.post = (fn: Function | Caller) => {
      const messageId = new MessageId(this.source, ++this.lastId);
      const subscribed = new Set<string>();
      const parameters = fn.parameters.map((p) => {
        if (typeof p == "function") {
          const subscriptionId = new MessageId(this.source, ++this.lastId);
          // eslint-disable-next-line @typescript-eslint/no-unsafe-call
          const wfn = (result: Return) => void p.apply(null, result.value);
          const key = asKey(subscriptionId);
          this.subscriptions.set(key, wfn);
          subscribed.add(key);
          return subscriptionId;
        } else {
          // eslint-disable-next-line @typescript-eslint/no-unsafe-return
          return p;
        }
      });
      fn.parameters = parameters;
      return new Sender(
        () => {
          subscribed.forEach((key) => this.subscriptions.delete(key));
        },
        () =>
          new Promise(function (resolve, reject) {
            self.callbacks.set(asKey(messageId), (result: Return) => {
              if (result.success) {
                // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
                resolve(result.value);
              } else if (result.value instanceof Error) {
                reject(result.value);
              } else {
                reject(new Error(JSON.stringify(result.value)));
              }
            });
            const message = new Message(messageId, fn);
            self.worker.postMessage(message);
          }),
      );
    };
    this.onMessage = (message: MessageEvent) => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
      const data = Message.asReturn(message.data ?? message);
      if (!data) {
        throw new UnmanagedMessage(JSON.stringify(message));
      } else {
        const result = data.payload as Return;
        const callback = this.callbacks.get(asKey(data.id));
        if (callback) {
          this.callbacks.delete(asKey(data.id));
          callback(data.payload);
          return;
        }
        const subscription = this.subscriptions.get(asKey(data.id));
        if (subscription) {
          subscription(data.payload);
          return;
        }
        if (result.value instanceof Error) {
          throw result.value;
        } else
          throw new Error("Return with no callback" + JSON.stringify(data));
      }
    };
    this.worker.onMessage(this.onMessage);
  }
}

function apply<R>(
  post: (message: any) => void,
  id: MessageId,
  caller: any,
  fn: (...args: any) => Promise<R>,
  parameters: any[],
  conv: (res: any) => any = (v) =>
    // eslint-disable-next-line @typescript-eslint/no-unsafe-return
    v,
): void {
  try {
    const promise = fn.apply(caller, parameters);
    promise
      .then((result: any) => {
        post(new Message(id, new Return(true, conv(result))));
      })
      .catch((e: unknown) => {
        // Firefox doesn't transmit Worker message if an object of type Error is in the message.
        post(
          new Message(
            id,
            new Return(false, e instanceof Error ? e.message : e),
          ),
        );
      });
  } catch (e: unknown) {
    post(
      new Message(id, new Return(false, e instanceof Error ? e.message : e)),
    );
  }
}

let runner: object | undefined;
let wrappedId = 0;
const wrapped = new Map<number, { value: any; autoremove: boolean }>();

export interface Creator<T> {
  getName: () => string;
  getType: () => string;
  create: (...args: any[]) => Promise<T>;
}

export const onWorkerMessage = <T>(
  message: MessageEvent,
  post: (message: any) => void,
  creator: Creator<T>,
) => {
  let data = Message.asCaller(message);
  if (!data) {
    data = Message.asFunction(message);
    if (!data) {
      post("Invalid worker message");
    } else {
      const fun = data.payload as Function;
      const parameters = fun.parameters.map((p) => {
        const subscription =
          typeof p == "object" ? MessageId.as(p as object) : null;
        if (subscription) {
          return (...args: any[]) => {
            post(new Message(subscription, new Return(true, args)));
          };
        } else {
          // eslint-disable-next-line @typescript-eslint/no-unsafe-return
          return p;
        }
      });
      if (fun.fn == creator.getName()) {
        if (runner) {
          post(
            new Message(
              data.id,
              new Return(false, creator.getType() + " already created"),
            ),
          );
        } else {
          apply(
            post,
            data.id,
            creator,
            creator.create,
            parameters,
            (created) => {
              runner = created as object;
              return null;
            },
          );
        }
      } else if (!runner) {
        post(
          new Message(data.id, new Return(false, "Database must be created")),
        );
      } else {
        // @ts-expect-error: Element implicitly has an 'any' type because expression of type 'string' can't be used to index type '{}'.
        const fn = runner[fun.fn];
        if (typeof fn !== "function") {
          post(
            new Message(
              data.id,
              new Return(false, "Invalid database function " + fun.fn),
            ),
          );
        } else {
          const fn_at_assumed_type = fn as (...args: any) => Promise<unknown>;
          apply(
            post,
            data.id,
            runner,
            fn_at_assumed_type,
            parameters,
            (result: any) => {
              if (fun.wrap?.wrap) {
                const wId = wrappedId++;
                wrapped.set(wId, {
                  value: result,
                  autoremove: fun.wrap.autoremove,
                });
                if (result instanceof Wrappable) {
                  result.wrappedId = wId;
                }
                result = new Wrapped(wId);
              }
              // eslint-disable-next-line @typescript-eslint/no-unsafe-return
              return result;
            },
          );
        }
      }
    }
  } else {
    const caller = data.payload as Caller;
    const parameters = caller.parameters.map((p) => {
      const subscription =
        typeof p == "object" ? MessageId.as(p as object) : null;
      if (subscription) {
        return (...args: any[]) => {
          post(new Message(subscription, new Return(true, args)));
        };
      } else {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-return
        return p;
      }
    });
    const obj = wrapped.get(caller.wrapped);
    const fni =
      caller.fn == ""
        ? { fn: obj?.value, obj: null }
        : { fn: obj?.value[caller.fn], obj: obj?.value };
    if (typeof fni.fn !== "function") {
      post(
        new Message(
          data.id,
          new Return(false, "Invalid function " + caller.fn),
        ),
      );
    } else {
      const fn_at_assumed_type = fni.fn as (...args: any) => Promise<unknown>;
      apply(post, data.id, fni.obj, fn_at_assumed_type, parameters);
    }
    if (obj?.autoremove || caller.remove) {
      wrapped.delete(caller.wrapped);
    }
  }
};
