import React from 'react';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import '../styles//ConfigEditor.css'; // Ensure the path is correct

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
        <div className="config-editor">
            <h2>Configuration</h2>
            <TransitionGroup>
                {Object.keys(config).map(section => (
                    <CSSTransition
                        key={section}
                        timeout={300}
                        classNames="fade"
                    >
                        <div className="config-section">
                            <h3>{section}</h3>
                            <table>
                                <tbody>
                                    {Object.entries(config[section]).map(([key, value]) => (
                                        <CSSTransition
                                            key={key}
                                            timeout={300}
                                            classNames="fade"
                                        >
                                            <tr>
                                                <td>{key}</td>
                                                <td>
                                                    <input
                                                        type="text"
                                                        defaultValue={value}
                                                        onBlur={(e) => handleChange(section, key, e.target.value)}
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
