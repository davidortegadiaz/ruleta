#!/bin/bash

function control_c() {
    echo "Saliendo ..."
    exit 1
}

trap control_c INT

function helpPanel() {
    echo -e "\n Uso: $0"
    echo -e "\t -m Dinero con el que desea jugar\n"
    echo -e "\t -t Técnica que desea emplear\n"
}

while getopts "m:t:h" arg; do
    case $arg in
        m) money=$OPTARG;;
        t) technique=$OPTARG;;
        h) helpPanel;;
    esac
done

if [ ! $money ] || [ ! $technique ]; then
    helpPanel
else 
    echo "Voy a jugar con $money euros y usar la técnica $technique"
fi