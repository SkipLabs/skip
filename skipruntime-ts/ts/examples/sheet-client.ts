import { run } from "./utils.js";

function scenarios() {
  return [
    [
      {
        type: "post",
        command: "set",
        payload: [
          { key: "A1", value: "23" },
          { key: "A2", value: "2" },
        ],
      },
      {
        type: "post",
        command: "set",
        payload: [{ key: "A3", value: "=A1 + A2" }],
      },
      {
        type: "post",
        command: "set",
        payload: [{ key: "A1", value: "5" }],
      },
      {
        type: "post",
        command: "set",
        payload: [{ key: "A4", value: "=A3 * A2" }],
      },
      {
        type: "post",
        command: "delete",
        payload: [{ keys: ["A3"] }],
      },
    ],
  ];
}

run(scenarios(), 8082);
