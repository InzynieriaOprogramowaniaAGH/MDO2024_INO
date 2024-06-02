#!/bin/bash

DEPLOYMENT_NAME="my-nginx-app"
DEPLOYMENT_FILE="deployment.yaml"

CHECK_DURATION=60
INTERVAL=5

check_deployment() {
  minikube kubectl -- rollout status deployment/$DEPLOYMENT_NAME --timeout=${INTERVAL}s
  return $?
}

echo "Wdrażanie aplikacji za pomocą pliku $DEPLOYMENT_FILE..."
minikube kubectl -- apply -f $DEPLOYMENT_FILE

start_time=$(date +%s)

echo "Sprawdzanie wdrożenia $DEPLOYMENT_NAME przez $CHECK_DURATION sekund..."

while true; do
  check_deployment
  if [ $? -eq 0 ]; then
    echo "Wdrożenie $DEPLOYMENT_NAME zakończyło się sukcesem."
    exit 0
  fi

  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))

  if [ $elapsed_time -ge $CHECK_DURATION ]; then
    echo "Wdrożenie $DEPLOYMENT_NAME nie zakończyło się w ciągu $CHECK_DURATION sekund."
    exit 1
  fi

  sleep $INTERVAL
done