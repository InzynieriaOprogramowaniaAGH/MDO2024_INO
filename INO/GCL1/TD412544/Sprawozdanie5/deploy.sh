#!/bin/bash
timeout=60

minikube kubectl -- apply -f ./deployment-memeginx.yaml
minikube kubectl -- get deployments 

if minikube kubectl -- rollout status deployment/memeginx-deployment --timeout=${timeout}s > /dev/null 2>&1; then
echo "Deployment rolled out within the time limit."
exit 0
else
echo "Deployment did not complete within the time limit."
exit 1
fi