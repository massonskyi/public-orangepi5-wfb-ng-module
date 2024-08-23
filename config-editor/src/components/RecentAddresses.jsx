import React from 'react';
import '../styles/RecentAddresses.css'; // Подключаем файл стилей

function RecentAddresses({ recentAddresses, saveAddress, currentAddress }) {
    const getButtonClass = (address) => {
        if (address === currentAddress) return 'recent-addresses__button--active';
        return recentAddresses.includes(address) ? 'recent-addresses__button--inactive' : 'recent-addresses__button--default';
    };

    const handleAddressClick = async (address) => {
        await saveAddress(address); // Это вызовет обновление текущего адреса и конфигурации
    };

    return (
        <div className="recent-addresses">
            <h2 className="recent-addresses__title">Recent Addresses</h2>
            <div className="recent-addresses__list">
                {recentAddresses.map((address, index) => (
                    <button
                        key={index}
                        onClick={() => handleAddressClick(address)}
                        className={`recent-addresses__button ${getButtonClass(address)}`}
                    >
                        {address}
                    </button>
                ))}
            </div>
        </div>
    );
}

export default RecentAddresses;
