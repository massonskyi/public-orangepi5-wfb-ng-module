import React, { useState, useEffect } from 'react';
import AddressInput from './components/AddressInput';
import RecentAddresses from './components/RecentAddresses';
import ConfigEditor from './components/ConfigEditor';
import BurgerMenu from './components/BurgerMenu';
import TopPanel from './components/TopPanel';
import LogsViewer from './components/LogsViewer';
import './styles/App.css'; // Ensure the path is correct

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
    const removeAddress = (address) => {
        setRecentAddresses(prev => {
            const updatedAddresses = prev.filter(addr => addr !== address);
            localStorage.setItem('recentAddresses', JSON.stringify(updatedAddresses));
            return updatedAddresses;
        });
        if (currentAddress === address) {
            setCurrentAddress('');
            setConfig(null);
        }
    };

    return (
        <div className="container">
            <TopPanel currentAddress={currentAddress}/> {/* Include the TopPanel component */}
            <BurgerMenu />
            <h1>Config Editor</h1>
            <AddressInput saveAddress={saveAddress} />
            <RecentAddresses recentAddresses={recentAddresses} saveAddress={saveAddress} currentAddress={currentAddress}/>
            <div className="config-editors">
                {recentAddresses.map(address => (
                    <ConfigEditor
                        key={address}
                        config={address === currentAddress ? config : null}
                        currentAddress={address}
                        removeAddress={removeAddress}
                    />
                ))}
            </div>
            <div className="config-logs">
                <LogsViewer currentAddress={currentAddress}></LogsViewer>
            </div>
        </div>
    );
}

export default App;
