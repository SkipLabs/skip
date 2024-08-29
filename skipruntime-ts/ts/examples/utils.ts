import type {
  TJSON,
  SKStore,
  Schema,
  Table,
  JSONObject,
  TTableCollection,
  TTable,
  createLocaleSKStore as CreateSKStore,
  EntryPoint,
} from "skip-runtime";
import { serverResponseSuffix } from "skip-runtime";

import { Server, type ServerOptions } from "socket.io";
import { createInterface } from "readline";
import { Command } from "commander";
import fs from "fs";
import { resolve } from "path";

export interface ReactiveStorage {
  tablesSchema: () => Schema[];
  initSKStore: (store: SKStore, ...table: TTableCollection[]) => void;
  scenarios: () => Step[][];
}

type Step = string;

class Session {
  scenario: Step[];
  perform: (l: Step) => void;
  error: (e: string) => void;
  current = 0;
  on = false;

  constructor(
    scenario: Step[],
    perform: (l: Step) => void,
    error: (e: string) => void,
  ) {
    this.scenario = scenario;
    this.perform = perform;
    this.error = error;
  }

  next(): boolean {
    if (this.current >= this.scenario.length) {
      this.error("The scenario as no more entries.");
      return false;
    }
    const line = this.scenario[this.current++];
    console.log(line);
    this.perform(line);
    return this.current < this.scenario.length;
  }

  play(): void {
    this.on = this.current < this.scenario.length;
    while (this.on) {
      this.on = this.next();
    }
  }

  pause(): void {
    this.on = false;
  }

  reset(): void {
    this.on = false;
    this.current = 0;
  }
}

class Player {
  scenarios: Step[][];
  running?: Session;
  perform: (l: Step) => void;
  error: (e: string) => void;

  constructor(
    scenarios: Step[][],
    perform: (l: Step) => void,
    error: (e: string) => void,
  ) {
    this.scenarios = scenarios;
    this.perform = perform;
    this.error = error;
  }

  start(idx: number) {
    const scenario = this.scenarios[idx - 1];
    if (!scenario) {
      this.error(`The scenario ${idx} does not exist`);
      return false;
    } else {
      this.running = new Session(scenario, this.perform, this.error);
      return true;
    }
  }

  play(idx?: number) {
    let run = true;
    if (idx ?? 0 > 0) {
      run = this.start(idx!);
    }
    if (run) {
      if (this.running) {
        this.running.play();
      } else {
        this.error(`No current scenario session`);
      }
    }
  }

  step(idx?: number) {
    const running = this.running;
    if (!running) {
      this.error(`No current scenario session`);
      return;
    }
    let steps = Math.min(idx ?? 1, 1);
    while (steps > 0) {
      if (!running.next()) {
        break;
      }
      steps--;
    }
  }

  reset() {
    const running = this.running;
    if (running) running.reset();
  }

  stop() {
    this.running = undefined;
  }

  online(line: string) {
    if (line.trim().length == 0 && this.running) {
      this.step();
      return;
    }
    const patterns: [RegExp, (...args: string[]) => any][] = [
      [/^start ([a-z_0-9]+)$/g, (str: string) => this.start(parseInt(str))],
      [/^reset$/g, () => this.reset()],
      [/^step ([a-z_0-9]+)$/g, (str: string) => this.step(parseInt(str))],
      [/^step$/g, () => this.step()],
      [/^play ([a-z_0-9]+)$/g, (str: string) => this.play(parseInt(str))],
      [/^play$/g, () => this.play()],
      [/^stop$/g, () => this.stop()],
    ];
    let done = false;
    for (let i = 0; i < patterns.length; i++) {
      const pattern = patterns[i];
      const matches = [...line.matchAll(pattern[0])];
      if (matches.length > 0) {
        done = true;
        const args = matches[0].map((v) => v.toString());
        args.shift();
        pattern[1].apply(null, args);
      }
    }
    if (!done) this.perform(line);
  }

  toCommands() {
    [
      ["start", (id: string) => this.start(parseInt(id))],
      ["reset", () => this.reset()],
      ["step", (str?: string) => this.step(str ? parseInt(str) : undefined)],
      ["play", (str?: string) => this.play(str ? parseInt(str) : undefined)],
      ["stop", () => this.stop()],
    ];
  }
}

