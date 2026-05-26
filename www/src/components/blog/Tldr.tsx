import React, { type ReactNode } from "react";
import styles from "./callouts.module.css";

/**
 * A short, self-contained thesis rendered at the top of a post, sourced from
 * the optional `tldr` front matter field. Gives readers (and LLMs) one or two
 * quotable sentences stating the post's core claim.
 */
export default function Tldr({ children }: { children: ReactNode }): ReactNode {
  return (
    <aside className={styles.tldr} aria-label="Summary">
      <p className={styles.tldrLabel}>TL;DR</p>
      <p className={styles.tldrBody}>{children}</p>
    </aside>
  );
}
