import config from "@skiplabs/eslint-config";
import tseslint from "typescript-eslint";

export default [
  ...config,
  {
    files: ["src/addon.bun.spec.ts"],
    ...tseslint.configs.disableTypeChecked,
  },
];
