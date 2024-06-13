#!/bin/bash

deployment_name="mynode-deployment"
max_seconds=60
wait=5

echo "Waiting for deployment to finish rolling out..."

while [ $SECONDS -lt $max_seconds ]; do
    
    rollout_status=$(kubectl rollout status deployment $deployment_name 2>&1)

    if [[ $rollout_status == *"successfully rolled out"* ]]; then
        echo "Deployment successfully rolled out."
        exit 0
    fi

    sleep $wait
done

echo "Timeout: Deployment did not finish rolling out within $max_seconds seconds."
exit 1