#!/bin/bash

scripts/prep-for-local.sh

cp .certs/root/root.crt /usr/local/share/ca-certificates/
update-ca-certificates

cd src/targets/k3d/dev/local

terragrunt run-all apply \
  --terragrunt-non-interactive \
  --auto-approve \
  --terragrunt-log-level info
