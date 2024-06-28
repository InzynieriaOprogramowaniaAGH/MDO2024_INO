#!/bin/bash

# Nazwa wdrożenia
DEPLOYMENT_NAME="my-app-deployment"

# Czas oczekiwania na wdrożenie w sekundach
TIMEOUT=60

# Początkowy czas (w sekundach od epoki)
START_TIME=$(date +%s)

# Pętla sprawdzająca stan wdrożenia
while true; do
    # Aktualny czas
    CURRENT_TIME=$(date +%s)

    # Oblicz różnicę czasu
    ELAPSED_TIME=$(($CURRENT_TIME - $START_TIME))

    # Przerwij pętlę, jeśli przekroczono limit czasu
    if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
        echo "Timeout reached: Deployment has not completed within ${TIMEOUT} seconds."
        exit 1
    fi

    # Sprawdź status wdrożenia
    if kubectl rollout status deployment/$DEPLOYMENT_NAME --timeout=${TIMEOUT}s; then
        echo "Deployment has successfully rolled out!"
        exit 0
    fi

    # Czekaj 5 sekund przed kolejnym sprawdzeniem
    sleep 5
done
