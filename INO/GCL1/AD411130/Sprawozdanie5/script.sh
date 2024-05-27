#!/bin/bash
deployment_name="nginx-deployment"
namespace="default"
timeout=60
start_time=$(date +%s)

while true; do
  minikube kubectl rollout status deployment/$deployment_name 
  status=$?
  current_time=$(date +%s)
  elapsed_time=$((current_time - start_time))

  if [ $status -eq 0 ]; then
    echo "Deployment succeeded"
    exit 0
  elif [ $elapsed_time -ge $timeout ]; then
    echo "Deployment timeout"
    exit 1
  else
    sleep 5
  fi
done