#!/bin/bash

DEPLOYMENT_NAME="nginx-deployment"
TIMEOUT=60
minikube kubectl -- apply -f ./nginx-deployment.yaml

echo "Czekam $TIMEOUT sekund..."
sleep $TIMEOUT

status=$(minikube kubectl rollout status deployment "$DEPLOYMENT_NAME" 2>&1)

if [[ "$status" == *"successfully"* ]]; then
    echo "Wdrożenie zakończone pomyślnie."
    minikube kubectl rollout status deployment "$DEPLOYMENT_NAME"
    exit 0
else
    echo "Wdrożenie nie powiodło się."
    minikube kubectl rollout history deployment/"$DEPLOYMENT_NAME"
    exit 1
fi
