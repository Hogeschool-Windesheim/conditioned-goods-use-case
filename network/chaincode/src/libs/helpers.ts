import stringify from "json-stringify-deterministic";
import sortKeysRecursive from "sort-keys-recursive";

/**
 * Convert a JavaScript Object to a buffer of bytes.
 */
export function toBytes<T>(input: T): Uint8Array {
    return Buffer.from(stringify(sortKeysRecursive(input)));
}

/**
 * Convert buffer back to a JavaScript Object.
 */
export function toObject<T>(input: Uint8Array): T {
    return JSON.parse(input.toString());
}

/**
 * Wrapper for the JSON.stringify function
 */
export function toJson(input) {
    return JSON.stringify(input);
}

// TODO: check if it's possible to type iterator.
/**
 * Convert a buffer to an Array of JavaScript Objects.
 */
export async function toArrayOfObjects<T>(iterator: any): Promise<Array<T>> {
    const results = [];

    for await (const res of iterator) {
        results.push(toObject(res.value));
    }

    return results;
}
