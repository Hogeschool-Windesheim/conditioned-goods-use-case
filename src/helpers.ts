
/** 
 * Convert a JavaScript Object to a buffer of bytes.
 */
export function toBytes(input: Object): Array<number> {
    return Buffer.from(JSON.stringify(input));
}