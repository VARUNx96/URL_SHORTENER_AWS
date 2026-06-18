#!/bin/bash

set -e

echo "DESTROYING K8s RESOURCES...⚠️⚠️⚠️"

cd ../K8s

kubectl delete -f . || true

echo "K8s RESOURCES REMOVED...✅✅✅"

echo "DESTROYING TERRAFORM RESOURCES...⚠️⚠️⚠️"

cd ../INFRA/EKS

terraform destroy -auto-approve

echo "EVERYTHING IS DESTROYED FROM EKS...✅✅✅"

