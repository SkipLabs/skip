import { Options, run } from "#std/sk_types";

var wasm64 = "skmd";
// sknpm searches for the modules line verbatim
// prettier-ignore
var modules = [ /*--MODULES--*/];
var extensions = new Map();
/*--EXTENSIONS--*/

export type Conf = {
  title?: string;
  description?: string;
  icon?: string;
  styles?: string[];
  scripts?: string[];
  customs?: string[];
  header?: string;
  footer?: string;
  lang?: string;
  charset?: string;
  extends?: string;
  tableOfContent?: number;
};

export async function createMDConverter() {
  const data = await run(wasm64, modules, extensions);
  const fs = data.environment.fs();
  const write = (name: string, content: string) => {
    const fd = fs.openFile(name, Options.w(), 0);
    fs.writeToFile(fd, content);
    fs.closeFile(fd);
  };
  return (md: string, conf: Conf) => {
    let args: string[] = ["html"];
    if (conf) {
      if (conf.header) {
        write("__header__", conf.header);
        conf.header = "__header__";
      }
      if (conf.footer) {
        write("__footer__", conf.footer);
        conf.footer = "__footer__";
      }
      if (conf.customs) {
        let idx = 0;
        conf.customs.forEach((s) => {
          const id = "__custom__" + idx + "__";
          write(id, s);
          conf.customs![idx] = id;
          idx++;
        });
      }
      write("__conf__", JSON.stringify(conf));
      args.push("--conf", "__conf__");
    }
    return data.main(args, md);
  };
}
