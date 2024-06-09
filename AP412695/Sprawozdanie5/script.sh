#!/bin/bash

minikube kubectl -- apply -f remote.yaml

if minikube kubectl -- rollout status deployment/simple-nginx --timeout=60s > /dev/null 2>&1; then
echo "Deployment successfull"
exit 0
else
echo "Deployment timeout. Expected time exceeded."
minikube kubectl rollout undo deployment/simple-nginx
exit 1
fi