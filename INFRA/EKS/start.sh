#!/bin/bash

echo "REMOVED .terraform FILE"

rm -rf .terraform

echo "REMOVED .terraform.lock.hcl FILE"

rm .terraform.lock.hcl

echo "STARTING terrafrom INIT"

terraform init

echo "EVERYTHING IS DONE READY TO GO...✅"
