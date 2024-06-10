#!/bin/bash

# Nazwa wdrożenia
DEPLOYMENT_NAME="nginx-deployment"
NAMESPACE="default"  # Możesz zmienić namespace, jeśli nie jest default

# Czas oczekiwania w sekundach
TIMEOUT=60
INTERVAL=5

# Funkcja sprawdzająca status wdrożenia
check_deployment_status() {
  minikube kubectl -- rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE
}

# Główna logika skryptu
echo "Sprawdzanie statusu wdrożenia $DEPLOYMENT_NAME"

start_time=$(date +%s)
end_time=$((start_time + TIMEOUT))

while true; do
  current_time=$(date +%s)
  
  if check_deployment_status; then
    echo "Wdrożenie $DEPLOYMENT_NAME zakończone powodzeniem"
    exit 0
  fi
  
  if [ $current_time -ge $end_time ]; then
    echo "Czas oczekiwania na wdrożenie $DEPLOYMENT_NAME upłynął"
    exit 1
  fi
  
  echo "Wdrożenie $DEPLOYMENT_NAME w toku, oczekiwanie..."
  sleep $INTERVAL
done
