import config from "@skiplabs/eslint-config";

export default [
  ...config,
  {
    ignores: ["src/addon.bun.spec.ts"],
  },
];
