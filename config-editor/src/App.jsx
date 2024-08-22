import React, { useState, useEffect } from 'react';
import AddressInput from './components/AddressInput';
import RecentAddresses from './components/RecentAddresses';
import ConfigEditor from './components/ConfigEditor';
import "./styles/App.css"

function App() {
    const [currentAddress, setCurrentAddress] = useState('');
    const [config, setConfig] = useState(null);
    const [recentAddresses, setRecentAddresses] = useState([]);

    useEffect(() => {
        const addresses = JSON.parse(localStorage.getItem('recentAddresses')) || [];
        setRecentAddresses(addresses);
    }, []);

    const fetchConfig = async (address) => {
        try {
            const formattedAddress = address.startsWith('http') ? address : `http://${address}`;
            const response = await fetch(`${formattedAddress}/api/crud/data`);
            if (!response.ok) throw new Error("Failed to fetch config.");
            const data = await response.json();
            return data;
        } catch (error) {
            alert("Error: " + error.message);
            return null;
        }
    };

    const saveAddress = async (address) => {
        setCurrentAddress(address);
        if (!recentAddresses.includes(address)) {
            const updatedAddresses = [...recentAddresses, address];
            setRecentAddresses(updatedAddresses);
            localStorage.setItem('recentAddresses', JSON.stringify(updatedAddresses));
        }
        const fetchedConfig = await fetchConfig(address);
        setConfig(fetchedConfig);
    };

    return (
        <div className="container mx-auto p-8">
            <h1 className="text-4xl font-bold text-center mb-8 text-blue-600">Config Editor</h1>
            <AddressInput saveAddress={saveAddress} />
            <RecentAddresses recentAddresses={recentAddresses} saveAddress={saveAddress} />
            {config && <ConfigEditor config={config} currentAddress={currentAddress} />}
        </div>
    );
}

export default App;