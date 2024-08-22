import React from 'react';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import './ConfigEditor.css'; // Ensure the path is correct

function ConfigEditor({ config, currentAddress }) {
    const handleChange = async (section, key, value) => {
        try {
            const response = await fetch(`http://${currentAddress}/api/crud/config`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ section, key, value })
            });
            if (!response.ok) throw new Error("Failed to update config.");
            const result = await response.json();
            alert(result.message);
        } catch (error) {
            alert("Error: " + error.message);
        }
    };

    return (
        <div className="config-editor bg-white shadow-lg p-6 rounded-lg">
            <h2 className="text-2xl font-semibold text-center mb-4">Configuration</h2>
            <TransitionGroup>
                {Object.keys(config).map(section => (
                    <CSSTransition
                        key={section}
                        timeout={300}
                        classNames="fade"
                    >
                        <div className="config-section mb-6">
                            <h3 className="text-xl font-semibold mb-4">{section}</h3>
                            <table className="w-full border-collapse">
                                <tbody>
                                    {Object.entries(config[section]).map(([key, value]) => (
                                        <CSSTransition
                                            key={key}
                                            timeout={300}
                                            classNames="fade"
                                        >
                                            <tr>
                                                <td className="border p-2">{key}</td>
                                                <td className="border p-2">
                                                    <input
                                                        type="text"
                                                        defaultValue={value}
                                                        onBlur={(e) => handleChange(section, key, e.target.value)}
                                                        className="w-full p-2 border rounded-lg"
                                                    />
                                                </td>
                                            </tr>
                                        </CSSTransition>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    </CSSTransition>
                ))}
            </TransitionGroup>
        </div>
    );
}

export default ConfigEditor;
