import React, {useEffect} from 'react';
import usePagination from 'hooks/pagination.js';

/** 
 * Handle pagination.
 */
export default function Pagination({className = "", children, fetchMore, canFetch}) {
    const {isBottom} = usePagination();

    useEffect(() => {
        if (isBottom && canFetch) fetchMore();
    }, [isBottom, fetchMore, canFetch])

    return <div className={`${className} relative`}>{children}</div>;
}