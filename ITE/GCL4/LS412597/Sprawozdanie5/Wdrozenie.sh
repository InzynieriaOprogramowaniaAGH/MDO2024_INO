#!/bin/bash

DEPLOYMENT_FILE="deployment.yaml"
DEPLOYMENT_NAME="error-take-note-app"
TIMEOUT_SECONDS=60
INTERVAL_SECONDS=5
TIME_PASSED=0

minikube kubectl -- apply -f $DEPLOYMENT_FILE

while [ $TIME_PASSED -lt $TIMEOUT_SECONDS ]; do
    STATUS=$(minikube kubectl -- get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.conditions[?(@.type=="Available")].status}')

    if [ "$STATUS" == "True" ]; then
        echo "Wdrożenie $DEPLOYMENT_NAME zostało zakończone pomyślnie."
        exit 0
    fi

    sleep $INTERVAL_SECONDS
    TIME_PASSED=$((TIME_PASSED + INTERVAL_SECONDS))
done

echo "Przekroczono limit czasu ($TIMEOUT_SECONDS sekund) oczekiwania na zakończenie wdrożenia $DEPLOYMENT_NAME."
exit 1
