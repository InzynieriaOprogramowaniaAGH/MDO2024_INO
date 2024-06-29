#!/bin/bash

DEPLOYMENT_NAME="my-nginx-deployment"
NAMESPACE="default"
TIMEOUT=60
INTERVAL=5

# Sprawdzenie, czy wdrożenie istnieje
kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Deployment $DEPLOYMENT_NAME not found in namespace $NAMESPACE"
    exit 3
fi

end=$((SECONDS+TIMEOUT))

while [ $SECONDS -lt $end ]; do
    kubectl rollout status deployment/$DEPLOYMENT_NAME -n $NAMESPACE
    status=$?
    if [ $status -eq 0 ]; then
        echo "Deployment succeeded"
        exit 0
    elif [ $status -ne 0 ]; then
        echo "Waiting for deployment to complete..."
        # Sprawdzanie statusu replik
        replicas=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.replicas}')
        updated_replicas=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.updatedReplicas}')
        available_replicas=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.availableReplicas}')
        unavailable_replicas=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o jsonpath='{.status.unavailableReplicas}')
        echo "Replicas: $replicas, Updated: $updated_replicas, Available: $available_replicas, Unavailable: $unavailable_replicas"
    fi
    sleep $INTERVAL
done

echo "Deployment did not complete within the timeout period"
echo "Fetching details for debugging..."
kubectl describe deployment $DEPLOYMENT_NAME -n $NAMESPACE

echo "Initiating rollback to the previous version"
kubectl rollout undo deployment/$DEPLOYMENT_NAME -n $NAMESPACE
if [ $? -eq 0 ]; then
    echo "Rollback succeeded"
    exit 1
else
    echo "Rollback failed"
    exit 2
fi
