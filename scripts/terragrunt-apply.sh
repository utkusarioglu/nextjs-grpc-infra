#!/bin/bash

cd infra
cd src/targets/k3d/dev/local

scripts/prep-for-local.sh

terragrunt run-all apply \
  --terragrunt-non-interactive \
  --auto-approve \
  --terragrunt-log-level info
