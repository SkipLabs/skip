import sqlite3 from "sqlite3";
import { runService } from "@skipruntime/server";
import serviceWithInitialData from "./dist/hackernews.service.js";

async function selectAll(db, table) {
  return new Promise((resolve, reject) => {
    db.all(`SELECT * FROM ${table}`, (err, data) => {
      if (err) {
        reject(err);
      } else {
        resolve(data.map((v) => [v.id, [v]]));
      }
    });
  });
}

const db = new sqlite3.Database("../database.db");

// Initial values.
const posts = await selectAll(db, "posts");
const users = await selectAll(db, "users");
const upvotes = await selectAll(db, "upvotes");

// Spawn a local HTTP server to support reading/writing and creating
// reactive requests.
runService(serviceWithInitialData(posts, users, upvotes), 8080);
