#!/bin/bash

DEPLOYMENT_NAME="deployment"
TIMEOUT=60

minikube kubectl -- apply -f ./deployment.yaml

minikube kubectl get deployments 

if minikube kubectl -- rollout status deployment/$DEPLOYMENT_NAME --timeout=${TIMEOUT}s > /dev/null 2>&1; then
echo "Success! Deployment rolled out."
exit 0
else
echo "Error. Deployment did not complete."
exit 1
fi
