import { createMDConverter, Conf } from "#skmd/skmd";
import * as fs from "fs";
import * as path from "path";
import * as chokidar from "chokidar";
import * as http from "http";
import * as mime from "mime-types";
import * as sass from "sass";
import { exec } from "child_process";

console.time("skmd ready");

process.on("unhandledRejection", console.error);

let version = Date.now();

let checkVersion = `<script> 
  var version;
  function check(interval) {
    fetch("/__version__/").then(res => res.json()).then(v => {
      if (version != undefined && v.version > version) {
        clearInterval(interval);
        location.reload();
      }
      version = v.version
    }).catch(console.error);
  }
  let interval = setInterval(() => check(interval), 1000);
</script>`;

var logTimeout: any;
var updates = new Set<string>();

var count = 1;

function addCheckVersion(buffer: Buffer) {
  return Buffer.from(
    buffer.toString().replace("</head>", checkVersion + "</head>"),
    "utf8",
  );
}

function log(message: string) {
  if (logTimeout) {
    clearTimeout(logTimeout);
  }
  updates.add(message);
  logTimeout = setTimeout(() => {
    console.log("---- " + count);
    updates.forEach((v, _) => console.log(v));
    updates.clear();
    count++;
  }, 50);
}

function mvext(file: string, extension: string) {
  const basename = path.basename(file, path.extname(file));
  return path.join(path.dirname(file), basename + extension);
}

const docsPath = "./docs";
const srcPath = "./src";
const distName = "site";
const distPath = "./" + distName;
if (!fs.existsSync(srcPath)) {
  fs.mkdirSync(srcPath);
} else if (!fs.lstatSync(srcPath).isDirectory()) {
  throw new Error('Invalid project path: "src" must be a directory');
}

const relative = (ref: string, file: string, target: string) => {
  const relmd = path.relative(ref, file);
  return path.join(target, relmd);
};

const clientAbsolute = (ref: string, file: string) => {
  ref = ref.replace(/\/+$/, "");
  if (!file.startsWith(ref + "/")) {
    throw new Error(
      "clientAbsolute: The file path does not contains base path",
    );
  }
  return file.substring(ref.length);
};

const skmd = await createMDConverter();

const dependencies: Map<string, Set<string>> = new Map();
const allfiles: Set<string> = new Set();

const addDependency = (src: string, dep: string) => {
  let aSrc = absolute(src);
  let aDep = absolute(dep);
  if (!fs.existsSync(aDep) || aSrc == aDep) {
    return;
  }
  let cur = dependencies.get(aSrc);
  if (!cur) {
    cur = new Set();
    dependencies.set(aSrc, cur);
  }
  cur.add(aDep);
};

const absolute = (...args: string[]) => {
  return path.resolve.apply(null, [process.cwd()].concat(args));
};

const overrideConf = (c1: Conf, c2: Conf) => {
  if (c2.title) c1.title = c2.title;
  if (c2.description) c1.description = c2.description;
  if (c2.icon) c1.icon = c2.icon;
  if (c2.styles) c1.styles = c2.styles;
  if (c2.scripts) c1.scripts = c2.scripts;
  if (c2.customs) c1.customs = c2.customs;
  if (c2.header) c1.header = c2.header;
  if (c2.footer) c1.footer = c2.footer;
  if (c2.lang) c1.lang = c2.lang;
  if (c2.charset) c1.charset = c2.charset;
  if (c2.tableOfContent != undefined) c1.tableOfContent = c2.tableOfContent;
  return c1;
};

