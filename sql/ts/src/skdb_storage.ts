

import { Storage, PagedMemory } from "#skdb/skdb_types";



function makeSKDBStore(
  dbName: string,
  storeName: string,
  version: number,
  memory: PagedMemory,
): Promise<IDBDatabase> {
  if (typeof indexedDB === 'undefined') {
    throw new Error("No indexedDB in this environment.");
  }
  return new Promise((resolve, reject) => {
    let open = indexedDB.open(dbName, 1);

    open.onupgradeneeded = function () {
      let db = open.result;
      db.createObjectStore(storeName, { keyPath: "pageid" });
    };

    open.onsuccess = function () {
      let db = open.result;
      let tx = db.transaction(storeName, "readwrite");
      let store = tx.objectStore(storeName);

      store.getAll().onsuccess = (event) => {
        let target = event.target;
        if (target == null) {
          reject(new Error("Unexpected null target"));
          return;
        }
        let pages =
          (
            target as unknown as
            { result: Array<{ pageid: number, content: ArrayBuffer }> }
          ).result;
        if (pages.length == 0) {
          memory.init(store.put)
        }
        else {
          memory.restore(pages);
        }
      }

      tx.oncomplete = function () {
        resolve(db);
      };

      tx.onerror = function (err) {
        reject(err);
      };
    };

    open.onerror = function (err) {
      reject(err);
    };
  });
}


export class IDBStorage implements Storage {
  private storeName: string;
  private memory: PagedMemory;
  private db: IDBDatabase;
  
  private constructor(
    storeName: string,
    db: IDBDatabase,
    memory: PagedMemory,
  ) {
    this.storeName = storeName;
    this.memory = memory;
    this.db = db;
  }

  static async create(
    dbName: string,
    storeName: string,
    version: number,
    memory: PagedMemory,
  ): Promise<Storage> {
    let db = await makeSKDBStore(
      dbName,
      storeName,
      version,
      memory,
    );
    return new IDBStorage(
      storeName,
      db,
      memory
    )
  }


  private async storePages(): Promise<boolean> {
    if(this.storeName == null) {
      return new Promise((resolve, _) => resolve(true));
    }
    let storeName = this.storeName;
    return new Promise((resolve, reject) => (async () => {
      if(this.db == null) {
        resolve(true);
      }
      let db = this.db!;
      let tx = db.transaction(storeName, "readwrite");
      tx.onabort = (err) => {
        resolve(false);
      }
      tx.onerror = (err) => {
        console.log("Error sync db: " + err);
        resolve(false);
      }
      tx.oncomplete = () => {
        this.memory.clear();
        resolve(true);
      }
      let copiedPages = await this.memory.getPages();
      let store = tx.objectStore(storeName);
      for(let j = 0; j < copiedPages.length; j++) {
        store.put(copiedPages[j]!);
      }
    })());
  }

  async save() {
    this.memory.update();
    return await this.storePages();
  }
}

/* ***************************************************************************/
/* Primitives to connect to indexedDB. */
/* ***************************************************************************/

export function clear(
  dbName: string,
  storeName: string,
): Promise<void> {
  if (typeof indexedDB === 'undefined') {
    throw new Error("No indexedDB in this environment.");
  }
  return new Promise((resolve, reject) => {
    let open = indexedDB.open(dbName, 1);

    open.onupgradeneeded = function () {
      let db = open.result;
      let store = db.createObjectStore(storeName, { keyPath: "pageid" });
    };

    open.onsuccess = function () {
      let db = open.result;
      let tx = db.transaction(storeName, "readwrite");
      let store = tx.objectStore(storeName);

      store.clear();

      tx.oncomplete = function () {
        resolve();
      };

      tx.onerror = function (err) {
        reject(err);
      };
    };

    open.onerror = function (err) {
      reject(err);
    };
  });
}