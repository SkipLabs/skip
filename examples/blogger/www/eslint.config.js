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
  // @typescript-eslint/parser.
  {
    files: ["**/*.vue"],
    languageOptions: {
      parser: vueParser,
      parserOptions: {
        parser: tseslint.parser,
        extraFileExtensions: [".vue"],
      },
    },
  },
  // Type-checked rules can't run on .vue: vue-eslint-parser doesn't forward
  // type information to typescript-eslint. Kept as its own config object so its
  // languageOptions merge with (rather than overwrite) the parser block above.
  {
    files: ["**/*.vue"],
    ...tseslint.configs.disableTypeChecked,
  },
  // Single-word names are intentional for these page/route components.
  {
    files: ["**/*.vue"],
    rules: {
      "vue/multi-word-component-names": "off",
    },
  },
];
