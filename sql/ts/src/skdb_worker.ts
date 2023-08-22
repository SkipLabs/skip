import { createOnMain } from "#skdb/skdb";
import { SKDB } from "#skdb/skdb_types";
import {Function, Return, Message} from "#std/sk_worker";

var db: SKDB;

var post = (message: any) => {
  postMessage(message);
};

var onMessage = (message: MessageEvent) => {
  let data = Message.asFunction(message.data);
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
        createOnMain(parameters[0]).then(
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
      if (typeof fn  !== "function") { 
        post(new Message(data.id, new Return(false, "Invalid database function " + fun.fn)));
      } else {
        fn.apply(db, parameters).then(
          result => post(new Message(data!.id, new Return(true, result)))
        ).catch(e => post(new Message(data!.id, new Return(false, e))))
      }
    }
  };
}

addEventListener('message', onMessage);