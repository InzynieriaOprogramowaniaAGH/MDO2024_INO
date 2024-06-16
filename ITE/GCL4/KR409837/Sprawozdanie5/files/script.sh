#!/bin/bash

DEPLOYMENT_NAME="react-hot-cold"

kubectl apply -f deployment.yaml

end_time=$((SECONDS + 60))

while [ $SECONDS -lt $end_time ]; do
    status=$(kubectl rollout status deployment/$DEPLOYMENT_NAME)
    if [[ $status == *"successfully rolled out"* ]]; then
        echo "Aplikacja została wdrożona w ciągu 60 sekund."
        exit 0
    fi
    
    sleep 5
done

echo "Aplikacja nie została wdrożona w ciągu 60 sekund."
exit 1