import { expect } from "@playwright/test";

export const tests = (main: (args: Array<string>, stdin: string) => string) => {
  let testNames = main(["--list"], "");
  return testNames
    .trim()
    .split("\n")
    .map((testName) => {
      return {
        name: testName,
        fun: (
          testName: string,
          main: (args: Array<string>, stdin: string) => string,
        ) => {
          return main(["--strict", "--json", testName], "");
        },
        check: (res) => {
          let lines = res.trim().split("\n");
          expect("Line size: " + lines.length).toEqual("Line size: 1");
          let result = JSON.parse(lines[0]);
          expect(result.result).toEqual("success");
        },
      };
    });
};
