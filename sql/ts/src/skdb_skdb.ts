
import { int, ptr, Environment, Links, ToWasmManager, Utils, Shared } from "#std/sk_types";
import { PagedMemory, Page, SKDBCallable, Storage, SKDB, ExternalFuns, SkdbHandle, Params } from "#skdb/skdb_types";
import { IDBStorage } from "#skdb/skdb_storage";
import { SKDBImpl } from "#skdb/skdb_database";


interface Exported {
  sk_pop_dirty_page: () => number;
  SKIP_get_version: () => number;
  skip_main: () => void;
  //
  SKIP_reactive_query: (queryID: number, query: number, encoded_params: number) => void;
  SKIP_delete_reactive_query: (queryID: number) => void;
  SKIP_js_notify_user: (notify: number) => void;
  getVersion: () => number;
}

class SkdbHamdleImpl implements SkdbHandle {
  runner: (fn: () => string) => Promise<Array<any>>;
  main: (new_args: Array<string>, new_stdin: string) => string;
  watch: (query: string, params: Params, onChange: (rows: Array<any>) => void) => { close: () => void }

  constructor(
    main: (new_args: Array<string>, new_stdin: string) => string,
    runner: (fn: () => string) => Promise<Array<any>>,
    watch: (query: string, params: Params, onChange: (rows: Array<any>) => void) => { close: () => void }
  ) {
    this.runner = runner;
    this.main = main;
    this.watch = watch;
  }

  init() {
    this.main([], "");
  }
}

interface ToWasm {
  SKIP_clear_field_names: () => void;
  SKIP_push_field_name: (skName: ptr) => void;
  SKIP_clear_object: () => void;
  SKIP_push_object_field_null: () => void;
  SKIP_push_object_field_int32: (field: int) => void;
  SKIP_push_object_field_int64: (field: ptr) => void;
  SKIP_push_object_field_float: (field: ptr) => void;
  SKIP_push_object_field_string: (field: ptr) => void;
  SKIP_push_object: () => void;
  SKIP_unix_unixepoch: (tm: ptr) => ptr;
  SKIP_unix_strftime: (tm: ptr) => ptr;
  SKIP_js_user_fun: (queryID: int) => void;
  SKIP_js_mark_query: (queryID: int, notify: int) => void;
}

class SKDBMemory implements PagedMemory {
  memory: ArrayBuffer;
  persistentSize: number;
  nbrInitPages: number;
  pageSize: number;
  popDirtyPage: () => number;
  private dirtyPagesMap: Array<number>;
  private dirtyPages: Array<number>;

  constructor(
    memory: ArrayBuffer,
    persistentSize: number,
    popDirtyPage: () => number,
    pageBitSize: number = 20,
  ) {
    this.memory = memory;
    this.persistentSize = persistentSize;
    this.pageSize = 1 << pageBitSize;
    this.nbrInitPages = persistentSize / this.pageSize + 1;
    this.popDirtyPage = popDirtyPage;
  }

  clear = () => {
    this.dirtyPagesMap = [];
    this.dirtyPages = [];
  }

  update = () => {
    while (true) {
      let dirtyPage = this.popDirtyPage();
      if (dirtyPage == -1) break;
      if (dirtyPage >= this.nbrInitPages) {
        if (this.dirtyPagesMap[dirtyPage] != dirtyPage) {
          this.dirtyPagesMap[dirtyPage] = dirtyPage;
          this.dirtyPages.push(dirtyPage);
        }
      }
    }

    for (let dirtyPage = 0; dirtyPage < this.nbrInitPages; dirtyPage++) {
      if (this.dirtyPagesMap[dirtyPage] != dirtyPage) {
        this.dirtyPagesMap[dirtyPage] = dirtyPage;
        this.dirtyPages.push(dirtyPage);
      }
    }
  }

  private async copyPage(start: number, end: number): Promise<ArrayBuffer> {
    return this.memory.slice(start, end);
  }

  init(fn: (page: Page) => void) {
    // Let's round up the memorySize to be pageSize aligned
    let memorySize = (this.persistentSize + (this.pageSize - 1)) & ~(this.pageSize - 1);
    let i: number;
    let cursor = 0;
    for (i = 0; i < memorySize / this.pageSize; i++) {
      const content = this.memory.slice(cursor, cursor + this.pageSize);
      fn({ pageid: i, content: content });
      cursor = cursor + this.pageSize;
    }
  }

