#!/bin/bash

# Sprawdzenie istnienia pliku blokady
if [ -f file_lock ]; then
    echo "Wdrozenie jest juz uruchomione"
    exit 1
else
    touch file_lock
    echo "Wdrozenie rozpoczete"

    # Rozpoczecie wdrozenia
    kubectl apply -f deployment.yml

    # Czekanie 60s
    sleep 60

    # Sprawdzenie czy wrozenie sie wykonalo
    if kubectl get pods -l app=nginx | grep Running; then
        echo "Wdrozenie zajelo mnij niz minute"
    else
        echo "Wdrożenie nie zostalo wykonane w ciagu minuty"
    fi

    # Zakonczenie wdrozenia
    rm file_lock
    exit 0
fi