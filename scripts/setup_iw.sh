#!/bin/bash

w_faces=()

for wface in $(iwconfig | cut -d ' ' -f1)
do
        w_faces+=("$wface")
done
# echo ${w_faces[@]}
# echo ${#w_faces[@]}

if [ ${#w_faces[@]} -eq 0 ];then

    echo "Available wi-fi iface not found"
else
    O_IW=$(./net_mode_monitor.sh -i ${w_faces[0]})
    echo ${O_IW}
fi




