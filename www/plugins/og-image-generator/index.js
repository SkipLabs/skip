// Build-time Open Graph card generator.
//
// Generates a unique 1200x630 social card per blog post (Skip branding + post
// title + author) into <outDir>/img/og/<slug>.png during postBuild. Each post
// points its `image` front matter at /img/og/<slug>.png, so the generated card
// becomes the og:image / twitter:image and the JSON-LD image for that post.
//
// satori (HTML/CSS -> SVG) and @resvg/resvg-js (SVG -> PNG) are build-only
// dependencies; nothing here ships to the browser.

const fs = require("fs");
const path = require("path");
const matter = require("gray-matter");
const yaml = require("js-yaml");

const WIDTH = 1200;
const HEIGHT = 630;

const BRAND_RED = "#d62f0d";
const BG = "#0f1115";
const TITLE_COLOR = "#ffffff";
const MUTED_COLOR = "#9aa0a6";

function loadAuthors(blogDir) {
  const authorsPath = path.join(blogDir, "authors.yml");
  try {
    return yaml.load(fs.readFileSync(authorsPath, "utf8")) || {};
  } catch {
    return {};
  }
}

// Resolve the `authors` front matter (a key, list of keys, or inline object)
// into a display string, using authors.yml for keyed authors.
function resolveAuthorName(authors, authorsMap) {
  const one = (a) => {
    if (!a) return undefined;
    if (typeof a === "string") return authorsMap[a]?.name ?? a;
    if (typeof a === "object") return a.name ?? authorsMap[a.key]?.name;
    return undefined;
  };
  const list = Array.isArray(authors) ? authors : [authors];
  const names = list.map(one).filter(Boolean);
  return names.join(", ");
}

// satori accepts a React-element-like tree; build it with plain objects so the
// plugin needs no JSX transform.
function el(type, style, children) {
  return {
    type,
    props: { style, ...(children !== undefined ? { children } : {}) },
  };
}

function card({ title, author }) {
  return el(
    "div",
    {
      display: "flex",
      flexDirection: "column",
      justifyContent: "space-between",
      width: "100%",
      height: "100%",
      backgroundColor: BG,
      padding: 72,
      fontFamily: "Quicksand",
    },
    [
      // Brand header
      el("div", { display: "flex", alignItems: "center" }, [
        el("div", {
          width: 32,
          height: 32,
          backgroundColor: BRAND_RED,
          borderRadius: 8,
          marginRight: 20,
        }),
        el(
          "div",
          {
            display: "flex",
            fontFamily: "Space Mono",
            fontSize: 28,
            letterSpacing: 4,
            color: BRAND_RED,
          },
          "SKIPLABS BLOG",
        ),
      ]),
      // Title
      el(
        "div",
        {
          display: "flex",
          fontWeight: 700,
          fontSize: 64,
          lineHeight: 1.12,
          color: TITLE_COLOR,
        },
        title,
      ),
      // Footer / author
      el(
        "div",
        {
          display: "flex",
          fontWeight: 500,
          fontSize: 30,
          color: MUTED_COLOR,
        },
        author ? `By ${author}` : "skiplabs.io",
      ),
    ],
  );
}

module.exports = function ogImageGenerator(context) {
  const { siteDir } = context;
  const blogDir = path.join(siteDir, "blog");
  const fontsDir = path.join(siteDir, "static", "fonts");

  return {
    name: "og-image-generator",

    async postBuild({ outDir }) {
      const satori = (await import("satori")).default;
      const { Resvg } = require("@resvg/resvg-js");

      const fonts = [
        {
          name: "Quicksand",
          data: fs.readFileSync(path.join(fontsDir, "Quicksand-Bold.ttf")),
          weight: 700,
          style: "normal",
        },
        {
          name: "Quicksand",
          data: fs.readFileSync(path.join(fontsDir, "Quicksand-Medium.ttf")),
          weight: 500,
          style: "normal",
        },
        {
          name: "Space Mono",
          data: fs.readFileSync(path.join(fontsDir, "SpaceMono-Regular.ttf")),
          weight: 400,
          style: "normal",
        },
      ];

      const authorsMap = loadAuthors(blogDir);
      const ogDir = path.join(outDir, "img", "og");
      fs.mkdirSync(ogDir, { recursive: true });

      const files = fs
        .readdirSync(blogDir)
        .filter((f) => f.endsWith(".md") || f.endsWith(".mdx"));

      let generated = 0;
      const skipped = [];

      for (const file of files) {
        try {
          const { data } = matter(
            fs.readFileSync(path.join(blogDir, file), "utf8"),
          );
          if (data.draft || !data.title) {
            skipped.push(file);
            continue;
          }
          const slug = data.slug || file.replace(/\.mdx?$/, "");
          const author = resolveAuthorName(data.authors, authorsMap);

          const svg = await satori(card({ title: data.title, author }), {
            width: WIDTH,
            height: HEIGHT,
            fonts,
          });
          const png = new Resvg(svg, {
            fitTo: { mode: "width", value: WIDTH },
          })
            .render()
            .asPng();
          fs.writeFileSync(path.join(ogDir, `${slug}.png`), png);
          generated += 1;
        } catch (err) {
          skipped.push(`${file} (${err.message})`);
        }
      }

      console.log(
        `[og-image-generator] generated ${generated} card(s) in img/og/` +
          (skipped.length ? `; skipped: ${skipped.join(", ")}` : ""),
      );
    },
  };
};
