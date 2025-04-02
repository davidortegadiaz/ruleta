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
    echo -ne "¿Cuanto dinero quieres apostar? -> " && initial_bet=10
    echo -ne "¿Quieres jugar a par o impar? -> " && par_impar="par"

    if [ "$par_impar" = "par" ]; then
        mi_jugada=0
    else
        mi_jugada=1
    fi

    echo "Jugando apuesta inicial de ${initial_bet}€ a la jugada $par_impar"

    max_money=$((2 * $money))

    counter=0

    while [ $money -gt 0 ] && [ $money -le $max_money ]; do
        tirada=$(($RANDOM % 37))

        if [ $tirada -eq 0 ]; then
             money=$(($money - $initial_bet))
            if [ $money -ge $(($initial_bet * 2)) ]; then
                initial_bet=$(($initial_bet * 2))
            else
                initial_bet=$money
            fi
        fi

        if [ $(($tirada % 2)) -eq $mi_jugada ]; then
            money=$(($money + $initial_bet))
        else
            money=$(($money - $initial_bet))
            if [ $money -ge $(($initial_bet * 2)) ]; then
                initial_bet=$(($initial_bet * 2))
            else
                initial_bet=$money
            fi
        fi
        counter=$(($counter + 1))
        echo -e "\n\nTirada número: $counter"
        echo -e "Apuesta actual: $initial_bet"
        echo -e "Dinero actual: ${money}€"
        echo -e "Ha salido el: $tirada"
    done

    echo -e "\n Fin del juego.\n"
    final_money=$(($money - 1000))
    echo -e "Dinero final: ${final_money}€\n"
    if [ $money -ge $max_money ]; then
        echo "Has ganado"
    else
        echo "Has perdido"
    fi
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