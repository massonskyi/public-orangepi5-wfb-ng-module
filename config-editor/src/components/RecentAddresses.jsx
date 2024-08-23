import React from 'react';

function RecentAddresses({ recentAddresses, saveAddress }) {
    // При нажатии на адрес обновляем конфигурацию и устанавливаем новый текущий адрес
    const handleAddressClick = async (address) => {
        await saveAddress(address); // Это вызовет обновление текущего адреса и конфигурации
    };

    return (
        <div className="recent-addresses bg-white shadow-lg p-6 rounded-lg">
            <h2 className="text-2xl font-semibold text-center mb-4">Recent Addresses</h2>
            <div className="flex flex-wrap justify-center">
                {recentAddresses.map((address, index) => (
                    <button
                        key={index}
                        onClick={() => handleAddressClick(address)}
                        className="bg-blue-500 text-white p-3 rounded-lg m-2 hover:bg-blue-600 transition"
                    >
                        {address}
                    </button>
                ))}
            </div>
        </div>
    );
}

export default RecentAddresses;
