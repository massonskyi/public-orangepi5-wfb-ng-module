import React, { useState, useEffect } from 'react';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import '../styles/ConfigEditor.css';

function ConfigEditor({ config, currentAddress, refreshConfig }) {
    const [localConfig, setLocalConfig] = useState(config);

    // Обновляем локальную копию конфигурации, когда config меняется
    useEffect(() => {
        setLocalConfig(config);
    }, [config]);

    const handleChange = (section, key, value) => {
        // Обновляем локальную копию конфигурации в состоянии
        setLocalConfig(prevConfig => ({
            ...prevConfig,
            [section]: {
                ...prevConfig[section],
                [key]: value,
            }
        }));
    };

    const handleSave = async () => {
        try {
            const response = await fetch(`http://${currentAddress}/api/crud/config`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(localConfig),
            });

            if (!response.ok) throw new Error("Failed to update config.");
            const result = await response.json();
            alert(result.message);

            // Обновляем конфигурацию на сервере и в приложении
            refreshConfig();  // Вызываем refreshConfig для обновления конфигурации с сервера
        } catch (error) {
            alert("Error: " + error.message);
        }
    };

    return (
        <div className="config-editor">
            <h2>Current IP: {currentAddress}</h2>
            <TransitionGroup>
                {Object.keys(localConfig).map(section => (
                    <CSSTransition key={section} timeout={300} classNames="fade">
                        <div className="config-section">
                            <h3>{section}</h3>
                            <table>
                                <tbody>
                                    {Object.entries(localConfig[section]).map(([key, value]) => (
                                        <CSSTransition key={key} timeout={300} classNames="fade">
                                            <tr>
                                                <td>{key}</td>
                                                <td>
                                                    <input
                                                        type="text"
                                                        value={value}
                                                        onChange={(e) => handleChange(section, key, e.target.value)}
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
            <button onClick={handleSave}>Save Config</button>
        </div>
    );
}

export default ConfigEditor;
