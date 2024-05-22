#!/bin/bash

MAX_WAIT_TIME=60
DEPLOYMENT_NAME="redis-deployment"
DEPLOYMENT_FILE="/home/michaljurzak/repo/MDO2024_INO/INO/GCL1/MJ410315/Sprawozdanie5/redis_deploy.yml"

minikube kubectl -- apply -f $DEPLOYMENT_FILE

minikube kubectl -- rollout status deployment/$DEPLOYMENT_NAME --timeout=${MAX_WAIT_TIME}s
ROLLOUT_STATUS=$?

START_TIME=$(date +%s)
END_TIME=$(date +%s)
ELAPSED_TIME=$((END_TIME - START_TIME))

if [[ $ROLLOUT_STATUS -eq 0 ]]; then
  echo "Deployment successfully rolled out in $ELAPSED_TIME seconds."
  exit 0
else
  echo "Deployment did not roll out within $MAX_WAIT_TIME seconds."
  exit 1
fi
