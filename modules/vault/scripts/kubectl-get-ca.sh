#!/bin/bash

ca_crt=$(kubectl config view --minify --flatten \
  | yq '.clusters.0.cluster.certificate-authority-data')

echo "{\"ca_crt\": \"$ca_crt\"}"
