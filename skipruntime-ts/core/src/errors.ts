/**
 * Umbrella type for run-time errors thrown by the Skip runtime.
 * @hideconstructor
 */
export class SkipError extends Error {}

/**
 * Exception indicating an attempted read/write to a collection that does not exist.
 * @hideconstructor
 */
export class SkipUnknownCollectionError extends SkipError {}

/**
 * Exception indicating an attempted read/write to a resource that does not exist.
 * @hideconstructor
 */
export class SkipUnknownResourceError extends SkipError {}

/**
 * Exception indicating a malformed REST query to a Skip service.
 * @hideconstructor
 */
export class SkipRESTError extends SkipError {}

/**
 * Exception indicating that a fetch returned an HTTP status outside of the 200-299 range.
 * @hideconstructor
 */
export class SkipFetchError extends SkipError {}

/**
 * Exception indicating a non-top-level class being used as a mapper/reducer/etc.
 *
 * The Skip runtime requires that these classes be defined at the top-level, so that their names can be used to generate cache keys and the like.
 * @hideconstructor
 */
export class SkipClassNameError extends SkipError {}

/**
 * Exception indicating a key did not have a unique value.
 *
 * Some collections are used to associate each key to a unique value.
 * When this expectation is not met (a key is associated to either zero or multiple values), operations such as `getUnique` throw `SkipNonUniqueValueError`.
 * @hideconstructor
 */
export class SkipNonUniqueValueError extends SkipError {}

/**
 * Exception indicating a resource instance is already in use.
 *
 * Only one stream is alowed by resource instance.
 * When a subcribed instance is newly subscribed the `SkipResourceInstanceInUseError` is thrown.
 * @hideconstructor
 */
export class SkipResourceInstanceInUseError extends SkipError {}
