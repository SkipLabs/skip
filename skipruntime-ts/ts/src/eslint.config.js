// @ts-check

import eslint from "@eslint/js";
import tseslint from "typescript-eslint";
import stylisticJs from "@stylistic/eslint-plugin-js";
import jsdoc from "eslint-plugin-jsdoc";

export default tseslint.config(
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
        projectService: true,
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
      "prefer-spread": "warn",
      "@stylistic/js/lines-between-class-members": [
        "error",
        { enforce: [{ prev: "*", next: "method", blankLine: "always" }] },
      ],
      "@typescript-eslint/consistent-indexed-object-style": "off",
      "@typescript-eslint/consistent-type-definitions": "warn",
      "@typescript-eslint/no-confusing-void-expression": "error",
      "@typescript-eslint/no-empty-object-type": [
        "error",
        { allowInterfaces: "with-single-extends" },
      ],
      "@typescript-eslint/no-explicit-any": "warn",
      "@typescript-eslint/no-inferrable-types": "off",
      "@typescript-eslint/no-non-null-assertion": "warn",
      "@typescript-eslint/no-unnecessary-condition": "error",
      "@typescript-eslint/no-unnecessary-type-arguments": "warn",
      "@typescript-eslint/no-unnecessary-type-parameters": "warn",
      "@typescript-eslint/no-unsafe-assignment": "warn",
      "@typescript-eslint/no-unsafe-member-access": "warn",
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
      "@typescript-eslint/restrict-plus-operands": "error",
      "@typescript-eslint/restrict-template-expressions": "warn",
      "@typescript-eslint/use-unknown-in-catch-callback-variable": "error",
      "jsdoc/no-types": "warn",
      "jsdoc/require-description": "warn",
      "jsdoc/require-jsdoc": ["warn", { publicOnly: true }],
      "jsdoc/require-param": "warn",
      "jsdoc/require-param-description": "warn",
      "jsdoc/tag-lines": "off",
    },
  },
  { files: ["**/*.js"], ...tseslint.configs.disableTypeChecked },
);
