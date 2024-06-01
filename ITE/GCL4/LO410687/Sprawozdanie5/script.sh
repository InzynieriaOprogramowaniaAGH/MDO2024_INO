#!/bin/bash

DEPLOYMENT_NAME="game-deploy"
NAMESPACE="default" 
TIMEOUT=60
INTERVAL=5

end=$((SECONDS + TIMEOUT))

while [ $SECONDS -lt $end ]; do
    READY_REPLICAS=$(kubectl get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o jsonpath='{.status.readyReplicas}')
    REPLICAS=$(kubectl get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o jsonpath='{.status.replicas}')

    echo "Ready replicas: ${READY_REPLICAS}/${REPLICAS}"

    if [ "$READY_REPLICAS" == "$REPLICAS" ]; then
        echo "Deployment $DEPLOYMENT_NAME is successfully rolled out on time."
        exit 0
    fi

    sleep $INTERVAL
done

echo "Deployment $DEPLOYMENT_NAME did not roll out within ${TIMEOUT} seconds"
exit 1