interface ReactiveService {
  run: (...tables: TTable[]) => void;
}

class SKDBWatcher {
  private watches: Map<string, () => void>;
  private tables: Map<string, Table<TJSON[]>>;
  private error: (msg: string) => void;

  constructor(
    error: (msg: string) => void,
    tables: Map<string, Table<TJSON[]>>,
  ) {
    this.error = error;
    this.watches = new Map();
    this.tables = tables;
  }

  watch(name: string, onChange: (rows: JSONObject[]) => void) {
    if (this.watches.has(name)) {
      this.watches.get(name)!();
    }
    const feedback = name.endsWith(serverResponseSuffix);

    const table_name = feedback
      ? name.substring(0, name.length - serverResponseSuffix.length)
      : name;
    if (!this.tables.has(table_name)) {
      this.error(`Unable to find ${table_name} table.`);
      return;
    }
    this.watches.set(
      name,
      this.tables.get(table_name)!.watch(onChange, feedback).close,
    );
  }

  watchChanges(
    name: string,
    init: (rows: JSONObject[]) => void,
    update: (added: JSONObject[], removed: JSONObject[]) => void,
  ) {
    if (this.watches.has(name)) {
      this.watches.get(name)!();
    }
    const feedback = name.endsWith(serverResponseSuffix);

    const table_name = feedback
      ? name.substring(0, name.length - serverResponseSuffix.length)
      : name;
    if (!this.tables.has(table_name)) {
      this.error(`Unable to find ${name} table.`);
      return;
    }
    this.watches.set(
      name,
      this.tables.get(table_name)!.watchChanges(init, update, feedback).close,
    );
  }

  close(name: string) {
    if (this.watches.has(name)) {
      this.watches.get(name)!();
      this.watches.delete(name);
    }
  }
}

export class SocketServerService implements ReactiveService {
  options?: Partial<ServerOptions>;
  port: number;

  constructor(port: number = 3000, options?: Partial<ServerOptions>) {
    this.port = port;
    this.options = options;
  }

  run = (...tables: any[]) => {
    const tablesByName: Map<string, Table<TJSON[]>> = new Map();
    tables.forEach((table) => {
      tablesByName.set(table.getName(), table);
    });
    const io = new Server(this.options);
    io.on("connection", (socket: any) => {
      const watcher = new SKDBWatcher(console.error, tablesByName);
      const error = (msg: string) => socket.emit("error", msg);
      socket.on("insert", (name: string, values: string) => {
        const table = tablesByName.get(name);
        if (!table) {
          error(`Unable to find ${name} table.`);
          return;
        }
        table.insert(JSON.parse(values), true);
      });
      socket.on("delete", (name: string, where: string) => {
        const table = tablesByName.get(name);
        if (!table) {
          error(`Unable to find ${name} table.`);
          return;
        }
        table.deleteWhere(JSON.parse(where));
      });
      socket.on("update", (name: string, params: string) => {
        const table = tablesByName.get(name);
        if (!table) {
          error(`Unable to find ${name} table.`);
          return;
        }
        const jsParams = JSON.parse(params);
        table.updateWhere(jsParams.where, jsParams.update);
      });
      socket.on("watch", (name: string) => {
        watcher.watch(name, (rows) => {
          socket.emit("watch", name, JSON.stringify(rows));
        });
      });
      socket.on("watch-changes", (name: string) => {
        watcher.watchChanges(
          name,
          (rows) => {
            socket.emit("watch-init", name, JSON.stringify(rows));
          },
          (added, removed) => {
            socket.emit(
              "watch-update",
              name,
              JSON.stringify({ added, removed }),
            );
          },
        );
      });
      socket.on("close", watcher.close);
      socket.on("exit", () => socket.disconnect(true));
    });
    io.listen(this.port);
  };
}

export interface WatchListener {
  error: (message: any) => void;
  table: (table: JSONObject[]) => void;
  update?: (name: string, table: JSONObject[]) => void;
  changeInit?: (name: string, table: JSONObject[]) => void;
  changeUpdate?: (
    name: string,
    added: JSONObject[],
    removed: JSONObject[],
  ) => void;
}

