#!/bin/bash

DEPLOYMENT_NAME="nginx-deployment"
TIMEOUT=60
INTERVAL=10

# alias
kubectl() {
  minikube kubectl -- "$@"
}

# IF no arugment - EXIT
if [ -z "$1" ]; then
  echo "ERR: $0 skrypt powinnien miec arugment"
  exit 1
fi

DEPLOYMENT_FILE=$1

# Apply deployment
kubectl apply -f $DEPLOYMENT_FILE

start_time=$(date +%s)

for (( i=0; i<TIMEOUT; i+=INTERVAL )); do
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))
  elapsed_formatted=$(date -u -d @$elapsed_time +%H:%M:%S)

  echo "In Progress - Time Passed: $elapsed_formatted"
  
  READY_PODS=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.readyReplicas}')
  TOTAL_PODS=$(kubectl get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.replicas}')
  
  if [[ "$READY_PODS" -eq "$TOTAL_PODS" ]]; then
    echo "Wdrożenie SUCCESSFUL"
    echo "Time spent: $elapsed_formatted"
    exit 0
  fi
  
  sleep $INTERVAL
done

elapsed_time=$(( $(date +%s) - start_time ))
elapsed_formatted=$(date -u -d @$elapsed_time +%H:%M:%S)

echo "ERR: spent to much time: $elapsed_formatted."
exit 1
