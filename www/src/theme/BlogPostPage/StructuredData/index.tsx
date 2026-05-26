import React, { type ReactNode } from "react";
import Head from "@docusaurus/Head";
import { useBlogPostStructuredData } from "@docusaurus/plugin-content-blog/client";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";

/**
 * Overrides the default blog post structured data so that, on top of the
 * BlogPosting JSON-LD Docusaurus already emits, we add:
 *
 *  - a `publisher` Organization (with logo) — required by Google's Article
 *    rich-result spec and not emitted by Docusaurus by default;
 *  - `sameAs` on each author, mirroring the author `url` (schema.org's
 *    preferred property for linking to a person's canonical profile);
 *  - an `article:modified_time` meta tag whenever a `dateModified` is known
 *    (populated from `lastUpdatedAt`, i.e. git or `last_update` front matter).
 *
 * Everything else is reused verbatim from the native structured data, so this
 * stays in sync with Docusaurus across upgrades.
 */

type Author = {
  url?: string;
  sameAs?: string | string[];
  [key: string]: unknown;
};

type StructuredData = {
  author?: Author | Author[];
  dateModified?: string;
  [key: string]: unknown;
};

function withSameAs(author: Author): Author {
  if (author?.url && !author.sameAs) {
    return { ...author, sameAs: [author.url] };
  }
  return author;
}

export default function BlogPostStructuredData(): ReactNode {
  const { siteConfig } = useDocusaurusContext();
  const data = useBlogPostStructuredData() as StructuredData;

  const siteUrl = siteConfig.url.replace(/\/$/, "");

  const publisher = {
    "@type": "Organization",
    name: "SkipLabs",
    url: siteUrl,
    logo: {
      "@type": "ImageObject",
      url: `${siteUrl}/img/skip.png`,
    },
  };

  const author = Array.isArray(data.author)
    ? data.author.map(withSameAs)
    : data.author
      ? withSameAs(data.author)
      : undefined;

  const structuredData = {
    ...data,
    ...(author ? { author } : {}),
    publisher,
  };

  return (
    <Head>
      {data.dateModified && (
        <meta property="article:modified_time" content={data.dateModified} />
      )}
      <script type="application/ld+json">
        {JSON.stringify(structuredData)}
      </script>
    </Head>
  );
}
