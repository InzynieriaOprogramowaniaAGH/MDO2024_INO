#!/bin/bash

DEPLOYMENT_NAME="nginx-deployment"
NAMESPACE="default"
TIMEOUT=60
INTERVAL=5

check_deployment() {
    kubectl get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o jsonpath='{.status.conditions[?(@.type=="Available")].status}'
}

echo "Sprawdzanie statusu wdrożenia '$DEPLOYMENT_NAME' w przestrzeni nazw '$NAMESPACE'..."

START_TIME=$(date +%s)
while true; do
    STATUS=$(check_deployment)
    
    if [ "$STATUS" == "True" ]; then
        echo "Wdrożenie '$DEPLOYMENT_NAME' zostało pomyślnie zakończone."
        exit 0
    fi

    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))
    
    if [ "$ELAPSED_TIME" -ge "$TIMEOUT" ]; then
        echo "Wdrożenie '$DEPLOYMENT_NAME' nie zakończyło się w ciągu $TIMEOUT sekund."
        exit 1
    fi

    echo "Wdrożenie w toku... (upłynęło $ELAPSED_TIME sekund)"
    sleep "$INTERVAL"
done
