import { run } from "./utils.js";

function scenarios() {
  return [
    [
      {
        type: "get",
        command: "getUser",
        payload: "123",
      },
      {
        type: "post",
        command: "set",
        payload: [{ key: "123", value: {name: "daniel", country: "UK" }}],
      }
    ],
  ];
}

run(scenarios(), 8081);
