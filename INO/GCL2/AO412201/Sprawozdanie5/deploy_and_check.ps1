$DEPLOYMENT_NAME = "hot-cold1"

kubectl apply -f yaml/deployment1.yaml

$end_time = (Get-Date).AddSeconds(60)

while ((Get-Date) -lt $end_time) {
    $status = kubectl rollout status deployment/$DEPLOYMENT_NAME
    if ($status -like "*successfully rolled out*") {
        Write-Output "Application has been deployed in 60s"
        exit 0
    }

    Start-Sleep -Seconds 5
}

Write-Output "Application has not been deployed in 60s"
exit 1
