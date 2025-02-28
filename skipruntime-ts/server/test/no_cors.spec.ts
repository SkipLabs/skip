import { runService, type SkipServer } from "../src/server.js";
import type { Context, EagerCollection, Resource } from "@skipruntime/core";
import { expect } from "chai";

type Post = {
  author_id: number;
  title: string;
  url: string;
  body: string;
  date: number;
};

type PostsResourceInputs = {
  posts: EagerCollection<number, Post>;
};

class PostsResource implements Resource<PostsResourceInputs> {
  instantiate(collections: PostsResourceInputs): EagerCollection<number, Post> {
    return collections.posts;
  }
}

describe("runService({ no_cors: true })", function () {
  let service: SkipServer;
  before(async function () {
    service = await runService(
      {
        initialData: { posts: [] },
        resources: { posts: PostsResource },
        createGraph(
          inputs: { posts: EagerCollection<number, Post> },
          _context: Context,
        ): PostsResourceInputs {
          return {
            posts: inputs.posts,
          };
        },
      },
      {
        control_port: 8081,
        streaming_port: 8080,
        no_cors: true,
      },
    );
  });
  after(async function () {
    await service.close();
  });

  try {
    it("should set Access-Control-Allow-Credentials", async function () {
      const uuid = await (
        await fetch("http://localhost:8081/v1/streams/posts", {
          method: "POST",
        })
      ).text();
      const resp = await fetch(`http://localhost:8080/v1/streams/${uuid}`, {
        headers: {
          Accept: "text/event-stream",
        },
      });
      expect(resp.headers.get("Access-Control-Allow-Credentials")).to.equal(
        "true",
      );
    });

    it("should set Access-Control-Allow-Origin", async function () {
      const uuid = await (
        await fetch("http://localhost:8081/v1/streams/posts", {
          method: "POST",
        })
      ).text();
      const resp = await fetch(`http://localhost:8080/v1/streams/${uuid}`, {
        headers: {
          Accept: "text/event-stream",
        },
      });
      expect(resp.headers.get("Access-Control-Allow-Origin")).to.equal("*");
    });

    it("should respond to preflight requests", async function () {
      const resp = await fetch(`http://localhost:8080/v1/streams`, {
        method: "OPTIONS",
      });
      expect(resp.headers.get("Access-Control-Allow-Origin")).to.equal("*");
    });
  } catch (e) {
    console.log(e);
  }
});