const manageMd = (md: string) => {
  let time = fs.statSync(md).atimeMs;
  const conf = mvext(md, ".json");
  let js = {} as Conf;
  if (fs.existsSync(conf)) {
    try {
      js = JSON.parse(fs.readFileSync(conf).toString()) as Conf;
      time = Math.max(fs.statSync(conf).atimeMs, time);
    } catch (ex) {
      console.error(["Invalid json file: " + conf, ex]);
    }
  }
  let dir = path.dirname(conf);
  while (js.extends) {
    let jsFile = js.extends;
    js.extends = undefined;
    let abs = absolute(dir, jsFile!);
    addDependency(abs, md);
    try {
      let tmp = JSON.parse(fs.readFileSync(abs).toString()) as Conf;
      time = Math.max(fs.statSync(abs).atimeMs, time);
      js = overrideConf(tmp, js);
    } catch (ex) {
      console.error(["Invalid json file: " + jsFile, ex]);
    }
  }
  let config = js;
  if (config.header) {
    let name = absolute(dir, config.header);
    config.header = fs.readFileSync(name).toString();
    time = Math.max(fs.statSync(name).atimeMs, time);
    addDependency(name, md);
  }
  if (config.footer) {
    let name = absolute(dir, config.footer);
    config.footer = fs.readFileSync(name).toString();
    time = Math.max(fs.statSync(name).atimeMs, time);
    addDependency(name, md);
  }
  if (!config.customs) {
    config.customs = [];
  }
  if (config.customs.length > 0) {
    config.customs = config.customs.map((custom) => {
      const res = absolute(dir, custom);
      addDependency(res, md);
      time = Math.max(fs.statSync(res).atimeMs, time);
      return fs.readFileSync(res).toString();
    });
  }
  if (config.styles && config.styles.length > 0) {
    config.styles = (config.styles as string[]).map((style) => {
      if (style.endsWith(".scss")) {
        const scss = path.resolve(dir, style);
        const css = relative("src", mvext(scss, ".css"), distPath);
        time = Math.max(fs.statSync(scss).atimeMs, time);
        return clientAbsolute(path.resolve(distName), path.resolve(css));
      } else {
        return style;
      }
    });
  }
  const dist = relative("src", md, distPath);
  let html: string;
  if (dist.endsWith("/index.md")) {
    html = mvext(dist, ".html");
  } else {
    html = mvext(dist, "/index.html");
  }
  if (!fs.existsSync(html) || fs.statSync(html).atimeMs < time) {
    let d = path.dirname(html);
    if (!fs.existsSync(d)) {
      fs.mkdirSync(d, { recursive: true });
    }
    const content = skmd(fs.readFileSync(md).toString(), config);
    fs.writeFileSync(html, content);
    log("'" + html + "' updated");
    version = Date.now();
  }
};

const manageScss = (scss: string, css: string) => {
  let d = path.dirname(css);
  if (!fs.existsSync(d)) {
    fs.mkdirSync(d, { recursive: true });
  }
  try {
    let result = sass.compile(scss);
    result.loadedUrls.forEach((f) => {
      let abs = absolute(f.pathname);
      if (abs != scss) addDependency(abs, scss);
    });
    fs.writeFile(css, result.css, function (err) {
      if (err) {
        console.error(["manageScss[0]", scss, css, err]);
      }
    });
    log("'" + css + "' updated");
    version = Date.now();
  } catch (e) {
    console.error(e.message);
  }
  const deps = dependencies.get(absolute(scss));
  if (deps) {
    deps.forEach((f) => {
      if (f.endsWith(".scss")) {
        const css = relative("src", mvext(f, ".css"), distPath);
        manageScss(f, css);
      }
    });
  }
};

const isAsset = (f: string) => {
  return path.resolve(f).startsWith(path.resolve("src/assets") + "/");
};

let docsTimeout;
const onDocs = (f: string) => {
  if (docsTimeout) {
    clearTimeout(docsTimeout);
  }
  docsTimeout = setTimeout(onDocs2, 10, f);
};

const onDocs2 = (f: string) => {
  exec("mkdocs build", (error, stdout, stderr) => {
    if (error) {
      console.log(`error: ${error.message}`);
      return;
    }
    if (stdout) {
      console.log(`stdout: ${stdout}`);
    }
    if (stderr) {
      console.log(`stderr: ${stderr}`);
    }
    allfiles.forEach(onChange2);
    loaded = true;
  });
};

const onChange = (f: string) => {
  setTimeout(onChange2, 10, f);
};

var loaded: boolean = false;

const onAdd = (f: string) => {
  if (loaded) {
    onChange(f);
  } else {
    const ext = path.extname(f);
    if (ext == ".md") {
      allfiles.add(f);
    } else if (ext == ".scss") {
      allfiles.add(f);
    } else if (isAsset(f)) {
      allfiles.add(f);
    }
  }
};

