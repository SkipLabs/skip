import * as fs from "fs";
import * as path from "path";
import * as http from "http";
import * as mime from "mime-types";
import chalk from "chalk";

console.time("server ready");

const post = (response, file, errorFile, contentType) => {
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
      response.end(content, "utf-8");
    }
  });
};

const port = 5154;

const distPath = "./dist";
const distRoot = path.resolve(distPath);

// Endpoints the bundled-app test page calls back to report its result.
// These are matched by an exact dictionary lookup (see requestHandler)
// rather than by comparing `request.url` against string literals, so
// user-controlled request data never flows into the condition that decides
// whether to terminate the process (CodeQL js/user-controlled-bypass).
const apiResults = {
  "/api/succeed": {
    log: chalk.green("[OK]") + " Bundled SKDB successfully started.",
    body: "[OK] Bundled SKDB successfully started.",
  },
  "/api/loadfailed": {
    log: chalk.red("[FAILED]") + " Unable to load Bundled SKDB.",
    body: "[FAILED] Unable to load Bundled SKDB.",
  },
  "/api/creationfailed": {
    log: chalk.red("[FAILED]") + " Unable to use Bundled SKDB.",
    body: "[FAILED] Unable to use Bundled SKDB.",
  },
};

const requestHandler = (request, response) => {
  const error = path.join(distRoot, "404.html");
  const rawPath = request.url ? request.url.split("?")[0] : "/";

  const result = Object.prototype.hasOwnProperty.call(apiResults, rawPath)
    ? apiResults[rawPath]
    : null;
  if (result) {
    response.setHeader("Content-Type", "text/plain");
    console.log(result.log);
    // Exit once the response has been flushed so the controlling
    // `node server.js` step returns.
    response.end(result.body, () => process.exit());
    return;
  }

  const decodedPath = decodeURIComponent(rawPath);
  let page = path.resolve(distRoot, "." + decodedPath);
  if (decodedPath.endsWith("/")) {
    page = path.join(page, "index.html");
  }

  const rel = path.relative(distRoot, page);
  if (rel.startsWith("..") || path.isAbsolute(rel)) {
    response.writeHead(403);
    response.end("Forbidden\n\n");
    return;
  }

  post(response, page, error, mime.lookup(page));
};

const server = http.createServer(requestHandler);

server.listen(port, () => {
  console.timeEnd("server ready");
  console.log("➜  Local:   http://localhost:" + port + "/");
  console.log(chalk.blue("Open the link in browser to continue the chek."));
});
