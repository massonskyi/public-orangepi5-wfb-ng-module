#!/bin/bash

# Имя сетевого интерфейса (например, eth0)
INTERFACE="eth0"

# Проверка состояния сетевого интерфейса
if ip link show $INTERFACE | grep -q "state UP"; then
    # Если интерфейс активен, запускаем Python скрипты
    echo "Ethernet cable connected. Running Python scripts..."
    python3 /path/to/your/script1.py
    python3 /path/to/your/script2.py
else
    echo "Ethernet cable not connected."
fi
