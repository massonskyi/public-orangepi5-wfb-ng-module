import React, { useState } from 'react';

function LogsViewer({ currentAddress }) {
    const [logs, setLogs] = useState('');
    const [error, setError] = useState(null);

    const fetchLogs = async (filename) => {
        try {
            const response = await fetch(`http://${currentAddress}/api/sys/api/logs?filename=${filename}`);
            if (!response.ok) throw new Error("Failed to fetch logs.");
            const data = await response.text();
            setLogs(data);
        } catch (err) {
            setError(err.message);
        }
    };

    return (
        <div>
            <button onClick={() => fetchLogs('fastapi_server.log')}>View FastAPI Logs</button>
            <button onClick={() => fetchLogs('npm_server.log')}>View NPM Logs</button>
            {error && <p>Error: {error}</p>}
            <pre style={{ background: '#f0f0f0', padding: '1rem', maxHeight: '400px', overflowY: 'scroll' }}>
                {logs}
            </pre>
        </div>
    );
}

export default LogsViewer;