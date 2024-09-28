import config from "@skiplabs/eslint-config";

export default [
  {
    ignores: [
      "**/dev/*",
      "**/dist/*",
      "**/tests/*",
      "**/vitejs/*",
      "**/bun/*",
      "tsconfig.json",
    ],
  },
  ...config,
  {
    rules: {
      "@typescript-eslint/ban-ts-comment": "warn",
    },
  },
];
