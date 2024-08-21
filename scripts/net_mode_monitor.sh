#!/bin/bash

while getopts i: flag
do
    case "${flag}" in
        i) iface=${OPTARG};;
    esac
done

ip link set ${iface} down
iwconfig ${iface} mode monitor
ip link set ${iface} up

O_IW=$(iwconfig)

echo ${O_IW}