const onChange2 = (f: string) => {
  const ext = path.extname(f);
  if (ext == ".md") {
    allfiles.add(f);
    manageMd(f);
  } else if (ext == ".json") {
    const md = mvext(f, ".md");
    if (fs.existsSync(md)) {
      manageMd(md);
    } else {
      const deps = dependencies.get(absolute(f));
      if (deps) {
        deps.forEach(manageMd);
      }
    }
  } else if (ext == ".scss") {
    allfiles.add(f);
    const css = relative("src", mvext(f, ".css"), distPath);
    manageScss(f, css);
  } else if (ext == ".html") {
    const deps = dependencies.get(absolute(f));
    if (deps) {
      deps.forEach(manageMd);
    }
  } else if (isAsset(f)) {
    allfiles.add(f);
    let target = relative("src", f, distPath);
    fs.cp(f, target, (err) => {
      if (err) {
        console.error(err);
      }
    });
  }
};

const onUnlink = (f: string) => {
  setTimeout(onUnlink2, 10, f);
};

const onUnlink2 = (f: string) => {
  const ext = path.extname(f);
  if (ext == ".md") {
    const conf = mvext(f, ".json");
    if (fs.existsSync(conf)) {
      fs.unlink(conf, (err) => {
        if (err) console.error(err);
      });
    }
    const dist = relative("src", f, distPath);
    const html = mvext(dist, ".html");
    if (fs.existsSync(html)) {
      fs.unlink(html, (err) => {
        if (err) console.error(err);
      });
    }
  } else if (ext == ".scss") {
    const css = relative("src", mvext(f, ".css"), distPath);
    if (fs.existsSync(css)) {
      fs.unlink(css, (err) => {
        if (err) console.error(err);
      });
    }
  }
};

const post = (
  response: http.ServerResponse,
  file: string,
  errorFile: string,
  contentType: string,
  check: (c: Buffer) => Buffer = (v) => v,
) => {
  fs.readFile(file, function (error, content) {
    if (error) {
      if (error.code == "ENOENT") {
        fs.readFile(errorFile, function (error, content) {
          if (error) {
            if (error.code == "ENOENT") {
              response.writeHead(404);
              response.end("Not found\n\n");
            }
          } else {
            response.writeHead(200, { "Content-Type": contentType });
            response.end(content, "utf-8");
          }
        });
      } else {
        response.writeHead(500);
        response.end("Internal error: " + error.code + " ..\n\n");
      }
    } else {
      response.writeHead(200, { "Content-Type": contentType });
      response.end(check(content), "utf-8");
    }
  });
};

if (fs.existsSync(docsPath)) {
  var watcher = chokidar.watch("file or dir", {
    ignored: /^\./,
    persistent: true,
  });
  watcher
    .on("add", onAdd)
    .on("change", onChange)
    .on("unlink", onUnlink)
    .on("error", function (error) {
      console.error("Error happened", error);
    });

  watcher.add(srcPath);

  var watcher2 = chokidar.watch("file or dir", {
    ignored: /^\./,
    persistent: true,
  });
  watcher2
    .on("add", onDocs)
    .on("change", onDocs)
    .on("error", function (error) {
      console.error("Error happened", error);
    });

  watcher2.add(docsPath);
} else {
  var watcher = chokidar.watch("file or dir", {
    ignored: /^\./,
    persistent: true,
  });
  watcher
    .on("add", onChange)
    .on("change", onChange)
    .on("unlink", onUnlink)
    .on("error", function (error) {
      console.error("Error happened", error);
    });

  watcher.add(srcPath);
}

const port = 5155;

const requestHandler = (
  request: http.IncomingMessage,
  response: http.ServerResponse,
) => {
  const error = path.join(distPath, "404.html");
  if (request.url == "/__version__/") {
    response.setHeader("Content-Type", "application/json");
    response.end(JSON.stringify({ version: version }));
  } else if (request.url!.startsWith("/assets/")) {
    const asset = distPath + request.url;
    post(response, asset, error, mime.lookup(asset));
  } else {
    let page: string;
    if (request.url?.endsWith("/")) {
      page = path.join(distPath + request.url, "index.html");
    } else {
      page = distPath + request.url;
    }
    post(response, page, error, "text/html", addCheckVersion);
  }
};

const server = http.createServer(requestHandler);

process.on("SIGINT", function () {
  server.close();
  process.exit();
});

process.stdin.on("data", (data) => {
  let d = data.toString().toLowerCase().trim();
  if (d == "q") {
    server.close();
    process.exit();
  } else {
    console.log("skmd");
    console.log("➜  Local:   http://localhost:" + port + "/");
    console.log("➜  q or ctrl+c to quit");
  }
});

server.listen(port, () => {
  console.timeEnd("skmd ready");
  console.log("➜  Local:   http://localhost:" + port + "/");
  console.log("➜  q or ctrl+c to quit");
});
