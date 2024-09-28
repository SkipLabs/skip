import { themes as prismThemes } from "prism-react-renderer";
import type { Config } from "@docusaurus/types";
import type * as Preset from "@docusaurus/preset-classic";

const config: Config = {
  title: "Skip",
  tagline: "A generic framework for reactive programming",
  favicon: "img/favicon.svg",

  // Set the production url of your site here
  url: "https://skiplabsdocscms-00-pbrstreetgang-00s-projects.vercel.app/",
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
        // blog: {
        //   showReadingTime: true,
        //   feedOptions: {
        //     type: ["rss", "atom"],
        //     xslt: true,
        //   },
        //   // Remove this to remove the "edit this page" links.
        //   // editUrl: "",
        //   // Useful options to enforce blogging best practices
        //   onInlineTags: "warn",
        //   onInlineAuthors: "warn",
        //   onUntruncatedBlogPosts: "warn",
        // },
        theme: {
          customCss: "./src/css/custom.css",
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    // Replace with your project's social card
    image: "img/skiplabs.svg",
    navbar: {
      title: "Skip",
      logo: {
        alt: "Skip Logo",
        src: "img/logo.svg",
      },
      items: [
        // {
        //   type: "docSidebar",
        //   sidebarId: "docsSidebar",
        //   position: "left",
        //   label: "Docs",
        // },
        // { to: "/docs/api", label: "API", position: "left" },
        // { to: "/blog", label: "Blog", position: "left" },
        { to: "?", label: "Search", position: "left" },
        { to: "/CHANGELOG", label: "Release notes", position: "left" },
        {
          label: "Chat (Discord)",
          href: "https://discord.gg/4dMEBA46mE",
          position: "right",
        },
        {
          label: "Star on GitHub",
          href: "https://github.com/SkipLabs/skdb",
          position: "right",
        },
        {
          label: "Follow on X",
          href: "https://x.com/skiplabs",
          position: "right",
        },
      ],
    },
    footer: {
      style: "dark",
      links: [
        {
          title: "Popular Topics",
          items: [
            {
              label: "Getting started",
              to: "/docs/getting_started",
            },
            {
              label: "Core concepts",
              to: "/docs/introduction#core-concepts",
            },
            {
              label: "Skip API",
              to: "/docs/api",
            },
            {
              label: "Resources",
              to: "/docs/resources",
            },
          ],
        },
        // {
        //   title: "Community",
        //   items: [
        //     {
        //       label: "GitHub",
        //       href: "https://github.com/SkipLabs/skdb",
        //     },
        //     // {
        //     //   label: "Stack Overflow",
        //     //   href: "https://stackoverflow.com/questions/tagged/skiplabs",
        //     // },
        //     {
        //       label: "Discord",
        //       href: "https://discord.gg/4dMEBA46mE",
        //     },
        //     // {
        //     //   label: "Twitter",
        //     //   href: "https://twitter.com/skiplabs",
        //     // },
        //   ],
        // },
        // {
        //   title: "More",
        //   items: [
        //     {
        //       label: "Blog",
        //       to: "/blog",
        //     },
        //     {
        //       label: "GitHub",
        //       href: "https://github.com/SkipLabs/skdb",
        //     },
        //   ],
        // },
      ],
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
        entryPoints: ["../skipruntime-ts/core/src/skip-runtime.ts"],
        tsconfig: "../skipruntime-ts/core/tsconfig.json",
        readme: "none",
        indexFormat: "table",
        disableSources: true,
        groupOrder: ["Classes", "Interfaces", "Type Aliases", "functions"],
        sidebar: { pretty: true },
        textContentMappings: {
          "title.indexPage": "Skip API",
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
