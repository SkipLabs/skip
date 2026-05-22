import config from "@skiplabs/eslint-config";
import pluginVue from "eslint-plugin-vue";
import tseslint from "typescript-eslint";
import vueParser from "vue-eslint-parser";
import globals from "globals";

export default [
  ...config,
  ...pluginVue.configs["flat/recommended"],
  {
    files: ["**/*.{ts,vue}"],
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
    },
  },
  // vue-eslint-parser parses .vue templates; delegate <script lang="ts"> to
  // @typescript-eslint/parser. Disable type-checked rules for .vue files since
  // vue-eslint-parser doesn't forward type info to typescript-eslint.
  {
    files: ["**/*.vue"],
    languageOptions: {
      parser: vueParser,
      parserOptions: {
        parser: tseslint.parser,
        extraFileExtensions: [".vue"],
      },
    },
    ...tseslint.configs.disableTypeChecked,
  },
];