export class IOInputService implements ReactiveService {
  scenarios: Step[][];
  listener: WatchListener;

  constructor(scenarios: Step[][], listener: WatchListener = new JSONLogger()) {
    this.scenarios = scenarios;
    this.listener = listener;
  }

  run = (...tables: any[]) => {
    const tablesByName: Map<string, Table<TJSON[]>> = new Map();
    tables.forEach((table) => {
      tablesByName.set(table.getName(), table);
    });
    const watcher = new SKDBWatcher(this.listener.error, tablesByName);
    const online = (line: string) => {
      const matches = [
        ...line.matchAll(/^(watch|watch-changes) ([a-z_0-9\-]+)$/g),
      ];
      if (matches.length > 0) {
        const match = matches[0];
        const name = match[2];
        if (match[1] == "watch") {
          const update = this.listener.update;
          if (!update) {
            this.listener.error("No update function supplies.");
          } else {
            watcher.watch(name, (rows) => update(name, rows));
          }
        } else {
          const changeInit = this.listener.changeInit;
          const changeUpdate = this.listener.changeUpdate;
          if (!changeInit || !changeUpdate) {
            this.listener.error("No update changes function supplies.");
          } else {
            watcher.watchChanges(
              name,
              (rows) => changeInit(name, rows),
              (added, removed) => changeUpdate(name, added, removed),
            );
          }
        }
      } else if (line.startsWith("close ")) {
        const name = line.substring(6).trim();
        watcher.close(name);
      } else {
        const error = this.listener.error;
        try {
          const patterns: [RegExp, (...args: string[]) => any][] = [
            [
              /^insert ([a-z_0-9]+) (.*)$/g,
              (name: string, values: string) => {
                const table = tablesByName.get(name);
                if (!table) {
                  error(`Unable to find ${name} table.`);
                  return;
                }
                table.insert(JSON.parse(values), true);
              },
            ],
            [
              /^delete ([a-z_0-9]+) (.*)$/g,
              (name: string, where: string) => {
                const table = tablesByName.get(name);
                if (!table) {
                  error(`Unable to find ${name} table.`);
                  return;
                }
                table.deleteWhere(JSON.parse(where));
              },
            ],
            [
              /^select ([a-z_0-9]+) (.*)$/g,
              (name: string, where: string) => {
                const table = tablesByName.get(name);
                if (!table) {
                  error(`Unable to find ${name} table.`);
                  return;
                }
                const jsdata = JSON.parse(where);
                const result = table.select(jsdata.where, jsdata.colmuns);
                this.listener.table(result);
              },
            ],
            [
              /^update ([a-z_0-9]+) (.*)$/g,
              (name: string, params: string) => {
                const table = tablesByName.get(name);
                if (!table) {
                  error(`Unable to find ${name} table.`);
                  return;
                }
                const jsParams = JSON.parse(params);
                table.updateWhere(jsParams.where, jsParams.update);
              },
            ],
          ];
          let done = false;
          for (let i = 0; i < patterns.length; i++) {
            const pattern = patterns[i];
            const matches = [...line.matchAll(pattern[0])];
            if (matches.length > 0) {
              done = true;
              const args = matches[0].map((v) => v.toString());
              args.shift();
              pattern[1].apply(null, args);
            }
          }
          if (!done) {
            error(`Unknow command line '${line}'`);
          }
        } catch (e: any) {
          const message = e instanceof Error ? e.message : JSON.stringify(e);
          this.listener.error(message);
        }
      }
    };
    const player = new Player(this.scenarios, online, this.listener.error);
    const rl = createInterface({
      input: process.stdin,
      output: process.stdout,
      prompt: "> ",
    });
    rl.prompt();
    rl.on("line", (line) => {
      if (line == "exit") {
        process.exit(0);
      } else {
        player.online(line);
        rl.prompt();
      }
    });
  };
}

export class NoopService implements ReactiveService {
  run = (...tables: any[]) => {};
}

