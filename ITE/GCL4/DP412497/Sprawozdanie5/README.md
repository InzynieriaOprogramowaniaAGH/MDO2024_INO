# Sprawozdanie 05
# IT 412497 Daniel Per
---


![ss](./ss/ss01.png)

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -Uvh minikube-latest.x86_64.rpm\
```

![ss](./ss/ss02.png)

```
minikube start
```

![ss](./ss/ss03.png)

```
minikube kubectl -- get po -A
```


```
137  cd Dev2/MDO2024_INO/ITE/GCL4/DP412497/Sprawozdanie5
  138  cd yamle
  139  minikube start
  140  kubectl apply -f deployment.yaml
  141  minikube apply -f deployment.yaml
  142  minikubectl apply -f deployment.yaml
  143  kubectl apply -f deployment.yaml
  144  alias kubectl="minikube kubectl --"
  145  kubectl apply -f deployment.yaml
  146  kubectl apply -f service.yaml
  147  kubectl get deployments
  148  kubectl get services
  149  minikube service nginx-service
  150  kubectl apply -f deployment.yaml
  151  kubectl apply -f service.yaml
  152  kubectl get deployments
  153  kubectl get services
  154  minikube service nginx-service
  155  kubectl get deployments
  156  minikube service nginx-service
  157  kubectl apply -f deployment.yaml
  158  kubectl get deployments
  159  kubectl apply -f deployment.yaml
  160  kubectl get deployments
  161  minikube dashboard
  162  kubectl rollout history
  163  kubectl rollout history deployments/nginx-deployment
  164  kubectl apply -f deployment.yaml
  165  kubectl rollout  deployments/nginx-deployment
  166  kubectl rollout deployments/nginx-deployment
  167  kubectl rollout history deployments/nginx-deployment
  168  kubectl apply -f services.yaml
  169  kubectl apply -f service.yaml
  170  minikube stop
```