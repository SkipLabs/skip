import { themes as prismThemes } from "prism-react-renderer";
import type { Config } from "@docusaurus/types";
import type * as Preset from "@docusaurus/preset-classic";

const config: Config = {
  title: "Skip",
  tagline: "A generic framework for reactive programming",
  favicon: "img/favicon.svg",

  // Set the production url of your site here
  url: "https://skiplabs.io/",
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: "/",

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: "skiplabs", // Usually your GitHub org/user name.
  projectName: "skip", // Usually your repo name.

  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: "en",
    locales: ["en"],
  },

  presets: [
    [
      "classic",
      {
        docs: {
          sidebarPath: "./sidebars.ts",
          // Remove this to remove the "edit this page" links.
          // editUrl: "",
        },
        theme: {
          customCss: "./src/css/custom.css",
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    // Replace with your project's social card
    image: "img/skip.png",
    metadata: [{ name: "twitter:card", content: "summary" }],
    navbar: {
      title: "",
      logo: {
        alt: "Skip Logo",
        src: "img/logo.svg",
        href: "https://skiplabs.io/",
      },
      items: [
        {
          href: "https://github.com/SkipLabs/skip",
          position: "right",
          className: "header-github-link",
          "aria-label": "GitHub repository",
        },
        {
          href: "https://www.linkedin.com/company/skiplabs/",
          position: "right",
          className: "header-linkedin-link",
          "aria-label": "LinkedIn",
        },
        {
          href: "https://discord.gg/4dMEBA46mE",
          position: "right",
          className: "header-discord-link",
          "aria-label": "Chat (Discord)",
        },
      ],
    },
    footer: {
      style: "dark",
      copyright: `Copyright © ${new Date().getFullYear()} SkipLabs, Inc.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,

  plugins: [
    [
      "docusaurus-plugin-typedoc",
      {
        id: "core",
        out: "docs/api/core",
        entryPoints: ["../skipruntime-ts/core/src/api.ts"],
        tsconfig: "../skipruntime-ts/core/tsconfig.json",
        readme: "none",
        indexFormat: "table",
        disableSources: true,
        groupOrder: ["Type Aliases", "Interfaces", "Classes", "functions"],
        sidebar: { pretty: true },
        textContentMappings: {
          "title.indexPage": "@skipruntime/core",
          "title.memberPage": "{name}",
        },
        parametersFormat: "table",
        enumMembersFormat: "table",
        useCodeBlocks: true,
        useHTMLEncodedBrackets: true,
      },
    ],
    [
      "docusaurus-plugin-typedoc",
      {
        id: "server",
        out: "docs/api/server",
        entryPoints: ["../skipruntime-ts/server/src/server.ts"],
        tsconfig: "../skipruntime-ts/server/tsconfig.json",
        readme: "none",
        indexFormat: "table",
        disableSources: true,
        groupOrder: ["Type Aliases", "Interfaces", "Classes", "functions"],
        sidebar: { pretty: true },
        textContentMappings: {
          "title.indexPage": "@skipruntime/server",
          "title.memberPage": "{name}",
        },
        parametersFormat: "table",
        enumMembersFormat: "table",
        useCodeBlocks: true,
        useHTMLEncodedBrackets: true,
      },
    ],
    [
      "docusaurus-plugin-typedoc",
      {
        id: "helpers",
        out: "docs/api/helpers",
        entryPoints: ["../skipruntime-ts/helpers/src/index.ts"],
        tsconfig: "../skipruntime-ts/helpers/tsconfig.json",
        readme: "none",
        indexFormat: "table",
        disableSources: true,
        groupOrder: ["Type Aliases", "Interfaces", "Classes", "functions"],
        sidebar: { pretty: true },
        textContentMappings: {
          "title.indexPage": "@skipruntime/helpers",
          "title.memberPage": "{name}",
        },
        parametersFormat: "table",
        enumMembersFormat: "table",
        useCodeBlocks: true,
        useHTMLEncodedBrackets: true,
      },
    ],
    [
      "docusaurus-plugin-typedoc",
      {
        id: "adapters/postgres",
        out: "docs/api/adapters/postgres",
        entryPoints: ["../skipruntime-ts/adapters/postgres/src/index.ts"],
        tsconfig: "../skipruntime-ts/adapters/postgres/tsconfig.json",
        readme: "none",
        indexFormat: "table",
        disableSources: true,
        groupOrder: ["Type Aliases", "Interfaces", "Classes", "functions"],
        sidebar: { pretty: true },
        textContentMappings: {
          "title.indexPage": "@skip-adapter/postgres",
          "title.memberPage": "{name}",
        },
        parametersFormat: "table",
        enumMembersFormat: "table",
        useCodeBlocks: true,
        useHTMLEncodedBrackets: true,
      },
    ],
    [
      "docusaurus-plugin-typedoc",
      {
        id: "adapters/kafka",
        out: "docs/api/adapters/kafka",
        entryPoints: ["../skipruntime-ts/adapters/kafka/src/index.ts"],
        tsconfig: "../skipruntime-ts/adapters/kafka/tsconfig.json",
        readme: "none",
        indexFormat: "table",
        disableSources: true,
        groupOrder: ["Type Aliases", "Interfaces", "Classes", "functions"],
        sidebar: { pretty: true },
        textContentMappings: {
          "title.indexPage": "@skip-adapter/kafka",
          "title.memberPage": "{name}",
        },
        parametersFormat: "table",
        enumMembersFormat: "table",
        useCodeBlocks: true,
        useHTMLEncodedBrackets: true,
      },
    ],
  ],
};

export default config;
