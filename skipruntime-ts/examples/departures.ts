import type { EagerCollection, Context, Resource } from "@skipruntime/api";
import { runService } from "@skipruntime/server";
import { GenericExternalService, Polled } from "@skipruntime/helpers";

type Departure = {
  year: string;
  origin: string;
  origin_name: string;
  asylum: string;
  asylum_name: string;
  destination: string;
  destination_name: string;
  persons: string;
};

type Result = {
  results: Departure[];
};

type ResourceInputs = { config: EagerCollection<string, (string | number)[]> };

class DeparturesResource implements Resource<ResourceInputs> {
  instantiate(
    cs: ResourceInputs,
    context: Context,
  ): EagerCollection<number, Departure> {
    const get = (name: string, def: string) => {
      try {
        return cs.config.getUnique(name).join(",");
      } catch (_e) {
        return def;
      }
    };
    const params = {
      page: 1,
      year: get("year", "2016,2017"),
      origin: get("origin", "MMR,SYR"),
      asylum: get("asylum", "JOR,LBN"),
      resettlement: get("resettlement", "NOR,USA"),
    };

    return context.useExternalResource({
      service: "externalDeparturesAPI",
      identifier: "departuresFromAPI",
      params,
    });
  }
}

const service = await runService(
  {
    initialData: { config: [] },
    resources: {
      departures: DeparturesResource,
    },
    externalServices: {
      externalDeparturesAPI: new GenericExternalService({
        departuresFromAPI: new Polled(
          "https://api.unhcr.org/rsq/v1/departures",
          10000,
          (data: Result) => data.results.map((v, idx) => [idx, [v]]),
        ),
      }),
    },
    createGraph: (ic) => ic,
  },
  {
    control_port: 3591,
    streaming_port: 3590,
  },
);

function shutdown() {
  service.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