  restore(pages: Array<Page>) {
    let memory32 = new Uint32Array(this.memory);
    for (let pageIdx = 0; pageIdx < pages.length; pageIdx++) {
      let page = pages[pageIdx]!;
      const pageid = page.pageid;
      if (pageid < 0) continue;
      let pageBuffer = new Uint32Array(page.content);
      const start = pageid * (this.pageSize / 4);
      for (let i = 0; i < pageBuffer.length; i++) {
        memory32[start + i] = pageBuffer[i]!;
      }
    }
  }

  async getPages() {
    let pages = this.dirtyPages;
    let copiedPages = new Array();
    for (let j = 0; j < pages.length; j++) {
      let page = pages[j]!;
      let start = page * this.pageSize;
      let end = page * this.pageSize + this.pageSize;
      let content = await this.copyPage(start, end);
      copiedPages.push({ pageid: page, content });
    }
    return copiedPages;
  }
}

class SKDBShared implements Shared {
  getName = () => "SKDB";
  create: (dbName?: string, asWorker?: boolean) => Promise<SKDB>;
  constructor(create: (dbName?: string) => Promise<SKDB>) {
    this.create = async (dbName?: string, asWorker?: boolean) => {
      asWorker = asWorker === false ? false : true;
      // todo Manage worker
      return await create(dbName);
    };
  }
}

class LinksImpl implements Links, ToWasm {
  private environment: Environment;
  private state: ExternalFuns;
  private field_names: Array<string>;
  private objectIdx: number;
  private object: { [k: string]: any };
  private stdout_objects: Array<any>;
  private storage?: Storage;
  //
  private queryID: number;
  private userFuns: Array<() => void>;
  private queriesToNotify: Map<number, number>;
  private freeQueryIDs: Array<number>;

  SKIP_call_external_fun: (funId: int, skParam: ptr) => ptr;
  SKIP_clear_field_names: () => void;
  SKIP_push_field_name: (skName: ptr) => void;
  SKIP_clear_object: () => void;
  SKIP_push_object_field_null: () => void;
  SKIP_push_object_field_int32: (field: int) => void;
  SKIP_push_object_field_int64: (field: ptr) => void;
  SKIP_push_object_field_float: (field: ptr) => void;
  SKIP_push_object_field_string: (field: ptr) => void;
  SKIP_push_object: () => void;
  SKIP_unix_unixepoch: (tm: ptr) => ptr;
  SKIP_unix_strftime: (tm: ptr) => ptr;
  SKIP_js_user_fun: (queryID: int) => void;
  SKIP_js_mark_query: (queryID: int, notify: int) => void;
  notifyAllJS: () => void;

  constructor(environment: Environment) {
    this.environment = environment;
    this.state = new ExternalFuns();
    this.field_names = new Array();
    this.queryID = 0;
    this.userFuns = new Array();
    this.freeQueryIDs = new Array();
    this.queriesToNotify = new Map();
    this.objectIdx = 0;
    this.object = {};
    this.stdout_objects = new Array();
  }

