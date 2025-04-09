/**
 * This package contains items that may be useful for working with the Skip framework, but are not strictly necessary.
 *
 * @packageDocumentation
 */

export {
  defaultParamEncoder,
  PolledExternalService,
  type PolledHTTPResource,
} from "./external.js";
export { SkipExternalService, asLeader, asFollower } from "./remote.js";
export { SkipServiceBroker, fetchJSON, type Entrypoint } from "./rest.js";
export { Count, Max, Min, Sum } from "./utils.js";
