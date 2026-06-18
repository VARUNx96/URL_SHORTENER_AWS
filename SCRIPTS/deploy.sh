#!/bin/bash

set -e

CLUSTER_NAME="url-shortener-cluster"
REGION="us-east-1"

echo "CREATING INFRA...🧱🧱🧱"

cd ../INFRA/EKS

bash start.sh


terraform apply -auto-approve

echo "UPDATING KUBECONFIG....⏳⏳⏳"

aws eks update-kubeconfig \
--name $CLUSTER_NAME \
--region $REGION

echo "DEPLOYING APPLICATION...🔥🔥🔥"

cd ../../K8s

kubectl apply -f .

echo "DEPLOYMENT COMPLETED...🍾🍾🍾"
