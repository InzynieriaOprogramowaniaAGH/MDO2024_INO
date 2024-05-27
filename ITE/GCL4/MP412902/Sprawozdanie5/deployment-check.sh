#!/bin/bash

# Nazwa wdrożenia do monitorowania
DEPLOYMENT_NAME="utt-deployer"

# Maksymalny czas oczekiwania (w sekundach)
MAX_WAIT_TIME=60

# Początkowy czas
START_TIME=$(date +%s)

# Funkcja sprawdzająca status wdrożenia
check_deployment_status() {
    STATUS=$(minikube kubectl -- rollout status deployment/${DEPLOYMENT_NAME} --watch=false)
    echo "${STATUS}"
}

# Pętla sprawdzająca status co 1 sekundę
while true; do
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

    # Sprawdzenie, czy upłynął maksymalny czas oczekiwania
    if [[ ${ELAPSED_TIME} -ge ${MAX_WAIT_TIME} ]]; then
        echo "Czas oczekiwania przekroczony (${MAX_WAIT_TIME} sekund)"
        exit 1
    fi

    # Sprawdzenie statusu wdrożenia
    DEPLOYMENT_STATUS=$(check_deployment_status)

    # Sprawdzenie, czy wdrożenie zostało zakończone sukcesem
    if [[ "${DEPLOYMENT_STATUS}" == *"successfully rolled out"* ]]; then
        echo "Wdrożenie ${DEPLOYMENT_NAME} zakończone sukcesem w ciągu ${ELAPSED_TIME} sekund"
        exit 0
    fi

    # Oczekiwanie 1 sekundę przed kolejnym sprawdzeniem
    sleep 1
done
