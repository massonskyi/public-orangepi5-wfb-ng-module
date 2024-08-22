// src/components/AddressInput.js
import React, { useState } from 'react';
import { CSSTransition } from 'react-transition-group';
import './AddressInput.css'; // Import the CSS for transitions

function AddressInput({ saveAddress }) {
    const [inputAddress, setInputAddress] = useState('');
    const [show, setShow] = useState(true);

    const handleSave = () => {
        const trimmedAddress = inputAddress.trim();
        if (!trimmedAddress) {
            alert("Please enter a valid address.");
            return;
        }
        saveAddress(trimmedAddress);
        setInputAddress(''); // Clear the input after saving
    };

    return (
        <CSSTransition
            in={show}
            timeout={500}
            classNames="fade"
            unmountOnExit
        >
            <div className="address-section bg-white shadow-lg p-6 rounded-lg">
                <h2 className="text-2xl font-semibold text-center mb-4">Enter Device Address</h2>
                <input
                    className="w-full p-3 border rounded-lg focus:outline-none focus:border-blue-500"
                    type="text"
                    value={inputAddress}
                    onChange={(e) => setInputAddress(e.target.value)}
                    placeholder="Enter device address"
                />
                <button
                    onClick={handleSave}
                    className="w-full mt-4 bg-blue-500 text-white p-3 rounded-lg hover:bg-blue-600 transition"
                >
                    Save Address
                </button>
            </div>
        </CSSTransition>
    );
}

export default AddressInput;
