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

function martingala() {
    echo -e "\n Dinero actual: ${money}€"
    echo -ne "¿Cuanto dinero quieres apostar? -> " && read initial_bet
    echo -ne "¿Quieres jugar a par o impar? -> " && read par_impar

    if [ "$par_impar" = "par" ]; then
        mi_jugada=0
    else
        mi_jugada=1
    fi

    echo "Jugando apuesta inicial de ${initial_bet}€ a la jugada $par_impar"

    max_money=$((2 * $money))

    let -i counter=0

    while [ $money -ge 0 ] && [ $money -le $max_money ]; do
        tirada=$(($RANDOM % 37))

        if [ $(($tirada % 2)) -eq $mi_jugada ]; then
            money=$((money + $initial_bet))
        else
            money=$((money - $initial_bet))
            initial_bet=$(($initial_bet * 2))
        fi
        counter=$(($counter + 1))
        echo -e "Tirada número: $counter, Apuesta actual: $initial_bet, Dinero actual: ${money}€"
    done

    echo -e "\n Fin del juego.\n"
    echo -e "Dinero final: ${money}€\n"
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
    if [ "$technique" == "martingala" ]; then
        martingala
    else
        echo "Técnica no válida. Saliendo..."
        exit 1
    fi
fi