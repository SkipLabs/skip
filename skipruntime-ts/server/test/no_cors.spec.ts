import { runService, type SkipServer } from "../src/server.js";
import type { EagerCollection, Json, Resource } from "@skipruntime/core";
import { InputDefinition } from "@skipruntime/core";
import { expect } from "chai";

type Post = {
  readonly author_id: number;
  readonly title: string;
  readonly url: string;
  readonly body: string;
  readonly date: number;
  readonly [key: string]: Json | null;
};

type PostsResourceInputs = {
  readonly posts: EagerCollection<number, Post>;
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
        inputs: { posts: new InputDefinition<number, Post>() },
        resources: { posts: PostsResource },
        createGraph: (ic) => ic,
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
