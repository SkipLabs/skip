
import { Wrk } from "#std/sk_types";

interface Payload {}

class UnmanagedMessage extends Error {
  constructor(msg: any) {
    super(msg);
  }
}

export class Function implements Payload {
  fn: string;
  parameters: Array<any>;
  subscription ?: MessageId;
  wrap?: { wrap: boolean, autoremove: boolean};


  constructor(fn: string, parameters: Array<any>, wrap?: { wrap: boolean, autoremove: boolean}) {
    this.fn = fn;
    this.parameters = parameters;
    this.wrap = wrap;
  }


  static as(obj: object) {
    if (!("fn" in obj) || !("parameters" in obj)) return null;
    let subscription = "subscription" in obj ? MessageId.as(obj.subscription!) : null;
    let wrap = "wrap" in obj ? obj.wrap! as { wrap: boolean, autoremove: boolean} : undefined;
    let fn = new Function(
      obj.fn! as string,
      obj.parameters! as Array<any>,
      wrap
    );
    fn.subscription = subscription ? subscription: undefined;
    return fn;
  }

  static isValid(obj: object) {
    return "fn" in obj && "parameters" in obj;
  }
}

export class Caller implements Payload {
  wrapped: number;
  fn: string;
  parameters: Array<any>;


  constructor(wrapped: number, fn: string, parameters: Array<any>) {
    this.wrapped = wrapped;
    this.fn = fn;
    this.parameters = parameters;
  }


  static convert(obj: object) {
    if (!("wrapped" in obj) ||  !("fn" in obj) || !("parameters" in obj)) return null;
    let fn = new Caller(
      obj.wrapped! as number,
      obj.fn! as string,
      obj.parameters! as Array<any>,
    );
    return fn;
  }

  static isValid(obj: object) {
    return "fn" in obj && "parameters" in obj;
  }
}

export class Return implements Payload {
  success: boolean;
  value: any;

  constructor(success: boolean, value: any) {
    this.success = success;
    this.value = value;
  }

  static as(obj: object) {
    if (!("success" in obj) || !("value" in obj)) return null;
    return new Return(obj.success! as boolean, obj.value!);
  }
}


export class MessageId {
  source: number;
  id: number;

  constructor(source: number, id: number) {
    this.source = source;
    this.id = id;
  }

  static as(obj: object) {
    if (!("source" in obj) || !("id" in obj)) return null;
    return new MessageId(obj.source! as number, obj.id! as number);
  }
}

export class Wrapped {
  wrapped: number;

  constructor(wrapped: number) {
    this.wrapped = wrapped;
  }

  static as(obj: object) {
    if (!("wrapped" in obj)) return null;
    return new Wrapped(obj.wrapped! as number);
  }
}

function asKey(messageId) {
  return "" + messageId.source + ":" + messageId.id;
}

export class Message {
  id: MessageId;
  payload: Payload;

  constructor(id: MessageId, payload: Payload) {
    this.id = id;
    this.payload = payload;
  }

  static asFunction(obj: object) {
    if (!("id" in obj) || !("payload" in obj)) return null;
    let messageId = MessageId.as(obj.id!);
    let payload = Function.as(obj.payload!);
    if (messageId && payload) {
      return new Message(messageId, payload);
    }
    return null;
  }

  static asCaller(obj: object) {
    if (!("id" in obj) || !("payload" in obj)) return null;
    let messageId = MessageId.as(obj.id!);
    let payload = Caller.convert(obj.payload!);
    if (messageId && payload) {
      return new Message(messageId, payload);
    }
    return null;
  }

  static asReturn(obj: object) {
    if (!("id" in obj) || !("payload" in obj)) return null;
    let messageId = MessageId.as(obj.id!);
    let payload = Return.as(obj.payload!);
    if (messageId && payload) {
      return new Message(messageId, payload);
    }
    return null;
  }
}

var sourcesLastId = 0;

export class PromiseWorker {
  private lastId: number;
  private source: number;
  private worker: Wrk;
  private callbacks: Map<string, (...args: any[]) => any>;
  private subscriptions: Map<string, (...args: any[]) => void>;

  post : (fn: Function) => Promise<any>;
  subscribe: (fn: Function, value: (...args: any[]) => void) => Promise<any>;
  onMessage: (message: MessageEvent) => void;

  constructor(worker: Wrk) {
    this.lastId = 0;
    this.worker = worker;
    this.source = ++sourcesLastId;
    this.callbacks = new Map();
    this.subscriptions = new Map();
    let self = this;
    this.post = (fn: Function) => {
      let messageId = new MessageId(this.source, ++this.lastId);
      return new Promise(function (resolve, reject) {
        self.callbacks.set(asKey(messageId), (result: Return) => {
          if (result.success) {
            resolve(result.value);
          } else if (result.value instanceof Error) {
            reject(result.value);
          } else {
            reject(new Error(JSON.stringify(result.value)));
          }
        })
        let message = new Message(messageId, fn);
        self.worker.postMessage(message);
      })
    };
    this.subscribe = (fn: Function, value: (...args: any[]) => void) => {
      let subscriptionId = new MessageId(this.source, ++this.lastId);
      this.subscriptions.set(asKey(subscriptionId), (result: Return) => value.apply(null, result.value))
      fn.subscription = subscriptionId;
      return this.post(fn);
    }
    this.onMessage = (message: MessageEvent) => {
      let data = Message.asReturn(message.data ?? message);
      if (!data) {
        throw new UnmanagedMessage(data)
      } else {
        let result = data.payload as Return;
        let callback = this.callbacks.get(asKey(data.id));
        if (callback) {
          this.callbacks.delete(asKey(data.id));
          callback(data.payload);
          return;
        }
        let subscription = this.subscriptions.get(asKey(data.id));
        if (subscription) {
          subscription(data.payload);
          return;
        }
        if (result.value instanceof Error) {
            throw result.value;
        } else throw new Error("Return with no callback" + JSON.stringify(data));
      }
    }
    this.worker.onMessage(this.onMessage);
  }
}