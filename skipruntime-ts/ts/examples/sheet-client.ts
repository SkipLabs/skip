import { run, type Step } from "./utils.js";

function scenarios() {
  return [
    [
      {
        type: "request",
        payload: { resource: "computed" },
      },
      {
        type: "write",
        payload: [
          {
            collection: "cells",
            entries: [
              ["A1", ["23"]],
              ["A2", ["2"]],
            ],
          },
        ],
      },
      {
        type: "write",
        payload: [
          {
            collection: "cells",
            entries: [["A3", ["=A1 + A2"]]],
          },
        ],
      },
      {
        type: "write",
        payload: [
          {
            collection: "cells",
            entries: [["A1", ["5"]]],
          },
        ],
      },
      {
        type: "write",
        payload: [
          {
            collection: "cells",
            entries: [["A4", ["=A3 * A2"]]],
          },
        ],
      },
      {
        type: "request",
        payload: { resource: "computed" },
      },
      {
        type: "delete",
        payload: [
          {
            collection: "cells",
            keys: ["A3"],
          },
        ],
      },
      {
        type: "request",
        payload: { resource: "computed" },
      },
    ] as Step[],
  ];
}

run(scenarios());
