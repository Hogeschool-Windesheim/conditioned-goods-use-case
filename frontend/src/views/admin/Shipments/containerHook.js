import {useState, useEffect} from 'react';
import {useSnackbar} from 'react-simple-snackbar';
import useFetch from 'use-http';
import {errorOptions} from '/libs/snackbar.js';

const DEFAULT = {result: [], count: 0, bookmark: ""}
const PAGE_COUNT = 50;

/** 
 * Handle shipments methods.
 */
export default function useShipments() {
    const [bookmark, setBookmark] = useState("");
    const [canFetch, setCanFetch] = useState(true);
    const [openError] = useSnackbar(errorOptions);

    /** 
     * Combine the new data with the old data.
     */
    function onNewData(oldData = DEFAULT, newData) {
        if (newData.count < PAGE_COUNT) setCanFetch(false);
        return {...newData, result: [...oldData.result, ...newData.result]}
    }

    const {response, loading, data = DEFAULT} = useFetch(`/shipments/${PAGE_COUNT}/${bookmark}`, {
        onNewData,
        cachePolicy: 'no-cache'
    }, [bookmark]);

    /** 
     * Fetch more rows.
     */
    function onFetchMore() {
        setBookmark(data.bookmark);
    }

    useEffect(() => {
        if (!loading && (!response.ok || response.ok === undefined)) {
            openError("Something went wrong while fetching shipments.")
        }
    }, [response.ok, loading]);

    return {
        data,
        canFetch,
        onFetchMore
    }
}