#!/bin/bash

kubectl apply -f depl.yaml

sleep 60

status=$(minikube kubectl rollout status deployment/custom-nginx)

if [[ "$status" = *"successfully"* ]];
then
       echo "Zakonczono"
       minikube kubectl rollout status deployment custom-nginx
else
       echo "W trakcie"
       minikube kubectl rollout status deployment custom-nginx
       minikube kubectl undo deployment custom-nginx
fi
