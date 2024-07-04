#!/bin/bash
if [[ $# == 0 ]]; then
  echo "usage: $0 <thing>.yml"
  exit 0
fi

limit=60
stime=$(date +%s)
kubectl apply -f $1
dname=$(kubectl get deployment -o jsonpath='{.items[*].metadata.name}')
ltime=$(date +%s)
dtime=0


working=0
until [ $dtime -gt $limit ]; do
  _rdy=$(kubectl get deployment $dname -o jsonpath='{.status.readyReplicas}')
  if [ -z "$_rdy" ]; then
    _rdy=0
  fi
  _ttl=$(kubectl get deployment $dname -o jsonpath='{.status.replicas}')
  echo -ne "\rDeploying... $_rdy/$_ttl -- ${dtime}/60s"
  ltime=$(date +%s)
  dtime=$(( $ltime - $stime ))
  if [ "$_rdy" -eq "$_ttl" ]; then
    echo
    echo "DONE!"
    exit 0
  fi
done

echo
echo Timeout!
exit 1
