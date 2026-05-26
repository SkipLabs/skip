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
  markdown: {
    hooks: {
      onBrokenMarkdownLinks: "warn",
    },
  },

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
        blog: {
          // Used as the schema.org Blog name (isPartOf) and the blog index title.
          blogTitle: "Skip Blog",
          // Emit freshness signals: a populated `lastUpdatedAt` drives the
          // BlogPosting `dateModified` (JSON-LD) and `article:modified_time`.
          // Defaults to the file's last git commit time; override per post
          // with a `last_update: { date: YYYY-MM-DD }` front matter field.
          showLastUpdateTime: true,
        },
        theme: {
          customCss: "./src/css/custom.css",
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    // Default social card, used as a fallback when a page has no `image`.
    // Blog posts override this with a per-post generated card (see the
    // og-image-generator plugin) via their `image` front matter.
    image: "img/skip.png",
    metadata: [
      // Large image previews on X/Twitter; LinkedIn uses og:image directly.
      { name: "twitter:card", content: "summary_large_image" },
      { property: "og:site_name", content: "SkipLabs" },
      // Site-wide default. Blog posts override this with `og:type=article`
      // (emitted later in the head by the blog theme, so it wins there).
      { property: "og:type", content: "website" },
    ],
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
