import React from 'react';

export default function Searchbar() {
    return (
        <div className="searchbar">
            <div>
                <input type="text" placeholder="Search..." />
            </div>
            <div>
                <input type="dropdown" />
            </div>
            <div>
                <button onClick={() => {}}>Search</button>
            </div>

        </div>

    )
}