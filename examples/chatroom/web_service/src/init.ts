import type { Producer } from "kafkajs";

export async function init(
  producer: Producer,
  encoder: (msg: any) => { value: string },
) {
  const sendMessage = async (msg: any, ...likedBy: string[]) => {
    const messages:[{value:string}] = [encoder(msg)];
    await producer.send({ topic: "skip-chatroom-messages", messages });
    const message_id = JSON.parse(messages[0].value).id;
    for (const author of likedBy)
      await producer.send({
        topic: "skip-chatroom-likes",
        messages: [encoder({ message_id, author })],
      });
  };

  await sendMessage({ author: "Bob", body: "Hey guys!" }, "Alice", "Eve");
  await sendMessage({ author: "Alice", body: "Hi, Bob" }, "Bob");
  await sendMessage({ author: "Eve", body: "Welcome to the chatroom" }, "Bob");
  await sendMessage({
    author: "Skip System",
    body: "Try sending messages/likes and see them reflect instantly across multiple tabs! All data is written to Kafka, then reactively processed and pushed to the client by Skip",
  });
}
