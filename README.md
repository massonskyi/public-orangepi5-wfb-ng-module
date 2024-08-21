# WFB-NG Module for orangepi5b with wifi adapter TP-LINK and REALTEK

Модуль **передачи видеоизображения через WIFI**

# INSTALL
## 1. Run installer in scripts dir

**Installer** **устанавливает необходимые пакеты в систему**, **собирает приложение** и **устанавливает драйвер** на wifi адаптер

## 2. Run system-include --r (receive) or --s (sender) in scripts dir

**System-include** встраивает выбранное приложение(Передатчик (**sender**) или приемник(**receive**))

## 3. Add the rx_stream.sh in autorun in your system receive


# Run
git clone (Репозиторий)[]
cd scripts
sudo ./install.sh

cd ../build && sudo ./VideoTx | VideoRx "**Name WIFI**"

cd ../scripts && ./tx_stream_x264.sh | ./rx_stream_x264.sh 