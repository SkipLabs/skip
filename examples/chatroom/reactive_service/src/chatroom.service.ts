import type {
  Context,
  EagerCollection,
  Json,
  Mapper,
  Resource,
  SkipService,
  Values,
} from "@skipruntime/core";
import { Count } from "@skipruntime/helpers";

import { KafkaExternalService } from "./index.js";

type Message = {
  id: number;
  author: string;
  body: string;
  timestamp: number;
};

type Like = {
  id: number;
  message_id: number;
};

type LikedMessage = Message & { likes: number };

type ResourceInputs = {
  messages: EagerCollection<number, Message>;
  likesByMessage: EagerCollection<number, number>;
};

const kafka = new KafkaExternalService(
  {
    clientId: "skip-chatroom",
    brokers: [{ host: "kafka", port: 19092 }],
  },
  (msg) => {
    const value = JSON.parse(msg.value);
    return [[Number(value.id), value]];
  },
);

class GroupByMessage implements Mapper<number, Like, number, number> {
  mapEntry(id: number, likes: Values<Like>): Iterable<[number, number]> {
    return likes.toArray().map((like) => [like.message_id, id]);
  }
}

class JoinLikeCounts implements Mapper<number, Message, number, LikedMessage> {
  constructor(private likesByMessage: EagerCollection<number, number>) {}
  mapEntry(
    id: number,
    messages: Values<Message>,
  ): Iterable<[number, LikedMessage]> {
    let likes = 0;
    try {
      likes = this.likesByMessage.getUnique(id);
    } catch {}

    return messages
      .toArray()
      .map((msg) => [id, { ...(msg as Message), likes }]);
  }
}

class MessagesResource implements Resource<ResourceInputs> {
  private limit: number;

  constructor(param: Json) {
    if (typeof param == "number") this.limit = param;
    else this.limit = 25;
  }

  instantiate(
    collections: ResourceInputs,
  ): EagerCollection<number, LikedMessage> {
    return collections.messages
      .take(this.limit)
      .map(JoinLikeCounts, collections.likesByMessage);
  }
}

export const service: SkipService<{}, ResourceInputs> = {
  initialData: {},
  resources: { messages: MessagesResource },
  externalServices: { kafka },
  createGraph(_: {}, context: Context): ResourceInputs {
    const messages = context.useExternalResource<number, Message>({
      service: "kafka",
      identifier: "skip-chatroom-messages",
    });
    const likes = context.useExternalResource<number, Like>({
      service: "kafka",
      identifier: "skip-chatroom-likes",
    });
    const likesByMessage: EagerCollection<number, number> =
      likes.mapReduce(GroupByMessage)(Count);
    return {
      likesByMessage,
      messages,
    };
  },
};
