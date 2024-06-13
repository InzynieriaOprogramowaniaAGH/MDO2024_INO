#!/bin/bash

DEPLOYMENT_NAME="nginx-clock-deployment"
TIMEOUT=60

minikube kubectl -- apply -f ./nginx-clock-deployment.yaml

minikube kubectl get deployments 

if minikube kubectl -- rollout status deployment/$DEPLOYMENT_NAME --timeout=${TIMEOUT}s > /dev/null 2>&1; then
echo "Wdrożenie wykonało się w czasie poniżej 60 sekund."
exit 0
else
echo "Wdrożenie nie wykonało się w czasie poniżej 60 sekund."
exit 1
fi