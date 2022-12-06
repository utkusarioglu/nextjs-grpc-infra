#!/bin/bash

terraform init

cd tests && go mod tidy; cd ..

.elam/update-status.sh
