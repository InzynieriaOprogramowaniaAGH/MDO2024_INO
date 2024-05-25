#!/bin/bash

DEPLOYMENT_NAME="clock-deployment"
TIMEOUT=60

minikube kubectl -- apply -f ./clock-deployment.yaml

minikube kubectl get deployments 

if minikube kubectl -- rollout status deployment/$DEPLOYMENT_NAME --timeout=${TIMEOUT}s > /dev/null 2>&1; then
  echo "Deployment successfully rolled out within the time limit."
  exit 0
else
  echo "Deployment did not complete within the time limit."
  exit 1
fi