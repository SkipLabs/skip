import config from "@skiplabs/eslint-config";

export default [
  ...config,
  {
    files: ["**/*.js"],
    languageOptions: {
      globals: {
        process: "readonly",
        console: "readonly",
      },
    },
  },
];
