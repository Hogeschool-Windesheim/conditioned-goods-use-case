import {useEffect, useRef} from 'react';

/** 
 * Debounce hook.
 */
export default function useDebounce() {
    const debounceRef = useRef();

    /** 
     * Clear debounce timeout.
     */
    function clearDebounce() {
        if (debounceRef.current) clearTimeout(debounceRef.current);
    }

    useEffect(() => {
        return () => clearDebounce();
    });

    /** 
     * Set debounce
     */
    function debounce(value, delay) {
        clearDebounce();

        debounceRef.current = setTimeout(value, delay);
    }

    return {
        clearDebounce,
        debounce
    }
}