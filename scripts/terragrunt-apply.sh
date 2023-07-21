#!/bin/bash

cd infra
cd src/targets/k3d/dev/local

terragrunt run-all apply \
  --terragrunt-non-interactive \
  --auto-approve \
  --terragrunt-log-level info
