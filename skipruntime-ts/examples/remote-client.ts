import { SkipHttpAccessV1, run, type Step } from "./utils.js";

function scenarios() {
  return [
    [
      {
        type: "write",
        payload: [{ collection: "input1", entries: [["v1", [2]]] }],
      },
      {
        type: "write",
        payload: [{ collection: "input2", entries: [["v1", [3]]] }],
      },
      {
        type: "delete",
        payload: [{ collection: "input1", keys: ["v1"] }],
      },
      {
        type: "write",
        payload: [
          {
            collection: "input1",
            entries: [
              ["v1", [2]],
              ["v2", [6]],
            ],
          },
        ],
      },
      {
        type: "write",
        payload: [{ collection: "input2", entries: [["v2", [0]]] }],
      },
      {
        type: "write",
        payload: [{ collection: "input1", entries: [["v1", [8]]] }],
      },
    ] as Step[],
  ];
}

const access = new SkipHttpAccessV1(3589, 3590);
access.request("data", {});

run(scenarios(), 3587, 3588);
