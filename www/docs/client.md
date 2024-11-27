# Client connections

Clients can subscribe to updates from a reactive service using the widely-available [server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events) protocol, or make synchronous read requests for specific data.
This means that Skip clients are thin and lightweight: all major browsers implement the requisite `EventSource` interface, and other types of clients can easily implement parsers for the simple text-based protocol.

Note that this page describes mechanisms for front-end clients or non-Skip systems to access the outputs of a Skip service; to communicate among Skip services it is both simpler and more efficient to use [external dependencies](todo: docusaurus link).

## Event Streams

## Synchronous HTTP interface
