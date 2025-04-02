for i in {1..10000}; do
    ./ruleta.sh -m 1000 -t martingala >> martin_gala_results.txt
done

resultado=$(cat martin_gala_results.txt | grep "Dinero final:" | tr -d "€" | awk '{print $NF}' | awk '{sum += $1} END {print sum}')

echo "Después de mil veces jugadas el resultado es de $resultado"

rm martin_gala_results.txt