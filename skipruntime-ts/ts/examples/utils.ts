import type { JSONObject } from "skip-runtime";
import { createInterface } from "readline";
// @ts-ignore
import { WebSocket } from "ws";

export interface ClientDefinition {
  port: number;
  scenarios: () => Step[][];
}

type Step = JSONObject;

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
    console.log(">>", JSON.stringify(line));
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
}

export async function run(scenarios: Step[][], port: number) {
  const ws = new WebSocket(`ws://localhost:${port}`);
  ws.on("error", console.error);
  ws.on("close", () => process.exit(2));
  ws.on("message", (data: Buffer) => {
    console.log(data.toString());
  });
  ws.on("open", function open() {
    const online = (line: string) => {
      const error = console.error;
      try {
        const patterns: [RegExp, (...args: string[]) => any][] = [
          [
            /^get (.*)$/g,
            (query: string) => {
              const jsquery = JSON.parse(query);
              jsquery["type"] = "get";
              ws.send(jsquery);
            },
          ],
          [
            /^post (.*)$/g,
            (query: string) => {
              const jsquery = JSON.parse(query);
              jsquery["type"] = "post";
              ws.send(jsquery);
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
        error(message);
      }
    };
    const player = new Player(
      scenarios,
      online,
      (event) => ws.send(JSON.stringify(event)),
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
  });
}
