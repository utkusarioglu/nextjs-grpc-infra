#!/bin/bash

CRT_BUNDLE_SECRET_NAME="k3s-serving"

crt_bundle=$(kubectl -n kube-system get secret $CRT_BUNDLE_SECRET_NAME -o yaml \
  | yq '.data["tls.crt"]')

echo "{\"crt_bundle\": \"$crt_bundle\"}"
