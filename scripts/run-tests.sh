#!/bin/bash

mkdir -p logs

TEST_TIMEOUT=90m

echo "Starting Terratest…"
cd tests 
if [ -f "../.env" ]; then
  env $(cat ../.env | xargs) go test -timeout "$TEST_TIMEOUT" 
  test_exit_code=$?
else
  go test -timeout "$TEST_TIMEOUT"
  test_exit_code=$?
fi
cd ..

# echo "MS LOGS"
# kubectl -n ms logs $(kubectl -n ms get po -o yaml | yq '.items[].metadata.name | select(. == "ms-*")')
# echo "WEB SERVER LOGS"
# kubectl -n api logs $(kubectl -n api get po -o yaml | yq '.items[].metadata.name | select(. == "web-server-*")')
# echo "POSTGRES STOREAGE LOGS"
# kubectl -n ms logs $(kubectl -n ms get po -o yaml | yq '.items[].metadata.name | select(. == "*postgres*")')

exit $test_exit_code
