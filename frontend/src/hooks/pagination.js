import {useContext} from "react";
import {PaginationContext} from "components/Providers/Pagination.js";

/** 
 * Pagination hook
 */
export default function usePagination() {
    const {isBottom, setIsBottom} = useContext(PaginationContext);

    return {
        isBottom,
        setIsBottom
    }
}