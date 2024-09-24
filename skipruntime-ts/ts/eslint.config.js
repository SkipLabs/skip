// @ts-check

import eslint from "@eslint/js";
import tseslint from "typescript-eslint";
import stylisticJs from "@stylistic/eslint-plugin-js";
import jsdoc from "eslint-plugin-jsdoc";

export default tseslint.config(
  {
    ignores: ["**/dev/*", "**/dist/*", "**/tests/*", "tsconfig.json"],
  },
  eslint.configs.recommended,
  jsdoc.configs["flat/recommended-typescript-error"],
  ...tseslint.configs.strictTypeChecked,
  ...tseslint.configs.stylisticTypeChecked,
  {
    linterOptions: {
      reportUnusedDisableDirectives: "error",
    },
    languageOptions: {
      parserOptions: {
        project: "./tsconfig-eslint.json",
        tsconfigRootDir: import.meta.dirname,
      },
    },
    plugins: {
      "@stylistic/js": stylisticJs,
      jsdoc,
    },
    rules: {
      "no-unused-vars": [
        "error",
        {
          args: "none",
          caughtErrors: "all",
          ignoreRestSiblings: true,
          argsIgnorePattern: "^_",
          caughtErrorsIgnorePattern: "^_",
          destructuredArrayIgnorePattern: "^_",
          varsIgnorePattern: "^_",
          reportUsedIgnorePattern: true,
        },
      ],
      "prefer-spread": "off",
      "@stylistic/js/lines-between-class-members": [
        "error",
        { enforce: [{ prev: "*", next: "method", blankLine: "always" }] },
      ],
      "@typescript-eslint/consistent-indexed-object-style": "off",
      "@typescript-eslint/consistent-type-definitions": "off",
      "@typescript-eslint/no-confusing-void-expression": "off",
      "@typescript-eslint/no-empty-object-type": [
        "error",
        { allowInterfaces: "with-single-extends" },
      ],
      "@typescript-eslint/no-explicit-any": "off",
      "@typescript-eslint/no-inferrable-types": "off",
      "@typescript-eslint/no-non-null-assertion": "off",
      "@typescript-eslint/no-unnecessary-condition": "error",
      "@typescript-eslint/no-unnecessary-type-arguments": "off",
      "@typescript-eslint/no-unnecessary-type-parameters": "off",
      "@typescript-eslint/no-unsafe-assignment": "off",
      "@typescript-eslint/no-unsafe-member-access": "off",
      "@typescript-eslint/no-unused-vars": [
        "error",
        {
          args: "none",
          caughtErrors: "all",
          ignoreRestSiblings: true,
          argsIgnorePattern: "^_",
          caughtErrorsIgnorePattern: "^_",
          destructuredArrayIgnorePattern: "^_",
          varsIgnorePattern: "^_",
          reportUsedIgnorePattern: true,
        },
      ],
      "@typescript-eslint/prefer-string-starts-ends-with": [
        "error",
        { allowSingleElementEquality: "always" },
      ],
      "@typescript-eslint/restrict-plus-operands": "error",
      "@typescript-eslint/restrict-template-expressions": "off",
      "@typescript-eslint/use-unknown-in-catch-callback-variable": "error",
      "jsdoc/no-types": "off",
      "jsdoc/require-description": "off",
      "jsdoc/require-jsdoc": ["off", { publicOnly: true }],
      "jsdoc/require-param": "off",
      "jsdoc/require-param-description": "off",
      "jsdoc/tag-lines": "off",
    },
  },
  { files: ["**/*.js"], ...tseslint.configs.disableTypeChecked },
);
