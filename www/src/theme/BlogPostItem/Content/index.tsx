import React, { type ReactNode } from "react";
import Content from "@theme-original/BlogPostItem/Content";
import type ContentType from "@theme/BlogPostItem/Content";
import type { WrapperProps } from "@docusaurus/types";
import { useBlogPost } from "@docusaurus/plugin-content-blog/client";
import Tldr from "@site/src/components/blog/Tldr";
import SeriesNav from "@site/src/components/blog/SeriesNav";
import { findSeriesForSlug } from "@site/src/components/blog/series";

type Props = WrapperProps<typeof ContentType>;

/**
 * Wraps the blog post body to render, at the top of the full post page only,
 * an optional TL;DR callout (from the `tldr` front matter) and a series
 * navigation block (when the post belongs to a defined series). Both are
 * skipped on the blog list page, where Content renders truncated excerpts.
 */
export default function ContentWrapper(props: Props): ReactNode {
  const { frontMatter, isBlogPostPage } = useBlogPost();
  // `tldr` is a custom front matter field (Docusaurus preserves unknown keys).
  const { slug, tldr } = frontMatter as typeof frontMatter & {
    slug?: string;
    tldr?: string;
  };
  const series = findSeriesForSlug(slug);

  return (
    <>
      {isBlogPostPage && tldr && <Tldr>{tldr}</Tldr>}
      {isBlogPostPage && series && (
        <SeriesNav series={series} currentSlug={slug} />
      )}
      <Content {...props} />
    </>
  );
}
