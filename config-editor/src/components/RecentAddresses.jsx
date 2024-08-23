import React, { useState, useEffect } from 'react';
import '../styles/RecentAddresses.css'; // Подключаем файл стилей

function RecentAddresses({ recentAddresses, saveAddress, currentAddress }) {
    const [favorites, setFavorites] = useState([]);

    // Fetch favorites from the backend on mount
    useEffect(() => {
        const loadFavorites = async () => {
            try {
                const response = await fetch(`http://${currentAddress}/api/favorites`);
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

        loadFavorites();
    }, []);

    // Save favorites to the backend whenever they are updated
    useEffect(() => {
        const saveFavorites = async () => {
            try {
                const response = await fetch(`http://${currentAddress}/api/favorites`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ favorites }),
                });
                if (!response.ok) {
                    console.error('Failed to save favorites.');
                }
            } catch (error) {
                console.error('Error saving favorites:', error);
            }
        };

        if (favorites.length > 0) {
            saveFavorites();
        }
    }, [favorites]);

    const getButtonClass = (address) => {
        if (address === currentAddress) return 'recent-addresses__button--active';
        if (favorites.includes(address)) return 'recent-addresses__button--favorite';
        return 'recent-addresses__button--default';
    };

    const handleAddressClick = async (address) => {
        await saveAddress(address); // This will update the current address and configuration
    };

    const toggleFavorite = (address) => {
        setFavorites(prevFavorites => {
            if (prevFavorites.includes(address)) {
                return prevFavorites.filter(fav => fav !== address); // Remove from favorites
            } else {
                return [...prevFavorites, address]; // Add to favorites
            }
        });
    };

    return (
        <div className="recent-addresses">
            <h2 className="recent-addresses__title">Recent Addresses</h2>
            <div className="recent-addresses__list">
                {recentAddresses.map((address, index) => (
                    <div key={index} className="recent-addresses__item">
                        <button
                            onClick={() => handleAddressClick(address)}
                            className={`recent-addresses__button ${getButtonClass(address)}`}
                        >
                            {address}
                        </button>
                        <button
                            onClick={() => toggleFavorite(address)}
                            className="recent-addresses__favorite-button"
                        >
                            {favorites.includes(address) ? '★' : '☆'}
                        </button>
                    </div>
                ))}
            </div>

            <h2 className="recent-addresses__title">Favorite Addresses</h2>
            <div className="recent-addresses__list">
                {favorites.map((address, index) => (
                    <div key={index} className="recent-addresses__item">
                        <button
                            onClick={() => handleAddressClick(address)}
                            className={`recent-addresses__button ${getButtonClass(address)}`}
                        >
                            {address}
                        </button>
                        <button
                            onClick={() => toggleFavorite(address)}
                            className="recent-addresses__favorite-button"
                        >
                            ★
                        </button>
                    </div>
                ))}
            </div>
        </div>
    );
}

export default RecentAddresses;
