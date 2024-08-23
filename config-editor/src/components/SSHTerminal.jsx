import React, { useEffect, useRef, useState } from 'react';
import { Terminal } from 'xterm';
import 'xterm/css/xterm.css';

function SSHTerminal({ currentAddress }) {
    const terminalRef = useRef(null);
    const terminal = useRef(null);
    const [isTerminalCreated, setIsTerminalCreated] = useState(false);

    useEffect(() => {
        if (currentAddress && !isTerminalCreated) {
            terminal.current = new Terminal();
            terminal.current.open(terminalRef.current);
            setIsTerminalCreated(true);
        }

        if (currentAddress) {
            const ws = new WebSocket(`ws://${currentAddress}/ws/ssh`);

            ws.onopen = () => {
                terminal.current.write('SSH connection established\r\n');
            };

            ws.onmessage = (event) => {
                terminal.current.write(event.data);
            };

            ws.onclose = () => {
                terminal.current.write('SSH connection closed\r\n');
            };

            terminal.current.onData((data) => {
                const message = JSON.stringify({ address: currentAddress, command: data });
                ws.send(message);
            });

            return () => {
                ws.close();
            };
        }
    }, [currentAddress, isTerminalCreated]);

    if (!currentAddress) {
        return null;
    }

    return <div ref={terminalRef} style={{ width: '100%', height: '100vh' }} />;
}

export default SSHTerminal;
