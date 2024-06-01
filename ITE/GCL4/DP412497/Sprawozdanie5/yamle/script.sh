#!/bin/bash
  # Nazwa wdrożenia
  DEPLOYMENT_NAME="my-nginx"
  NAMESPACE="default"
  TIMEOUT=60

  # Sprawdzenie stanu wdrożenia
  start_time=$(date +%s)

  while true; do
      # Pobranie liczby gotowych replik
      ready_replicas=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.readyReplicas}')

      # Pobranie całkowitej liczby replik
      replicas=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.replicas}')

      # Sprawdzenie, czy wszystkie repliki są gotowe
      if [[ "$ready_replicas" == "$replicas" ]]; then
          echo "Wdrożenie $DEPLOYMENT_NAME zakończone pomyślnie."
          exit 0
      fi

      # Sprawdzenie, czy przekroczono czas oczekiwania
      current_time=$(date +%s)
      elapsed_time=$((current_time - start_time))
      if [[ "$elapsed_time" -ge "$TIMEOUT" ]]; then
          echo "Wdrożenie $DEPLOYMENT_NAME nie zakończyło się w ciągu $TIMEOUT sekund."
          exit 1
      fi

      # Odczekanie 5 sekund przed kolejną kontrolą
      sleep 5
  done