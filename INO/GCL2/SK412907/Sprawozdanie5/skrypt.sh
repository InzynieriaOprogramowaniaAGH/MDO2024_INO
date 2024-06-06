#!/bin/bash

DEPLOYMENT_NAME="node-deployment"
TIMEOUT=60

minikube kubectl -- apply -f node-deployment.yaml

minikube kubectl get deployments 

if minikube kubectl -- rollout status deployment/$DEPLOYMENT_NAME --timeout=${TIMEOUT}s > /dev/null 2>&1; then
echo "Suckes - czas < 60s"
exit 0
else
echo "Niepowodzenie - czas > 60s"
exit 1
fi