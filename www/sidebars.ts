import type { SidebarsConfig } from "@docusaurus/plugin-content-docs";

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */
const sidebars: SidebarsConfig = {
  docsSidebar: [
    "introduction",
    "getting_started",
    "functions",
    "resources",
    "externals",
    "client",
    "deploying",
    "glossary",
    "community",
    {
      type: "category",
      label: "@skipruntime/core",
      link: {
        type: "doc",
        id: "api/core/index",
      },
      items: require("./docs/api/core/typedoc-sidebar.cjs"),
    },
    {
      type: "category",
      label: "@skipruntime/server",
      link: {
        type: "doc",
        id: "api/server/index",
      },
      items: require("./docs/api/server/typedoc-sidebar.cjs"),
    },
    {
      type: "category",
      label: "@skipruntime/helpers",
      link: {
        type: "doc",
        id: "api/helpers/index",
      },
      items: require("./docs/api/helpers/typedoc-sidebar.cjs"),
    },
    {
      type: "category",
      label: "@skip-adapter",
      items: [
        {
          type: "category",
          label: "@skip-adapter/postgres",
          link: {
            type: "doc",
            id: "api/adapters/postgres/index",
          },
          items: require("./docs/api/adapters/postgres/typedoc-sidebar.cjs"),
        },
        {
          type: "category",
          label: "@skip-adapter/kafka",
          link: {
            type: "doc",
            id: "api/adapters/kafka/index",
          },
          items: require("./docs/api/adapters/kafka/typedoc-sidebar.cjs"),
        },
      ],
    },
  ],
};

export default sidebars;
