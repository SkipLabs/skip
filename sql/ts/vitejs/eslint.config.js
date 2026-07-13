import js from "@eslint/js";
import tseslint from "typescript-eslint";
import globals from "globals";

// Flat config (ESLint v9+ default; v10 dropped .eslintrc support entirely).
// Mirrors the previous .eslintrc.cjs: eslint:recommended + @typescript-eslint
// recommended over the browser-side application sources. Build tooling
// (vite.config.ts, server.js) runs under Node and is intentionally excluded.
export default tseslint.config(
  { ignores: ["dist", "server.js"] },
  {
    files: ["src/**/*.{ts,tsx}"],
    extends: [js.configs.recommended, ...tseslint.configs.recommended],
    linterOptions: {
      reportUnusedDisableDirectives: "error",
    },
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
    },
    rules: {
      "@typescript-eslint/no-unused-vars": [
        "error",
        {
          argsIgnorePattern: "^_",
          varsIgnorePattern: "^_",
          caughtErrorsIgnorePattern: "^_",
        },
      ],
    },
  },
);
