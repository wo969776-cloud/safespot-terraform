#!/bin/bash

set -e

TARGET=$1

if [ -z "$TARGET" ]; then
  echo "Usage: ./plan.sh <env-path>"
  echo "Example: ./plan.sh terraform/environments/dev/api-service"
  exit 1
fi

cd $TARGET

terraform init
terraform plan -out=tfplan
infracost breakdown --path=tfplan