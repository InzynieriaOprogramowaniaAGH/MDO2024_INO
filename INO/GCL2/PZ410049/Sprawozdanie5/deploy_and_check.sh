#!/bin/bash

DEPLOYMENT_FILE="java-deployment.yaml"
DEPLOYMENT_NAME="java-deployment"
TIMEOUT=60
START_TIME=$(date +%s)

check_rollout_status() {
  kubectl rollout status deployment/${DEPLOYMENT_NAME}
  return $?
}

kubectl apply -f ${DEPLOYMENT_FILE}
if [ $? -ne 0 ]; then
  echo "Deployment failed during kubectl apply"
  exit 1
fi

while true; do
  if check_rollout_status; then
    CURRENT_TIME=$(date +%s)
    ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

    if [ ${ELAPSED_TIME} -lt ${TIMEOUT} ]; then
      echo "Deployment ${DEPLOYMENT_NAME} successfully rolled out in ${ELAPSED_TIME} seconds"
      exit 0
    else
      echo "Deployment ${DEPLOYMENT_NAME} successfully rolled out but took longer than ${TIMEOUT} seconds"
      exit 1
    fi
  fi

  CURRENT_TIME=$(date +%s)
  ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

  if [ ${ELAPSED_TIME} -ge ${TIMEOUT} ]; then
    echo "Timeout of ${TIMEOUT} seconds reached. Deployment ${DEPLOYMENT_NAME} did not roll out successfully."
    exit 1
  fi

  echo "Waiting for deployment ${DEPLOYMENT_NAME} to roll out... (${ELAPSED_TIME}s elapsed)"
  sleep 5
done

