/**
 * This package contains items that may be useful for working with the Skip framework, but are not strictly necessary.
 *
 * @packageDocumentation
 */

export {
  type ExternalResource,
  GenericExternalService,
  Polled,
} from "./external.js";
export { SkipServiceBroker, fetchJSON, type Entrypoint } from "./rest.js";
export {
  Count,
  CountMapper,
  Max,
  Min,
  SkipExternalService,
  Sum,
} from "@skipruntime/core";
