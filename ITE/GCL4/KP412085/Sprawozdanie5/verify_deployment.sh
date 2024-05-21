#!/bin/bash

DEPLOYMENT_NAME=""
NAMESPACE="default"
TIMEOUT=60
SLEEP_INTERVAL=5

for arg in "$@"
do
    eval "$arg"
done

ELAPSED_TIME=0

if [[ -z "$DEPLOYMENT_NAME" ]]; then
    echo "DEPLOYMENT_NAME needs to be specified"
    exit 1
fi

echo "Starting to monitor deployment '$DEPLOYMENT_NAME' in namespace '$NAMESPACE' for up to $TIMEOUT seconds..."

while [[ $ELAPSED_TIME -lt $TIMEOUT ]]; do 
    READY_REPLICAS=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.updatedReplicas}')
    DESIRED_REPLICAS=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.spec.replicas}')

    if [[ $READY_REPLICAS -eq $DESIRED_REPLICAS ]]; then
        echo "Deployment '$DEPLOYMENT_NAME' successfully deployed with all $DESIRED_REPLICAS replicas ready."
        exit 0
    fi

    echo "Waiting for deployment, current state: $READY_REPLICAS/$DESIRED_REPLICAS    ($ELAPSED_TIME seconds elapsed)"
    sleep $SLEEP_INTERVAL
    ELAPSED_TIME=$((ELAPSED_TIME + SLEEP_INTERVAL))

done 

echo "Timeout of $TIMEOUT seconds reached. Deployment '$DEPLOYMENT_NAME' did not complete successfully. Rolling back to previous version"
kubectl rollout undo deployment $DEPLOYMENT_NAME
exit 1
