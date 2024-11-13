import postgres from "postgres";
import { runService } from "@skipruntime/server";
import { serviceWithInitialData } from "./dist/hackernews.service.js";

const sql = postgres("postgres://postgres:change_me@db:5432");
async function selectAll(table) {
  return (await sql`SELECT * FROM ${sql(table)}`).map((r) => [r.id, [r]]);
}

// Initial values.
const posts = await selectAll("posts");
const users = await selectAll("users");
const upvotes = await selectAll("upvotes");

runService(serviceWithInitialData(posts, users, upvotes));
