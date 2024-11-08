import type {
  SkipService,
  EagerCollection,
  Context,
  Resource,
} from "@skipruntime/api";
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

class DeparturesResource implements Resource {
  instantiate(
    cs: { config: EagerCollection<string, (string | number)[]> },
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

class Service implements SkipService {
  initialData = { config: [] };
  resources = {
    departures: DeparturesResource,
  };
  externalServices = {
    externalDeparturesAPI: new GenericExternalService({
      departuresFromAPI: new Polled(
        "https://api.unhcr.org/rsq/v1/departures",
        10000,
        (data: Result) => data.results.map((v, idx) => [idx, [v]]),
      ),
    }),
  };

  createGraph(ic: { config: EagerCollection<string, string[]> }) {
    return ic;
  }
}

const closable = await runService(new Service(), 3590);

function shutdown() {
  closable.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
