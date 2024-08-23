import React, { useState, useEffect } from 'react';
import { CSSTransition, TransitionGroup } from 'react-transition-group';
import '../styles/ConfigEditor.css'; // Подключаем файл стилей

function ConfigEditor({ config, currentAddress, removeAddress }) {
    const [localConfig, setLocalConfig] = useState(config || {});
    const [openSections, setOpenSections] = useState(Object.keys(config || {}));
    const [editingSection, setEditingSection] = useState(null);
    const [editingKey, setEditingKey] = useState(null);
    const [newName, setNewName] = useState('');

    useEffect(() => {
        if (config) {
            setLocalConfig(config);
            setOpenSections(Object.keys(config));
        }
    }, [config]);

    const handleChange = (section, key, value) => {
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
                body: JSON.stringify({ config: localConfig }),
            });

            if (!response.ok) throw new Error("Failed to update config.");
            const result = await response.json();
            alert(result.message);
        } catch (error) {
            alert("Error: " + error.message);
        }
    };

    const handleRemoveSection = (section) => {
        setOpenSections(prevSections => prevSections.filter(s => s !== section));
        setLocalConfig(prevConfig => {
            const { [section]: _, ...rest } = prevConfig;
            return rest;
        });
    };

    const handleAddSection = () => {
        const newSection = `NewSection${Object.keys(localConfig).length + 1}`;
        setLocalConfig(prevConfig => ({
            ...prevConfig,
            [newSection]: {},
        }));
        setOpenSections(prevSections => [...prevSections, newSection]);
    };

    const handleAddKey = (section) => {
        const newKey = `NewKey${Object.keys(localConfig[section]).length + 1}`;
        setLocalConfig(prevConfig => ({
            ...prevConfig,
            [section]: {
                ...prevConfig[section],
                [newKey]: '',
            }
        }));
    };

    const handleEditSection = (section) => {
        setEditingSection(section);
        setNewName(section);
    };

    const handleEditKey = (key) => {
        setEditingKey(key);
        setNewName(key);
    };

    const handleRename = () => {
        if (editingSection !== null) {
            setLocalConfig(prevConfig => {
                const { [editingSection]: sectionData, ...rest } = prevConfig;
                return {
                    ...rest,
                    [newName]: sectionData,
                };
            });
            setOpenSections(prevSections => prevSections.map(s => s === editingSection ? newName : s));
            setEditingSection(null);
        }

        if (editingKey !== null) {
            const [section] = Object.entries(localConfig).find(([_, keys]) => editingKey in keys) || [];
            if (section) {
                setLocalConfig(prevConfig => ({
                    ...prevConfig,
                    [section]: {
                        ...prevConfig[section],
                        [newName]: prevConfig[section][editingKey],
                    }
                }));
                setEditingKey(null);
            }
        }

        setNewName('');
    };

    const getEditorClass = () => {
        if (config === null) return 'config-editor--default';
        return currentAddress === config ? 'config-editor--active' : 'config-editor--inactive';
    };

    return (
        <div className={`config-editor ${getEditorClass()}`}>
            <div className="config-editor__header">
                <h2>Current IP: {currentAddress}</h2>
                <button className="config-editor__remove" onClick={() => removeAddress(currentAddress)}>
                    &times;
                </button>
            </div>
            <TransitionGroup className="config-editors">
                {openSections.length > 0 && openSections.map(section => (
                    <CSSTransition key={section} timeout={300} classNames="fade">
                        <div className={`config-section ${currentAddress === config ? 'config-section--active' : 'config-section--default'}`}>
                            <div className="config-section__header">
                                {editingSection === section ? (
                                    <input
                                        type="text"
                                        value={newName}
                                        onChange={(e) => setNewName(e.target.value)}
                                        onBlur={handleRename}
                                        autoFocus
                                    />
                                ) : (
                                    <h3
                                        className="config-section__title"
                                        onDoubleClick={() => handleEditSection(section)}
                                    >
                                        {section}
                                    </h3>
                                )}
                                <button
                                    className="config-section__remove"
                                    onClick={() => handleRemoveSection(section)}
                                >
                                    &times;
                                </button>
                            </div>
                            <table className="config-section__table">
                                <tbody>
                                    {Object.entries(localConfig[section] || {}).map(([key, value]) => (
                                        <CSSTransition key={key} timeout={300} classNames="fade">
                                            <tr className="config-section__row">
                                                <td
                                                    className={`config-section__key ${currentAddress === config ? 'config-section__key--active' : 'config-section__key--default'}`}
                                                    onDoubleClick={() => handleEditKey(key)}
                                                >
                                                    {editingKey === key ? (
                                                        <input
                                                            type="text"
                                                            value={newName}
                                                            onChange={(e) => setNewName(e.target.value)}
                                                            onBlur={handleRename}
                                                            autoFocus
                                                        />
                                                    ) : (
                                                        key
                                                    )}
                                                </td>
                                                <td className="config-section__value">
                                                    <input
                                                        type="text"
                                                        value={value}
                                                        onChange={(e) => handleChange(section, key, e.target.value)}
                                                        className="config-section__input"
                                                    />
                                                </td>
                                            </tr>
                                        </CSSTransition>
                                    ))}
                                    <tr>
                                        <td colSpan="2">
                                            <button onClick={() => handleAddKey(section)} className="config-section__add-key">
                                                + Add Key
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </CSSTransition>
                ))}
            </TransitionGroup>
            <button onClick={handleAddSection} className="config-editor__add-section">
                + Add Section
            </button>
            <button onClick={handleSave} className="config-editor__button">Save Config</button>
        </div>
    );
}

export default ConfigEditor;
