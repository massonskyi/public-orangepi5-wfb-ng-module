import React from 'react';
import '../styles/TopPanel.css'; // Ensure the path is correct

function TopPanel() {
    const rebootSystem = async () => {
        try {
            const response = await fetch(`http://${currentAddress}/api/sys/api/reboot_system`);
            if (response.ok) {
                const data = await response.json();
                setFavorites(data);
            } else {
                console.error('Failed to load favorites.');
            }
        } catch (error) {
            console.error('Error loading favorites:', error);
        }
    };
    return (
        <div className="top-panel">
            <button className="top-panel__button" onClick={rebootSystem}>Reload</button>
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