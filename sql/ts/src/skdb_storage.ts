import type { Storage, PagedMemory } from "./skdb_types.js";

function makeSKDBStore(
  dbName: string,
  storeName: string,
  _version: number,
  memory: PagedMemory,
): Promise<IDBDatabase> {
  if (typeof indexedDB === "undefined") {
    throw new Error("No indexedDB in this environment.");
  }
  return new Promise((resolve, reject) => {
    const open = indexedDB.open(dbName, 1);

    open.onupgradeneeded = function () {
      const db = open.result;
      db.createObjectStore(storeName, { keyPath: "pageid" });
    };

    open.onsuccess = function () {
      const db = open.result;
      const tx = db.transaction(storeName, "readwrite");
      const store = tx.objectStore(storeName);

      store.getAll().onsuccess = (event) => {
        const target = event.target;
        if (target == null) {
          reject(new Error("Unexpected null target"));
          return;
        }
        const pages = (
          target as unknown as {
            result: { pageid: number; content: ArrayBuffer }[];
          }
        ).result;
        if (pages.length == 0) {
          memory.init((page) => store.put(page));
        } else {
          memory.restore(pages);
        }
      };

      tx.oncomplete = function () {
        resolve(db);
      };

      tx.onerror = function () {
        reject(new Error("indexedDB Transaction error"));
      };
    };

    open.onerror = function () {
      reject(new Error("indexedDB Open error"));
    };
  });
}

export class IDBStorage implements Storage {
  private storeName: string;
  private memory: PagedMemory;
  private db: IDBDatabase;

  private constructor(storeName: string, db: IDBDatabase, memory: PagedMemory) {
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
    const db = await makeSKDBStore(dbName, storeName, version, memory);
    return new IDBStorage(storeName, db, memory);
  }

  private async storePages(): Promise<boolean> {
    if (this.storeName == null) {
      return new Promise((resolve, _) => {
        resolve(true);
      });
    }
    const storeName = this.storeName;
    return new Promise((resolve, _reject) => {
      if (this.db == null) {
        resolve(true);
      }
      const db = this.db;
      const tx = db.transaction(storeName, "readwrite");
      tx.onabort = () => {
        resolve(false);
      };
      tx.onerror = (err) => {
        console.log("Error sync db: " + JSON.stringify(err));
        resolve(false);
      };
      tx.oncomplete = () => {
        this.memory.clear();
        resolve(true);
      };
      this.memory
        .getPages()
        .then((copiedPages) => {
          const store = tx.objectStore(storeName);
          for (const copiedPage of copiedPages) {
            store.put(copiedPage);
          }
        })
        .catch(() => {
          resolve(false);
        });
    });
  }

  async save() {
    this.memory.update();
    return await this.storePages();
  }
}

/* ***************************************************************************/
/* Primitives to connect to indexedDB. */
/* ***************************************************************************/

export function clear(dbName: string, storeName: string): Promise<void> {
  if (typeof indexedDB === "undefined") {
    throw new Error("No indexedDB in this environment.");
  }
  return new Promise((resolve, reject) => {
    const open = indexedDB.open(dbName, 1);

    open.onupgradeneeded = function () {
      const db = open.result;
      db.createObjectStore(storeName, { keyPath: "pageid" });
    };

    open.onsuccess = function () {
      const db = open.result;
      const tx = db.transaction(storeName, "readwrite");
      const store = tx.objectStore(storeName);

      store.clear();

      tx.oncomplete = function () {
        resolve();
      };

      tx.onerror = function () {
        reject(new Error("indexedDB Transaction error"));
      };
    };

    open.onerror = function () {
      reject(new Error("indexedDB Open error"));
    };
  });
}
