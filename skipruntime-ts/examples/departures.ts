import type {
  SkipService,
  EagerCollection,
  Context,
  Resource,
} from "@skipruntime/core";
import { runService } from "@skipruntime/server";
import { ExternalService, Polled } from "@skipruntime/core";

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
  reactiveCompute(
    context: Context,
    cs: { config: EagerCollection<string, (string | number)[]> },
  ): EagerCollection<number, Departure> {
    const get = (name: string, def: string) => {
      const r = cs.config.maybeGetOne(name);
      if (r != null) {
        return r.join(",");
      }
      return def;
    };
    const params = {
      page: 1,
      year: get("year", "2016,2017"),
      origin: get("origin", "MMR,SYR"),
      asylum: get("asylum", "JOR,LBN"),
      resettlement: get("resettlement", "NOR,USA"),
    };

    return context.useExternalResource({
      supplier: "externalDeparturesAPI",
      resource: "departuresFromAPI",
      params,
    });
  }
}

class Service implements SkipService {
  inputCollections = { config: [] };
  resources = {
    departures: DeparturesResource,
  };
  externalServices = {
    externalDeparturesAPI: new ExternalService({
      departuresFromAPI: new Polled(
        "https://api.unhcr.org/rsq/v1/departures",
        10000,
        (data: Result) => data.results.map((v, idx) => [idx, [v]]),
      ),
    }),
  };

  reactiveCompute(
    _context: Context,
    ic: { config: EagerCollection<string, string[]> },
  ) {
    return ic;
  }
}

const closable = await runService(new Service(), 3590);

function shutdown() {
  closable.close();
}

process.on("SIGTERM", shutdown);
process.on("SIGINT", shutdown);
