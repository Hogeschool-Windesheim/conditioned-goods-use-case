
/** 
 * Measurement
 */
export default class Measurement {

    /** 
     * Constructor
     */
    constructor(name: string, value: number, owner: string) {
        this.name = name;
        this.value = value;
        this.owner = owner;
    }

    /** 
     * Get owner
     */
    getOwner() {
        return this,owner;
    }

    /** 
     * Get name
     */
    getName() {
        return this.name;
    }

    /** 
     * Get value
     */
    getValue() {
        return this.value;
    }
}