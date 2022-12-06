#!/bin/bash

mkdir -p logs

echo "Starting Terratest…"
cd tests 
env $(cat ../.env | xargs) go test -timeout 90m 
cd ..
