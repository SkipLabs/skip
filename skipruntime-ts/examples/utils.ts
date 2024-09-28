import type { TJSON, EntryPoint, Entry, JSONObject } from "skip-runtime";
import { SkipRESTRuntime } from "skip-runtime";
import { createInterface } from "readline";
import { connect, Protocol, Client } from "skipruntime-client";

export interface ClientDefinition {
  port: number;
  scenarios: () => Step[][];
}

interface Write {
  collection: string;
  entries: Entry<TJSON, TJSON>[];
}

interface Delete {
  collection: string;
  keys: string[];
}

function toWs(entrypoint: EntryPoint) {
  if (entrypoint.secured)
    return `wss://${entrypoint.host}:${entrypoint.port.toString()}`;
  return `ws://${entrypoint.host}:${entrypoint.port.toString()}`;
}

class SkipHttpAccessV1 {
  private runtime: SkipRESTRuntime;
  private client?: Client;

  constructor(
    private entrypoint: EntryPoint = {
      host: "localhost",
      port: 3587,
    },
    private creds: Protocol.Creds,
  ) {
    this.runtime = new SkipRESTRuntime(entrypoint);
  }

  async writeMany(data: Write[]) {
    const promises = data.map((w) =>
      this.runtime.patch(w.collection, w.entries),
    );
    return Promise.allSettled(promises);
  }

  async deteleMany(data: Delete[]) {
    const promises: Promise<void>[] = [];
    for (const x of data) {
      for (const key of x.keys) {
        promises.push(this.runtime.delete(x.collection, key));
      }
    }
    return Promise.allSettled(promises);
  }

  async request(resource: string, params: Record<string, string>) {
    const publicKey = new Uint8Array(
      await Protocol.exportKey(this.creds.publicKey),
    );
    const reactive = await this.runtime.head(resource, params, publicKey);
    if (!this.client) {
      this.client = await connect(toWs(this.entrypoint), this.creds);
    }
    this.client.subscribe(
      reactive.collection,
      BigInt(reactive.watermark),
      (updates: [string, TJSON[]][], isInit: boolean) => {
        console.log("Update", Object.fromEntries(updates), isInit);
      },
    );
  }
}

interface RequestQuery {
  type: "request";
  payload: JSONObject;
}
interface WriteQuery {
  type: "write";
  payload: Write[];
}
interface DeleteQuery {
  type: "delete";
  payload: Delete[];
}

export type Step = RequestQuery | WriteQuery | DeleteQuery;

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
    const step = this.scenario[this.current++];
    console.log(">>", step.type, JSON.stringify(step.payload));
    this.perform(step);
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
  running?: Session;

  constructor(
    private scenarios: Step[][],
    private perform: (l: string) => void,
    private send: (l: Step) => void,
    private error: (e: string) => void,
  ) {}

  start(idx: number) {
    const aidx = idx - 1;
    if (aidx < 0 || aidx >= this.scenarios.length) {
      this.error(`The scenario ${idx.toString()} does not exist`);
      return false;
    } else {
      const scenario = this.scenarios[idx - 1];
      this.running = new Session(scenario, this.send, this.error);
      return true;
    }
  }

  play(idx?: number) {
    let run = true;
    if (idx !== undefined) {
      run = this.start(idx);
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
    const patterns: [RegExp, (...args: string[]) => unknown][] = [
      [
        /^start ([a-z_0-9]+)$/g,
        (str: string) => {
          this.start(parseInt(str));
        },
      ],
      [
        /^reset$/g,
        () => {
          this.reset();
        },
      ],
      [
        /^step ([a-z_0-9]+)$/g,
        (str: string) => {
          this.step(parseInt(str));
        },
      ],
      [
        /^step$/g,
        () => {
          this.step();
        },
      ],
      [
        /^play ([a-z_0-9]+)$/g,
        (str: string) => {
          this.play(parseInt(str));
        },
      ],
      [
        /^play$/g,
        () => {
          this.play();
        },
      ],
      [
        /^stop$/g,
        () => {
          this.stop();
        },
      ],
    ];
    let done = false;
    for (const pattern of patterns) {
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
}
/**
 * Run the client with specified scenarios
 * @param scenarios The scenarios
 * @param port  The port
 */
export async function run(scenarios: Step[][], port: number = 3587) {
  const creds = await Protocol.generateCredentials();
  const access = new SkipHttpAccessV1(
    {
      host: "localhost",
      port,
    },
    creds,
  );
  const online = (line: string) => {
    try {
      const patterns: [RegExp, (...args: string[]) => void][] = [
        [
          /^request (.*)$/g,
          (query: string) => {
            const jsquery = JSON.parse(query) as {
              resource: string;
              params?: Record<string, string>;
            };
            access
              .request(jsquery.resource, jsquery.params ?? {})
              .then(console.log)
              .catch((e: unknown) => {
                console.error(e);
              });
          },
        ],
        [
          /^write (.*)$/g,
          (query: string) => {
            const jsquery = JSON.parse(query) as Write[];
            access
              .writeMany(jsquery)
              .then(console.log)
              .catch((e: unknown) => {
                console.error(e);
              });
          },
        ],
        [
          /^delete (.*)$/g,
          (query: string) => {
            const jsquery = JSON.parse(query) as Delete[];
            access
              .deteleMany(jsquery)
              .then(console.log)
              .catch((e: unknown) => {
                console.error(e);
              });
          },
        ],
      ];
      let done = false;
      for (const pattern of patterns) {
        const matches = [...line.matchAll(pattern[0])];
        if (matches.length > 0) {
          done = true;
          const args = matches[0].map((v) => v.toString());
          args.shift();
          pattern[1].apply(null, args);
        }
      }
      if (!done) {
        console.error(`Unknow command line '${line}'`);
      }
    } catch (e: unknown) {
      const message = e instanceof Error ? e.message : JSON.stringify(e);
      console.error(message);
    }
  };
  const player = new Player(
    scenarios,
    online,
    (step) => {
      if (step.type == "request") {
        const jsquery = step.payload as {
          resource: string;
          params?: Record<string, string>;
        };
        access
          .request(jsquery.resource, jsquery.params ?? {})
          .then(console.log)
          .catch((e: unknown) => {
            console.error(e);
          });
      } else if (step.type == "write") {
        access
          .writeMany(step.payload)
          .then(console.log)
          .catch((e: unknown) => {
            console.error(e);
          });
      } else {
        access
          .deteleMany(step.payload)
          .then(console.log)
          .catch((e: unknown) => {
            console.error(e);
          });
      }
    },
    console.error,
  );
  const rl = createInterface({
    input: process.stdin,
    output: process.stdout,
    prompt: "> ",
  });
  rl.prompt();
  rl.on("line", (line: string) => {
    if (line == "exit") {
      process.exit(0);
    } else {
      player.online(line);
      rl.prompt();
    }
  });
}
