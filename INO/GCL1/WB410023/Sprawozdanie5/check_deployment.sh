#!/bin/bash

DEPLOYMENT_NAME="react-app"
NAMESPACE="default"

TIMEOUT=60
INTERVAL=5

check_deployment() {
  kubectl rollout status deployment/${DEPLOYMENT_NAME} --namespace=${NAMESPACE} --timeout=${INTERVAL}s
  return $?
}

START_TIME=$(date +%s)

while true; do
  check_deployment
  STATUS=$?

  if [ $STATUS -eq 0 ]; then
    echo "Deployment ${DEPLOYMENT_NAME} has successfully rolled out."
    exit 0
  fi

  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

  if [ $ELAPSED_TIME -ge $TIMEOUT ]; then
    echo "Timeout of ${TIMEOUT} seconds reached. Deployment ${DEPLOYMENT_NAME} did not roll out successfully."
    exit 1
  fi

  echo "Waiting for deployment ${DEPLOYMENT_NAME} to roll out..."
  sleep $INTERVAL
done
