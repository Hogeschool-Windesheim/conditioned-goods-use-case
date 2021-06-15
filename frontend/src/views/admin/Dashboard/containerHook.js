import useFetch from 'use-http';
import useDebounce from 'hooks/debounce.js';

const DEFAULT = {result: [], count: 0, bookmark: ""}

/** 
 * Handle dashboard methods.
 */
export default function useDashboard() {
    const {get, data = DEFAULT} = useFetch(`/shipments/search`, []);
    const {debounce} = useDebounce();

    function search(e) {
        const searchstring = e.target.value;
        const url = searchstring.length > 0 ? `${searchstring}` : '';

        debounce(() => get(url), 500);
    }

    return {
        data,
        search,
    }
}