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

exit $test_exit_code
