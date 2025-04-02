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

function labrouchere() {
    echo -e "\n Dinero actual: ${money}€"
    
    # Leer la elección del usuario
    par_impar="par"

    declare -a sequence=(1 2 3 4)

    echo -e "\n Secuencia inicial: ${sequence[@]}"

    # Validar la elección del usuario
    if [ "$par_impar" = "par" ]; then
        mi_jugada=0
    else
        mi_jugada=1
    fi

    echo "Jugando a la jugada $par_impar"

    max_money=$((2 * money))

    counter=0

    while [ "$money" -gt 0 ] && [ "$money" -le "$max_money" ]; do
        tirada=$((RANDOM % 37))

        jugada=0

        # Determinar cantidad a apostar
        if [ ${#sequence[@]} -eq 1 ]; then
            jugada="${sequence[0]}"
        else
            jugada=$((sequence[0] + sequence[${#sequence[@]}-1]))
            echo "Jugamos con $jugada"
        fi

        # Si sale 0, se pierde la apuesta
        if [ "$tirada" -eq 0 ]; then
            money=$((money - jugada))
        elif [ $((tirada % 2)) -eq "$mi_jugada" ]; then
            # Se gana la apuesta
            money=$((money + jugada))
            sequence+=("$jugada")
        else
            # Se pierde la apuesta
            money=$((money - jugada))

            # Eliminar el primer y último elemento del array si hay más de uno
            if [ ${#sequence[@]} -gt 2 ]; then
                sequence=("${sequence[@]:1:${#sequence[@]}-2}")
            else
                sequence=(1 2 3 4)
            fi
        fi

        counter=$((counter + 1))

        echo -e "\n Secuencia: ${sequence[@]}"
        echo -e "\n\nTirada número: $counter"
        echo -e "Apuesta actual: $jugada"
        echo -e "Dinero actual: ${money}€"
        echo -e "Ha salido el: $tirada"

        # Límite de seguridad para evitar bucles infinitos
        if [ "$counter" -ge 1000 ]; then
            echo "Límite de tiradas alcanzado. Terminando el juego."
            break
        fi

        sleep 0.4
    done

    echo -e "\n Fin del juego.\n"
    final_money=$((money - 1000))  # Asegurar que el cálculo final tenga sentido
    echo -e "Dinero final: ${final_money}€\n"

    if [ "$money" -ge "$max_money" ]; then
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
    elif [ "$technique" == "labrouchere" ]; then
        labrouchere
    else
        echo "Técnica no válida. Saliendo..."
        exit 1
    fi
fi