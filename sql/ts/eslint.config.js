import config from "eslint-config-skiplabs";

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
