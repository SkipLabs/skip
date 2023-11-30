import {
  int,
  ptr,
  Environment,
  Links,
  ToWasmManager,
  Utils,
  FileSystem,
  Options,
} from "#std/sk_types";

interface ToWasm {
  SKIP_localetimezone: (year: int, month: int, day: int) => int;
  SKIP_localetimezonename: (year: int, month: int, day: int) => ptr;
  SKIP_locale: (code: int, value: int) => ptr;
  SKIP_JS_currenttimemillis: () => number;
}

class LinksImpl implements Links {
  SKIP_localetimezone: (year: int, month: int, day: int) => int;
  SKIP_localetimezonename: (year: int, month: int, day: int) => ptr;
  SKIP_locale: (code: int, value: int) => ptr;

  constructor() {}

  complete = (utils: Utils, exports: object) => {
    this.SKIP_localetimezone = (year: int, month: int, day: int) => {
      let date = new Date(year, month - 1, day);
      let offset = -(date.getTimezoneOffset() * 60);
      return offset;
    };
    this.SKIP_localetimezonename = (year: int, month: int, day: int) => {
      let date = new Date(year, month - 1, day);
      const timeZone = date.toLocaleDateString(undefined, {
        timeZoneName: "short",
      });
      return utils.exportString(timeZone);
    };
    this.SKIP_locale = (code: int, value: int) => {
      let str = String.fromCharCode(code);
      if (str == "B" || str == "b") {
        let date = new Date(Date.UTC(2023, 0 + (value - 1), 1)); // January
        let name = date.toLocaleDateString(undefined, {
          month: str == "b" ? "short" : "long",
        });
        return utils.exportString(name);
      }
      if (str == "A" || str == "a") {
        let date = new Date(Date.UTC(2023, 8, 18 + (value - 1))); // A monday
        let name = date.toLocaleDateString(undefined, {
          weekday: str == "a" ? "short" : "long",
        });
        return utils.exportString(name);
      }
      if (str == "p") {
        let hour = 10;
        if (value == 1) {
          hour = 15;
        }
        let date = new Date(2023, 8, 18, hour);
        let m = date
          .toLocaleDateString(undefined, { hour12: true, hour: "numeric" })
          .split(" ");
        return utils.exportString(m[m.length - 1]);
      }
      if (str == "c" || str == "X" || str == "x" || str == "r") {
        return utils.exportString("");
      }
      return utils.exportString("%%" + str);
    };
  };
}

class Manager implements ToWasmManager {
  constructor() {}

  prepare = (wasm: object) => {
    let toWasm = wasm as ToWasm;
    let links = new LinksImpl();
    toWasm.SKIP_localetimezone = (year: int, month: int, day: int) =>
      links.SKIP_localetimezone(year, month, day);
    toWasm.SKIP_localetimezonename = (year: int, month: int, day: int) =>
      links.SKIP_localetimezonename(year, month, day);
    toWasm.SKIP_locale = (code: int, value: int) =>
      links.SKIP_locale(code, value);
    toWasm.SKIP_JS_currenttimemillis = () => Date.now() / 1000;
    return links;
  };
}

/** @sk init */
export function init(env?: Environment) {
  return Promise.resolve(new Manager());
}