export class JSONLogger implements WatchListener {
  error = console.error;
  table = console.table;
  update = (name: string, table: JSONObject[]) => {
    console.log(JSON.stringify(["watch", name, table]));
  };
  changeInit = (name: string, table: JSONObject[]) => {
    console.log(JSON.stringify(["watch-init", name, table]));
  };
  changeUpdate = (name: string, added: JSONObject[], removed: JSONObject[]) => {
    console.log(JSON.stringify(["watch-update", name, added, removed]));
  };
}

async function getCreds(database: string, entryPoint: EntryPoint) {
  try {
    const creds = new Map();
    const resp = await fetch(
      `http${entryPoint.secured ? "s" : ""}://${entryPoint.host}:${
        entryPoint.port
      }/dbs/${database}/users`,
    );
    const data = await resp.text();
    const users = data
      .split("\n")
      .filter((line) => line.trim() != "")
      .map((line) => JSON.parse(line));
    for (const user of users) {
      creds.set(user.accessKey, user.privateKey);
    }
    return creds;
  } catch (ex: any) {
    return null;
  }
}

async function checkCreds(
  database: string,
  user: string,
  entryPoint: EntryPoint,
  retry = 5,
) {
  var count = 0;
  const waitandcheck = (
    resolve: (pk: string) => void,
    reject: (reason?: any) => void,
  ) => {
    if (count == retry)
      reject("Could not fetch from the dev server, is it running?");
    count++;
    getCreds(database, entryPoint).then((creds) => {
      if (creds != null) {
        const pk = creds.get(user);
        if (pk != null) {
          resolve(pk);
        } else {
          reject(`Unable to find ${user} credential`);
        }
      } else {
        setTimeout(waitandcheck, 500, resolve, reject);
      }
    });
  };
  return new Promise(waitandcheck);
}

export async function start(
  createSKStore: typeof CreateSKStore,
  service: ReactiveService,
  storage: ReactiveStorage,
  database: string | null,
  port: number = 3586,
) {
  try {
    const cdatabase = database
      ? {
          name: database,
          access: "root",
          private: await checkCreds(database, "root", {
            host: "localhost",
            port,
          }),
          endpoint: { host: "localhost", port },
        }
      : null;
    if (cdatabase && !cdatabase.private) {
      throw new Error("Unable to retrieve root credential.");
    }
    const tables = await createSKStore(
      storage.initSKStore,
      storage.tablesSchema(),
      cdatabase ? cdatabase : undefined,
    );
    service.run(...tables);
  } catch (e) {
    throw e;
  }
}

export async function main(createSKStore: typeof CreateSKStore) {
  const program = new Command();
  program
    .version("0.0.1")
    .description("Example launcher")
    .option(
      "-m,  --mode <io|socket|noop>",
      "Launch mode (default: noop)",
      "noop",
    )
    .option("-f,  --file <skstore_file>", "The SKStore example file")
    .option(
      "-p, --port <port>",
      "Port number in socket server mode (default: 3000)",
      "3000",
    )
    .option(
      "-c, --connect <database>",
      "Specify the database to connect for table mirroring",
    )
    .parse(process.argv);

  const options = program.opts();
  const file = options.file;
  if (!file) {
    console.error("SKStore example file must be specified.");
    console.log(program.usage());
    return;
  }
  let database: string | null = null;
  if (typeof options.connect == "string" && options.connect != "") {
    database = options.connect;
  }
  if (database != null) {
    console.log("Run for database:", database);
  }
  if (!fs.existsSync(file)) {
    console.error("SKStore example file does not exists.");
    return;
  }
  const path = resolve(file);
  try {
    var storage = (await import(path)) as ReactiveStorage;
    switch (options.mode) {
      case "io":
        await start(
          createSKStore,
          new IOInputService(storage.scenarios()),
          storage,
          database,
        );
        break;
      case "socket":
        await start(
          createSKStore,
          new SocketServerService(parseInt(options.port)),
          storage,
          database,
        );
        break;
      case "noop":
      default:
        await start(createSKStore, new NoopService(), storage, database);
        break;
    }
  } catch (e: any) {
    console.error("Invalid SKStore example file.");
    console.error(e);
    process.exit(2);
  }
}
