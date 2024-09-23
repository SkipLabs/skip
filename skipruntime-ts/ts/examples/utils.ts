import type {
  TJSON,
  EntryPoint,
  Entry,
  JSONObject,
} from "skip-runtime";
import { SkipRESTRuntime } from "skip-runtime";
import { createInterface } from "readline";

export interface ClientDefinition {
  port: number;
  scenarios: () => Step[][];
}

type Write = {
  collection: string;
  entries: Entry<TJSON, TJSON>[];
};

type Delete = {
  collection: string;
  keys: string[];
};

class SkipHttpAccessV1 {
  private runtime: SkipRESTRuntime;
  constructor(
    entrypoint: EntryPoint = {
      host: "localhost",
      port: 3587,
    },
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
    const result = await this.runtime.getAll(resource, params);
    return result.values;
  }
}

type RequestQuery = { type: "request"; payload: JSONObject };
type WriteQuery = { type: "write"; payload: Write[] };
type DeleteQuery = { type: "delete"; payload: Delete[] };

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
    const scenario = this.scenarios[idx - 1];
    if (!scenario) {
      this.error(`The scenario ${idx} does not exist`);
      return false;
    } else {
      this.running = new Session(scenario, this.send, this.error);
      return true;
    }
  }

  play(idx = 0) {
    let run = true;
    if (idx > 0) {
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

export function run(scenarios: Step[][], port: number = 3587) {
  const access = new SkipHttpAccessV1({
    host: "localhost",
    port,
  });
  const online = async (line: string) => {
    const error = console.error;
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
              .catch(console.error);
          },
        ],
        [
          /^write (.*)$/g,
          async (query: string) => {
            const jsquery = JSON.parse(query);
            access.writeMany(jsquery).then(console.log).catch(console.error);
          },
        ],
        [
          /^delete (.*)$/g,
          async (query: string) => {
            const jsquery = JSON.parse(query);
            access.deteleMany(jsquery).then(console.log).catch(console.error);
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
        error(`Unknow command line '${line}'`);
      }
    } catch (e: any) {
      const message = e instanceof Error ? e.message : JSON.stringify(e);
      error(message);
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
          .catch(console.error);
      } else if (step.type == "write") {
        access.writeMany(step.payload).then(console.log).catch(console.error);
      } else {
        access.deteleMany(step.payload).then(console.log).catch(console.error);
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
