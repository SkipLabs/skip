// Blog series definitions. Membership is keyed on a post's `slug`, so adding a
// post to a series needs no per-post front matter — just list it here, in
// reading order. The series block is rendered automatically on each member
// post by the swizzled BlogPostItem/Content component.

export interface SeriesPost {
  /** The post's `slug` front matter value (the /blog/<slug> path segment). */
  slug: string;
  /** Exact post title, used as the link's anchor text. */
  title: string;
}

export interface Series {
  id: string;
  /**
   * Human-facing label for the series, rendered as
   * "Part of a series on {title}". Provisional wording — adjust freely.
   */
  title: string;
  posts: SeriesPost[];
}

export const BLOG_SERIES: Series[] = [
  {
    id: "verified-codegen",
    title: "verified AI code generation",
    posts: [
      {
        slug: "codegen_as_compiler",
        title: "Treat Agent Output Like Compiler Output",
      },
      {
        slug: "future_of_tools_for_ai",
        title: "Code Was Never for Machines — Until Now",
      },
      {
        slug: "notes_from_the_comments",
        title: "The apparatus, not the artifact",
      },
      {
        slug: "closed_loop_coding_agent",
        title: "What a Closed-Loop Coding Agent Actually Is",
      },
    ],
  },
];

export function findSeriesForSlug(
  slug: string | undefined,
): Series | undefined {
  if (!slug) {
    return undefined;
  }
  return BLOG_SERIES.find((series) =>
    series.posts.some((post) => post.slug === slug),
  );
}
