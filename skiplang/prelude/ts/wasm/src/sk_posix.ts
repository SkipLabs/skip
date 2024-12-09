import type { int } from "@skiplang/std";
import type {
  ptr,
  Environment,
  Links,
  ToWasmManager,
  Utils,
  FileSystem,
} from "./sk_types.js";
import { Options } from "./sk_types.js";
import type * as Internal from "@skiplang/std/internal.js";

interface ToWasm {
  SKIP_check_if_file_exists: (skPath: ptr<Internal.String>) => boolean;
  SKIP_js_open: (skPath: ptr<Internal.String>, flags: int, mode: int) => int;
  SKIP_js_close: (fd: int) => void;
  SKIP_js_write: (fd: int, skContents: ptr<Internal.String>, len: int) => int;
  SKIP_js_read: (fd: int, skContents: ptr<Internal.String>, len: int) => int;
  SKIP_js_open_flags: (
    read: boolean,
    write: boolean,
    append: boolean,
    truncate: boolean,
    create: boolean,
    create_new: boolean,
  ) => int;
  // TODO check why is linked in skargo
  SKIP_js_pipe: (...args: any[]) => any;
  SKIP_js_fork: (...args: any[]) => any;
  SKIP_js_dup2: (...args: any[]) => any;
  SKIP_js_execvp: (...args: any[]) => any;
}

class LinksImpl implements Links, ToWasm {
  private readonly fs: FileSystem;
  SKIP_check_if_file_exists!: (skPath: ptr<Internal.String>) => boolean;
  SKIP_js_open!: (skPath: ptr<Internal.String>, flags: int, mode: int) => int;
  SKIP_js_close!: (fd: int) => void;
  SKIP_js_write!: (fd: int, skContents: ptr<Internal.String>, len: int) => int;
  SKIP_js_read!: (fd: int, skContents: ptr<Internal.String>, len: int) => int;
  SKIP_js_open_flags!: (
    read: boolean,
    write: boolean,
    append: boolean,
    truncate: boolean,
    create: boolean,
    create_new: boolean,
  ) => int;
  //
  SKIP_js_pipe!: () => any;
  SKIP_js_fork!: () => any;
  SKIP_js_dup2!: () => any;
  SKIP_js_execvp!: (...args: any[]) => any;
  SKIP_js_invalid: (...args: any[]) => any = () => {
    throw new Error("Cannot be called within JS");
  };

  constructor(environment: Environment) {
    this.fs = environment.fs();
  }

  complete = (utils: Utils, _exports: object) => {
    this.SKIP_check_if_file_exists = (skPath) => {
      return this.fs.exists(utils.importString(skPath));
    };
    this.SKIP_js_open = (
      skPath: ptr<Internal.String>,
      flags: int,
      mode: int,
    ) => {
      return this.fs.openFile(
        utils.importString(skPath),
        Options.fromFlags(flags),
        mode,
      );
    };
    this.SKIP_js_close = (fd: int) => {
      return this.fs.closeFile(fd);
    };
    this.SKIP_js_write = (
      fd: int,
      skContents: ptr<Internal.String>,
      len: int,
    ) => {
      // TODO: Write bytes directly into fs.
      this.fs.write(
        fd,
        new TextDecoder().decode(utils.importBytes2(skContents, len)),
      );
      return len;
    };
    this.SKIP_js_read = (
      fd: int,
      skContents: ptr<Internal.String>,
      len: int,
    ) => {
      const res = this.fs.read(fd, len);
      if (res !== null) {
        utils.exportBytes2(new TextEncoder().encode(res), skContents);
      }
      return len;
    };
    this.SKIP_js_open_flags = (
      read: boolean,
      write: boolean,
      append: boolean,
      truncate: boolean,
      create: boolean,
      create_new: boolean,
    ) => {
      return new Options(
        read,
        write,
        append,
        truncate,
        create,
        create_new,
      ).toFlags();
    };
    //
    this.SKIP_js_pipe = this.SKIP_js_invalid;
    this.SKIP_js_fork = this.SKIP_js_invalid;
    this.SKIP_js_dup2 = this.SKIP_js_invalid;
    this.SKIP_js_execvp = this.SKIP_js_invalid;
  };
}

class Manager implements ToWasmManager {
  constructor(private readonly environment: Environment) {}

  prepare = (wasm: object) => {
    const toWasm = wasm as ToWasm;
    const links = new LinksImpl(this.environment);
    toWasm.SKIP_js_open = (
      skPath: ptr<Internal.String>,
      flags: int,
      mode: int,
    ) => links.SKIP_js_open(skPath, flags, mode);
    toWasm.SKIP_js_close = (fd: int) => links.SKIP_js_close(fd);
    toWasm.SKIP_js_write = (
      fd: int,
      skContents: ptr<Internal.String>,
      len: int,
    ) => links.SKIP_js_write(fd, skContents, len);
    toWasm.SKIP_js_read = (
      fd: int,
      skContents: ptr<Internal.String>,
      len: int,
    ) => links.SKIP_js_read(fd, skContents, len);
    toWasm.SKIP_js_open_flags = (
      read: boolean,
      write: boolean,
      append: boolean,
      truncate: boolean,
      create: boolean,
      create_new: boolean,
    ) =>
      links.SKIP_js_open_flags(
        read,
        write,
        append,
        truncate,
        create,
        create_new,
      );
    //
    /* eslint-disable @typescript-eslint/no-unsafe-return */
    toWasm.SKIP_js_pipe = () => links.SKIP_js_pipe();
    toWasm.SKIP_js_fork = () => links.SKIP_js_fork();
    toWasm.SKIP_js_dup2 = () => links.SKIP_js_dup2();
    toWasm.SKIP_js_execvp = () => links.SKIP_js_execvp();
    /* eslint-enable @typescript-eslint/no-unsafe-return */
    return links;
  };
}

/* @sk init */
export function init(env?: Environment) {
  return Promise.resolve(new Manager(env!));
}
