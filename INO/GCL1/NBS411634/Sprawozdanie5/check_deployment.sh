#!/bin/bash

DEPLOYMENT_NAME="deployment"
NAMESPACE="default"
TIMEOUT=60
INTERVAL=5

check_deployment() {
  READY=$(minikube kubectl -- get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o jsonpath='{.statu>
  DESIRED=$(minikube kubectl -- get deployment "$DEPLOYMENT_NAME" -n "$NAMESPACE" -o jsonpath='{.sta>
  
  if [ "$READY" == "$DESIRED" ]; then
    return 0
  else
    return 1
  fi
}

elapsed=0
while [ $elapsed -lt $TIMEOUT ]; do
  if check_deployment; then
    echo "Deployment $DEPLOYMENT_NAME successfully deployed."
    exit 0
  fi
  sleep $INTERVAL
  elapsed=$((elapsed + INTERVAL))
done

echo "Deployment $DEPLOYMENT_NAME did not complete within $TIMEOUT seconds."
exit 1