  complete = (utils: Utils, exports: object) => {
    let exported = exports as Exported;
    this.notifyAllJS = () => {
      this.queriesToNotify.forEach((value, key, map) => {
        exported.SKIP_js_notify_user(value);
      });
      this.queriesToNotify = new Map();
    }
    this.SKIP_call_external_fun = (funId: int, skParam: ptr) => {
      let res = this.state.call(
        funId,
        JSON.parse(utils.importString(skParam))
      )
      let strRes = JSON.stringify(res === undefined ? null : res);
      return utils.exportString(strRes);
    };
    this.SKIP_clear_field_names = () => {
      this.field_names = new Array();
    };
    this.SKIP_push_field_name = (skName: ptr) => {
      this.field_names.push(utils.importString(skName))
    };
    this.SKIP_clear_object = () => {
      this.objectIdx = 0;
      this.object = {};
    };
    this.SKIP_push_object_field_null = () => {
      let field_name: string = this.field_names[this.objectIdx]!;
      this.object[field_name] = null;
      this.objectIdx++;
    };
    this.SKIP_push_object_field_int32 = (n: int) => {
      let field_name: string = this.field_names[this.objectIdx]!;
      this.object[field_name] = n;
      this.objectIdx++;
    };
    this.SKIP_push_object_field_int64 = (skV: ptr) => {
      let field_name: string = this.field_names[this.objectIdx]!;
      this.object[field_name] = parseInt(utils.importString(skV), 10);
      this.objectIdx++;
    };
    this.SKIP_push_object_field_float = (skV: ptr) => {
      let field_name: string = this.field_names[this.objectIdx]!;
      this.object[field_name] = parseFloat(utils.importString(skV));
      this.objectIdx++;
    },
      this.SKIP_push_object_field_string = (skV: ptr) => {
        let field_name: string = this.field_names[this.objectIdx]!;
        this.object[field_name] = utils.importString(skV);
        this.objectIdx++;
      },
      this.SKIP_push_object = () => {
        this.stdout_objects.push(this.object);
      };
    this.SKIP_unix_unixepoch = (tm: ptr) => {
      return utils.exportString("TODO")
    };
    this.SKIP_unix_strftime = (tm: ptr) => {
      return utils.exportString("TODO")
    }
    this.SKIP_js_user_fun = (queryID: int) => {
      this.userFuns[queryID]!()
    }
    this.SKIP_js_mark_query = (queryID: int, notify: int) => {
      this.queriesToNotify.set(queryID, notify);
    }
    let runner = async (fn: () => string) => {
      this.stdout_objects = new Array();
      let stdout = fn();
      if (stdout == "") {
        let result = this.stdout_objects;
        return result;
      }
      throw new Error(stdout)
    };
    let main = (new_args: Array<string>, new_stdin: string) => {
      let res = utils.main(new_args, new_stdin);
      this.notifyAllJS();
      return res;
    }
    let watch = (
      query: string,
      params: Params,
      onChange: (rows: Array<any>) => void,
    ) => {
      if (params instanceof Map) {
        params = Object.fromEntries(params);
      }
      this.stdout_objects = new Array();
      const queryID = this.freeQueryIDs.pop() || this.queryID++;
      
      this.userFuns[queryID] = () => {
        onChange(this.stdout_objects);
        this.stdout_objects = new Array()
      }
      utils.runWithGc(() => {
        utils.runCheckError(() => {
          exported.SKIP_reactive_query(
            queryID,
            utils.exportString(query),
            utils.exportString(JSON.stringify(params))
          )
        })
      });  
      onChange(this.stdout_objects);
      return { close: () => {
          exported.SKIP_delete_reactive_query(queryID);
          this.userFuns[queryID] = () => {};
          this.freeQueryIDs.push(queryID);
        }
      }
    }
    let handle = new SkdbHamdleImpl(main, runner, watch);
    let create = async (dbName?: string) => {
      let save: () => Promise<boolean> = async () => true;
      let storeName = dbName ? "SKDBStore" : null;
      if (storeName != null) {
        let memory = new SKDBMemory(
          utils.getMemoryBuffer(),
          utils.getPersistentSize(),
          exported.sk_pop_dirty_page
        );
        this.storage = await IDBStorage.create(
          dbName!,
          storeName,
          exported.getVersion(),
          memory,
        );
        save = this.storage!.save;
      };
      handle.init();
      return await SKDBImpl.create(handle, this.environment, save);
    };
    this.environment.shared.set("SKDB", new SKDBShared(create));
  };
}

class Manager implements ToWasmManager {
  private environment: Environment;

  constructor(environment: Environment) {
    this.environment = environment;
  }

  prepare = (wasm: object) => {
    let toWasm = wasm as ToWasm;
    let links = new LinksImpl(this.environment);
    toWasm.SKIP_clear_field_names = () => links.SKIP_clear_field_names();
    toWasm.SKIP_push_field_name = (skName: ptr) => links.SKIP_push_field_name(skName);
    toWasm.SKIP_clear_object = () => links.SKIP_clear_object();
    toWasm.SKIP_push_object_field_null = () => links.SKIP_push_object_field_null();
    toWasm.SKIP_push_object_field_int32 = (field: int) => links.SKIP_push_object_field_int32(field);
    toWasm.SKIP_push_object_field_int64 = (field: ptr) => links.SKIP_push_object_field_int64(field);
    toWasm.SKIP_push_object_field_float = (field: ptr) => links.SKIP_push_object_field_float(field);
    toWasm.SKIP_push_object_field_string = (field: ptr) => links.SKIP_push_object_field_string(field);
    toWasm.SKIP_push_object = () => links.SKIP_push_object();
    toWasm.SKIP_unix_unixepoch = (tm: ptr) => links.SKIP_unix_unixepoch(tm);
    toWasm.SKIP_unix_strftime = (tm: ptr) => links.SKIP_unix_strftime(tm);
    toWasm.SKIP_js_user_fun = (id: int) => links.SKIP_js_user_fun(id);
    toWasm.SKIP_js_mark_query = (id: int, notify: int) => links.SKIP_js_mark_query(id, notify);
    return links;
  }
}


/** @sk init */
export function init(env?: Environment) {
  return Promise.resolve(new Manager(env!));
}