#!/bin/bash

DEPLOYMENT_NAME="nginx-deploy"

CHECK_DURATION=60
INTERVAL=1

start_time=$(date +%s)

echo "Checking deployment $DEPLOYMENT_NAME for $CHECK_DURATION seconds..."

while true; do
  minikube kubectl -- rollout status deployment/$DEPLOYMENT_NAME --timeout=${INTERVAL}s
  if [ $? -eq 0 ]; then
    echo "Deployment $DEPLOYMENT_NAME completed successfully."
    exit 0
  fi

  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))

  if [ $elapsed_time -ge $CHECK_DURATION ]; then
    echo "Deployment $DEPLOYMENT_NAME did not complete within $CHECK_DURATION seconds."
    exit 1
  fi

  sleep $INTERVAL
done
