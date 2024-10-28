import { run, type Step } from "./utils.js";

function scenarios(): Step[][] {
  return [
    [
      {
        type: "log",
        payload: { resource: "departures" },
      },
      {
        type: "request",
        payload: { resource: "departures" },
      },
      {
        type: "write",
        payload: [{ collection: "config", entries: [["year", [[2015]]]] }],
      },
      {
        type: "write",
        payload: [{ collection: "config", entries: [["origin", [["SYR"]]]] }],
      },
      {
        type: "write",
        payload: [
          { collection: "config", entries: [["resettlement", [["USA"]]]] },
        ],
      },
      {
        type: "write",
        payload: [
          {
            collection: "config",
            entries: [
              ["year", [[2016, 2017]]],
              ["origin", [["MMR", "SYR"]]],
              ["resettlement", [["NOR", "USA"]]],
            ],
          },
        ],
      },
      {
        type: "log",
        payload: { resource: "departures" },
      },
      {
        type: "log",
        payload: { resource: "departures" },
      },
      {
        type: "log",
        payload: { resource: "departures" },
      },
      {
        type: "log",
        payload: { resource: "departures" },
      },
      {
        type: "log",
        payload: { resource: "departures" },
      },
      {
        type: "log",
        payload: { resource: "departures" },
      },
    ],
  ];
}

await run(scenarios(), [3590]);
