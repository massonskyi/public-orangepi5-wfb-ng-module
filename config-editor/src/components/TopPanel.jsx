import React from 'react';
import '../styles/TopPanel.css'; // Ensure the path is correct

function TopPanel() {
    return (
        <div className="top-panel">
            <button className="top-panel__button">Reload</button>
            <button className="top-panel__button">Check Signal</button>
            <div className="dropdown">
                <button className="top-panel__button dropdown-toggle">Check</button>
                <div className="dropdown-content">
                    <a href="#">Option 1</a>
                    <a href="#">Option 2</a>
                    <a href="#">Option 3</a>
                </div>
            </div>
        </div>
    );
}

export default TopPanel;