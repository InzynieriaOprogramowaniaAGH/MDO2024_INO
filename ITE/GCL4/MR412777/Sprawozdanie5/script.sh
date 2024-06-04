#!/bin/bash

DEPLOYMENT_NAME="error-deploy"
TIMEOUT=60
INTERVAL=5

MAX_TRIES=$(( TIMEOUT / INTERVAL ))

for (( i=0; i<MAX_TRIES; i++ )); do
  echo "Status wdrożenia - próba $((i+1))/$MAX_TRIES"
  
  READY_PODS=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.readyReplicas}')
  TOTAL_PODS=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.replicas}')
  
  if [[ "$READY_PODS" -eq "$TOTAL_PODS" ]]; then
    echo "Wdrożenie $DEPLOYMENT_NAME zakończyło się w czasie $TIMEOUT s"
    exit 0
  fi
  
  sleep $INTERVAL
done

echo "Wdrożenie $DEPLOYMENT_NAME nie zakończyło się w czasie $TIMEOUT s."
exit 1
