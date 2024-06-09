#!/bin/bash

minikube kubectl -- apply -f click.yaml;

if ! minikube kubectl -- rollout status deployment/click-deployment --timeout=60s; then
exit 1 
fi
