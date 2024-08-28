import { run } from "./utils.js";

function scenarios() {
  return [
    [
      {
        type: "get",
        command: "add",
        payload: "v1",
      },
      {
        type: "post",
        command: "set",
        payload: [{ name: "input1", key: "v1", value: 2 }],
      },
      {
        type: "post",
        command: "set",
        payload: [{ name: "input2", key: "v1", value: 3 }],
      },
      {
        type: "post",
        command: "delete",
        payload: [{ name: "input1", keys: ["v1"] }],
      },
      {
        type: "post",
        command: "set",
        payload: [
          { name: "input1", key: "v1", value: 2 },
          { name: "input1", key: "v2", value: 6 },
        ],
      },
      {
        type: "post",
        command: "set",
        payload: [{ name: "input2", key: "v2", value: 0 }],
      },
      {
        type: "post",
        command: "set",
        payload: [{ name: "input1", key: "v1", value: 8 }],
      },
    ],
  ];
}

run(scenarios(), 8081);
