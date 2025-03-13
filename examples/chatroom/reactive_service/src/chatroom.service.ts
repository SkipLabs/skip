import type {
  Context,
  EagerCollection,
  Json,
  Mapper,
  Resource,
  SkipService,
  Values,
} from "@skipruntime/core";

import { KafkaExternalService } from "@skip-adapter/kafka";

type Message = {
  id: number;
  author: string;
  body: string;
  timestamp: number;
};

type Like = {
  id: number;
  message_id: number;
  author: string;
};

type LikedMessage = Message & { likedBy: string[] };

type ResourceInputs = {
  messages: EagerCollection<number, Message>;
  likersByMessage: EagerCollection<number, string>;
};

const kafka = new KafkaExternalService(
  {
    clientId: "skip-chatroom",
    brokers: [{ host: "kafka", port: 19092 }],
  },
  (msg) => {
    const value = JSON.parse(msg.value);
    return [[-Number(value.id), value]];
  },
);

class GroupByMessage implements Mapper<number, Like, number, string> {
  mapEntry(_id: number, likes: Values<Like>): Iterable<[number, string]> {
    return likes.toArray().map((like) => [-like.message_id, like.author]);
  }
}

class JoinUniqueLikers
  implements Mapper<number, Message, number, LikedMessage>
{
  constructor(private likersByMessage: EagerCollection<number, string>) {}
  mapEntry(
    id: number,
    messages: Values<Message>,
  ): Iterable<[number, LikedMessage]> {
    const msg: Message = messages.getUnique();
    const uniqueLikers = Array.from(new Set(this.likersByMessage.getArray(id)));
    return [[id, { ...msg, likedBy: uniqueLikers }]];
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
      .map(JoinUniqueLikers, collections.likersByMessage);
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
    const likersByMessage: EagerCollection<number, string> =
      likes.map(GroupByMessage);
    return {
      likersByMessage,
      messages,
    };
  },
};
