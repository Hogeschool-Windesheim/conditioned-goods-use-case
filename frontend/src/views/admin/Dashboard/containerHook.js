import {useState} from 'react';
import useFetch from 'use-http'

const DEFAULT = {result: [], count: 0, bookmark: ""}
const PAGE_COUNT = 50;

/** 
 * Handle dashboard methods.
 */
export default function useDashboard() {
    const [bookmark, setBookmark] = useState("");
    const [canFetch, setCanFetch] = useState(true);

    function onNewData(oldData = DEFAULT, newData) {
        if (newData.count < PAGE_COUNT) setCanFetch(false);
        return {...newData, result: [...oldData.result, ...newData.result]}
    }

    const {data = DEFAULT} = useFetch(`${process.env.REACT_APP_API_URL}/shipments/${PAGE_COUNT}/${bookmark}`, {
        onNewData: onNewData
    }, [bookmark]);

    function onFetchMore() {
        setBookmark(data.bookmark);
    }

    return {
        canFetch,
        data,
        onFetchMore,
    }
}