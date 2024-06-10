#!/bin/bash

kubectl apply -f depl.yaml

sleep 30

status=$(minikube kubectl rollout status deployment/custom-nginx)

if [[ "$status" = "successfully" ]];
then
       echo "End"
       minikube kubectl rollout status deployment custom-nginx
else
       echo "In progress"
       minikube kubectl rollout status deployment custom-nginx
       minikube kubectl undo deployment custom-nginx
fi
