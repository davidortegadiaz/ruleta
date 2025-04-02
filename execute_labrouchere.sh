for i in {1..10000}; do
    ./ruleta.sh -m 1000 -t labrouchere >> labrouchere_results.txt
done

resultado=$(cat labrouchere_results.txt | grep "Dinero final:" | tr -d "€" | awk '{print $NF}' | awk '{sum += $1} END {print sum}')

echo "Después de mil veces jugadas el resultado es de $resultado"

rm labrouchere_results.txt