#!/bin/bash

DEPLOYMENT_FILE="tdwapod.yaml"
DEPLOYMENT_NAME="tdwa"
TIMEOUT_SECONDS=60
INTERVAL_SECONDS=5
TIME_PASSED=0

minikube kubectl -- apply -f $DEPLOYMENT_FILE

while [ $TIME_PASSED -lt $TIMEOUT_SECONDS ]; do
    STATUS=$(minikube kubectl -- get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.conditions[?(@.type=="Available")].status}')

    if [ "$STATUS" == "True" ]; then
        echo "Deployment $DEPLOYMENT_NAME succeded."
        exit 0
    fi

    sleep $INTERVAL_SECONDS
    TIME_PASSED=$((TIME_PASSED + INTERVAL_SECONDS))
done

echo "Timeout ($TIMEOUT_SECONDS s) pending for deploy $DEPLOYMENT_NAME."
exit 1
