import {useEffect} from 'react';
import useFetch from 'use-http';
import {useSnackbar} from 'react-simple-snackbar';
import useDebounce from 'hooks/debounce.js';
import {errorOptions} from 'libs/snackbar.js';

const DEFAULT = {result: [], count: 0, bookmark: ""}

/** 
 * Handle dashboard methods.
 */
export default function useDashboard() {
    const {get, response, loading, data = DEFAULT} = useFetch(`/shipments/search`, {cachePolicy: 'no-cache'}, []);
    const {debounce} = useDebounce();
    const [openError] = useSnackbar(errorOptions);

    /** 
     * On search
     */
    function search(e) {
        // Wailt until the use stops with typing before searching for the value.
        debounce(() => get(e.target.value), 500);
    }

    useEffect(() => {
        if (!loading && (!response.ok || response.ok === undefined)) {
            openError("Something went wrong while fetching shipments.")
        }
    }, [response.ok, loading]);

    return {
        data,
        search,
    }
}