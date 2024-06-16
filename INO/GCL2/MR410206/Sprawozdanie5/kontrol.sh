MAX_WAIT=60 
NAME="pet-deployment"
FILE="petclinic-deployment.yaml"

minikube kubectl -- apply -f $FILE

minikube kubectl -- rollout status deployment/$NAME --timeout=${MAX_WAIT}s
ROLLOUT_STATUS=$?

if [[ $ROLLOUT_STATUS -eq 0 ]]; then 
    echo "Wdrożenie zdążyło się wdrożyć w 60 sek"
    exit 0
else
    echo "Wdrożenie NIE zdążyło się wdrożyć w 60 sek"
    exit 1
fi