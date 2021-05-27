import React, {createContext, useState} from 'react';

export const PaginationContext = createContext();

/** 
* Pagination provider (infinite scroll)
*/
export default function Pagination({children, className}) {
    const [isBottom, setIsBottom] = useState(false);

    /** 
     * Check if the user scrolls near the bottom of the container (80%)
     */
    function isAtTheBottom(e) {
        return e.target.scrollHeight - e.target.scrollTop >= (e.target.clientHeight / 100 * 80);
    }

    /** 
     * Update isBottom state.
     */
    function trackScrolling(e) {
        setIsBottom(isAtTheBottom(e));
    }

    return (
        <PaginationContext.Provider value={{
            isBottom,
            setIsBottom,
        }}>
            <div className={className} onScroll={trackScrolling}>
                {children}
            </div>
        </PaginationContext.Provider>
    );

}