import React, { type ReactNode } from "react";
import Link from "@docusaurus/Link";
import type { Series } from "./series";
import styles from "./callouts.module.css";

/**
 * Renders a "Part of a series" block listing every post in the series in
 * reading order, with the current post highlighted. Links use the post titles
 * as anchor text so the cluster is legible to crawlers and readers.
 */
export default function SeriesNav({
  series,
  currentSlug,
}: {
  series: Series;
  currentSlug?: string;
}): ReactNode {
  return (
    <nav className={styles.series} aria-label={`Series: ${series.title}`}>
      <p className={styles.seriesLabel}>Part of a series on {series.title}</p>
      <ol className={styles.seriesList}>
        {series.posts.map((post) => {
          const isCurrent = post.slug === currentSlug;
          return (
            <li
              key={post.slug}
              className={isCurrent ? styles.current : undefined}
            >
              {isCurrent ? (
                <span aria-current="true">{post.title}</span>
              ) : (
                <Link to={`/blog/${post.slug}`}>{post.title}</Link>
              )}
            </li>
          );
        })}
      </ol>
    </nav>
  );
}
