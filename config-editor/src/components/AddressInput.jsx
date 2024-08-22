import React, { useState } from 'react';
import { CSSTransition } from 'react-transition-group';
import '../styles/AddressInput.css'; // Ensure the path is correct

function AddressInput({ saveAddress }) {
    const [inputAddress, setInputAddress] = useState('');

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
            in={true}
            timeout={500}
            classNames="fade"
            unmountOnExit
        >
            <div className="address-section">
                <h2>Enter Device Address</h2>
                <input
                    type="text"
                    value={inputAddress}
                    onChange={(e) => setInputAddress(e.target.value)}
                    placeholder="Enter device address"
                />
                <button onClick={handleSave}>Save Address</button>
            </div>
        </CSSTransition>
    );
}

export default AddressInput;
