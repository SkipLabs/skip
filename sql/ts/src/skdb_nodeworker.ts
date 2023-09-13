import { createSkdb } from "#skdb/skdb";
import { SKDB } from "#skdb/skdb_types";
import { Function, Caller, Return, Message, Wrapped } from "#std/sk_worker";
import { parentPort } from "worker_threads";

var db: SKDB;

var wrappedId = 0;
var wrapped = new Map<number, { value: any, autoremove: boolean }>();

var post = (message: any) => {
  parentPort?.postMessage(message);
};

var onMessage = (message: MessageEvent) => {
  let data = Message.asCaller(message);
  if (!data) {
    data = Message.asFunction(message);
    if (!data) {
      post("Invalid worker message");
    } else {
      let fun = data.payload as Function;
      let parameters = fun.parameters;
      if (fun.subscription) {
        parameters.push((...args: any[]) => {
          post(new Message(fun.subscription!, new Return(true, args)))
        })
      }
      if (fun.fn == "create") {
        if (db) {
          post(new Message(data.id, new Return(false, "Database already created")));
        } else {
          createSkdb({
            asWorker: false,
            dbName: parameters[0]
          }).then(
            created => {
              db = created;
              post(new Message(data!.id, new Return(true, null)))
            }
          ).catch(e => post(new Message(data!.id, new Return(false, e))))
        }
      } else if (!db) {
        post(new Message(data.id, new Return(false, "Database must be created")));
      } else {
        let fn = db[fun.fn];
        if (typeof fn !== "function") {
          post(new Message(data.id, new Return(false, "Invalid database function " + fun.fn)));
        } else {
          fn.apply(db, parameters).then(
            result => {
              if (fun.wrap && fun.wrap) {
                let wId = wrappedId++;
                wrapped.set(wId, { value: result, autoremove: fun.wrap.autoremove });
                result = new Wrapped(wId);
              }
              post(new Message(data!.id, new Return(true, result)));
            }
          ).catch(e => post(new Message(data!.id, new Return(false, e))))
        }
      }
    }
  } else {
    let caller = data.payload as Caller;
    let parameters = caller.parameters;
    let obj = wrapped.get(caller.wrapped);
    let fni = caller.fn == "" ? {fn: obj?.value, obj: null} : {fn: obj?.value[caller.fn] , obj: obj?.value};
    if (typeof fni.fn !== "function") {
      post(new Message(data.id, new Return(false, "Invalid function " + caller.fn)));
    } else {
      fni.fn.apply(fni.obj, parameters).then(
        result => post(new Message(data!.id, new Return(true, result)))
      ).catch(e => post(new Message(data!.id, new Return(false, e))))
    }
    if (obj?.autoremove) {
      wrapped.delete(caller.wrapped);
    }
  }
}

parentPort?.on('message', onMessage);