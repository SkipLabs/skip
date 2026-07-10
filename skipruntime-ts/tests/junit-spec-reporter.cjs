"use strict";

// A self-contained mocha reporter (no external dependencies).
//
// It extends mocha's built-in `spec` reporter so the normal console output is
// preserved, and additionally writes a JUnit XML report in which every
// `<testcase>` carries a `file` attribute set to the *relative* spec-file path.
//
// CircleCI's "rerun failed tests" (`circleci tests run`) keys reruns on that
// `file` attribute and feeds it back to `xargs mocha <file>`, so it must be a
// runnable spec path matching what `circleci tests glob` produces. The stock
// mocha-junit-reporter only records `file` on `<testsuite>` and sets
// `<testcase classname>` to the test title, neither of which CircleCI can rerun
// on -- hence this reporter. The XML shape mirrors what sktest emits (see
// skiplang/sktest/src/reporter.sk).
//
// Output path (first non-empty wins): $MOCHA_FILE, then the `mochaFile`
// reporter option, then ./test-results.xml.

const fs = require("fs");
const path = require("path");
const Mocha = require("mocha");

const Spec = Mocha.reporters.Spec;
const { EVENT_TEST_PASS, EVENT_TEST_FAIL, EVENT_TEST_PENDING, EVENT_RUN_END } =
  Mocha.Runner.constants;

// Drop code points that are forbidden in XML 1.0 (every C0 control except tab,
// LF and CR) -- no escaping can legalize them, so a raw ESC (from ANSI-coloured
// assertion diffs), NUL, etc. in an error message/stack would otherwise make
// the whole report unparseable and break CircleCI's rerun tracking.
function stripInvalidXml(s) {
  // eslint-disable-next-line no-control-regex
  return String(s).replace(/[\u0000-\u0008\u000b\u000c\u000e-\u001f]/g, "");
}

function escapeAttr(s) {
  return stripInvalidXml(s)
    .replace(/&/g, "&amp;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&apos;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\r/g, "&#13;")
    .replace(/\n/g, "&#10;")
    .replace(/\t/g, "&#9;");
}

function escapeText(s) {
  return stripInvalidXml(s)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

// Full suite path minus the test's own title, e.g. "outer inner".
function suiteTitle(test) {
  return test.titlePath().slice(0, -1).join(" ");
}

// Spec-file path relative to cwd (the tests package dir), so it matches the
// `circleci tests glob` output and is runnable as `mocha <file>`.
function relFile(test) {
  const abs = test.file || (test.parent && test.parent.file) || "";
  return abs ? path.relative(process.cwd(), abs) : "";
}

function JUnitSpecReporter(runner, options) {
  // Keep mocha's default spec console output.
  Spec.call(this, runner, options);

  const results = [];
  const reporterOptions = (options && options.reporterOptions) || {};
  const outFile =
    process.env.MOCHA_FILE || reporterOptions.mochaFile || "test-results.xml";

  runner.on(EVENT_TEST_PASS, (test) => results.push({ test, state: "passed" }));
  runner.on(EVENT_TEST_FAIL, (test, err) =>
    results.push({ test, state: "failed", err }),
  );
  runner.on(EVENT_TEST_PENDING, (test) =>
    results.push({ test, state: "pending" }),
  );

  runner.on(EVENT_RUN_END, () => {
    // Group by spec file so each <testsuite> maps to one runnable file.
    const byFile = new Map();
    for (const r of results) {
      const file = relFile(r.test);
      if (!byFile.has(file)) byFile.set(file, []);
      byFile.get(file).push(r);
    }

    const totalTests = results.length;
    const totalFailures = results.filter((r) => r.state === "failed").length;
    const totalTime = results.reduce(
      (acc, r) => acc + (r.test.duration || 0) / 1000,
      0,
    );

    const lines = ['<?xml version="1.0" encoding="UTF-8"?>'];
    lines.push(
      `<testsuites name="Mocha Tests" tests="${totalTests}" failures="${totalFailures}" time="${totalTime}">`,
    );

    for (const [file, group] of byFile) {
      const failures = group.filter((r) => r.state === "failed").length;
      const skipped = group.filter((r) => r.state === "pending").length;
      const time = group.reduce(
        (acc, r) => acc + (r.test.duration || 0) / 1000,
        0,
      );
      lines.push(
        `  <testsuite name="${escapeAttr(file)}" file="${escapeAttr(file)}" tests="${group.length}" failures="${failures}" skipped="${skipped}" time="${time}">`,
      );

      for (const r of group) {
        const test = r.test;
        lines.push(
          `    <testcase name="${escapeAttr(test.title)}" classname="${escapeAttr(suiteTitle(test))}" file="${escapeAttr(file)}" time="${(test.duration || 0) / 1000}">`,
        );
        if (r.state === "failed") {
          const err = r.err || {};
          const message = err.message || String(err);
          lines.push(
            `      <failure message="${escapeAttr(message)}" type="${escapeAttr(err.name || "Error")}">${escapeText(err.stack || message)}</failure>`,
          );
        } else if (r.state === "pending") {
          lines.push("      <skipped/>");
        }
        lines.push("    </testcase>");
      }

      lines.push("  </testsuite>");
    }

    lines.push("</testsuites>");

    fs.mkdirSync(path.dirname(path.resolve(outFile)), { recursive: true });
    fs.writeFileSync(outFile, lines.join("\n") + "\n");
  });
}

// Preserve Spec's prototype so mocha treats this as a proper reporter.
JUnitSpecReporter.prototype = Object.create(Spec.prototype);
JUnitSpecReporter.prototype.constructor = JUnitSpecReporter;

module.exports = JUnitSpecReporter;
