#!/bin/bash

DEPLOYMENT_NAME="failer-deployment"
TIMEOUT_SECONDS=60
INTERVAL_SECONDS=5
TIME_PASSED=0

while [ $TIME_PASSED -lt $TIMEOUT_SECONDS ]; do
    STATUS=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.conditions[?(@.type=="Available")].status}')

    if [ "$STATUS" == "True" ]; then
        echo "Deployment $DEPLOYMENT_NAME zostało wdrożone."
        exit 0
    fi

    sleep $INTERVAL_SECONDS
    TIME_PASSED=$((TIME_PASSED + INTERVAL_SECONDS))
done

echo "Przekroczono limit czasu ($TIMEOUT_SECONDS sekund) oczekiwania na wdrożenie $DEPLOYMENT_NAME."
exit 1