import type { EagerCollection } from "@skipruntime/api";

import { v4 as uuidv4 } from "uuid";

import type { Mapper, NonEmptyIterator, TJSON } from "@skipruntime/api";

export type ID<_T> = string;
export type GenericID = string;

export function newID<T>(collectionName: string): ID<T> {
  return collectionName + "-" + uuidv4();
}

export function makeID<T>(x: T): ID<T> {
  if (typeof x === "string") return x;
  return JSON.stringify(x);
}

/*****************************************************************************/
// Generic unique mapper
/*****************************************************************************/

export class UniqueMapper<K extends TJSON, V extends TJSON>
implements Mapper<K, V, K, V> {
  mapElement(
    key: K,
    values: NonEmptyIterator<V>
  ): Iterable<[K, V]> {
    return [[key, values.first()]];
  }
}

/*****************************************************************************/
// Generic index mapper
/*****************************************************************************/


const keyName: string = "$key";

export class IndexMapper<T extends TJSON> implements Mapper<TJSON, T, string, T> {
  private fieldNames: string[];
  constructor(...fieldNames: string[]) {
    this.fieldNames = fieldNames;
  }
  mapElement(
    key: TJSON,
    values: NonEmptyIterator<T>,
  ): Iterable<[string, T]> {
    let result: Array<[string, T]> = [];
    for (const value of values) {
      if (typeof value !== "object") {
        throw new Error("Expected an object not: " + JSON.stringify(value));
      }
      if (value === null) {
        throw new Error("Expected an object not: null");
      }
      const fieldValues = [];
      for (const fieldName of this.fieldNames) {
        if (fieldName === keyName) {
          if (typeof key !== "string") {
            throw new Error(
              "Object field is not a string " +
                fieldName +
                ": " +
                JSON.stringify(value),
            );
          }
          if (key.includes(":")) {
            throw new Error(
              "Malformed key (it contains a ':')" +
                fieldName +
                ": " +
                JSON.stringify(value),
            );
          }
          fieldValues.push(key);
          continue;
        }
        if (!(fieldName in value)) {
          throw new Error(
            "Object does not define the field " +
              fieldName +
              ": " +
              JSON.stringify(value),
          );
        }
        const fieldValue = (value as Record<string, unknown>)[fieldName];
        if (typeof fieldValue !== "string") {
          throw new Error(
            "Object field is not a string " +
              fieldName +
              ": " +
              JSON.stringify(value),
          );
        }
        if (fieldValue.includes(":")) {
          throw new Error(
            "Malformed key (it contains a ':')" +
              fieldName +
              ": " +
              JSON.stringify(value),
          );
        }
        fieldValues.push(fieldValue);
      }
      result.push([fieldValues.join(":"), value]);
    }
    return result;
  }
}

type Request = {
  to: GenericID;
  from: GenericID;
};

class RequestMapperLeft
  implements Mapper<ID<Request>, Request, GenericID, Request>
{
  mapElement(
    _ID: ID<Request>,
    requests: NonEmptyIterator<Request>,
  ): Iterable<[GenericID, Request & { side: "left" | "right" }]> {
    const request = requests.first();
    return [[request.to, { ...request, side: "left" }]];
  }
}

class RequestMapperRight
  implements Mapper<GenericID, Request, GenericID, Request>
{
  mapElement(
    _ID: ID<Request>,
    requests: NonEmptyIterator<Request>,
  ): Iterable<[GenericID, Request & { side: "right" }]> {
    const request = requests.first();
    return [[request.from, { ...request, side: "right" }]];
  }
}

class RequestMergeMapper
  implements
    Mapper<
      GenericID,
      Request & { side: "left" | "right" },
      GenericID,
      GenericID
    >
{
  mapElement(
    key: GenericID,
    requests: NonEmptyIterator<Request & { side: "left" | "right" }>,
  ): Iterable<[GenericID, GenericID]> {
    let foundLeft = [];
    let foundRight = [];
    for (const req of requests) {
      if (req.side === "left") {
        foundLeft.push(req.from);
      } else if (req.side === "right") {
        foundRight.push(req.to);
      }
    }
    const setLeft = new Set(foundLeft);
    return foundRight
      .filter((elt) => setLeft.has(elt))
      .map((x) => {
        return [key, x]
      });
  }
}

export function makeRequestCollection(
  input: EagerCollection<GenericID, Request>,
): EagerCollection<GenericID, GenericID> {
  return input
    .map(RequestMapperLeft)
    .merge(input.map(RequestMapperRight))
    .map(RequestMergeMapper);
}


/*****************************************************************************/
// Logging
/*****************************************************************************/

export class LogMapper implements Mapper<TJSON, TJSON, TJSON, TJSON> {
  constructor(private tag: string) { }
  mapElement(key: TJSON, values: NonEmptyIterator<TJSON>): Iterable<[TJSON, TJSON]> {
    for(const value of values) {
      console.log(this.tag + ": " + key.toString() + " // " + value.toString());
    }
    return [];
  }
}


