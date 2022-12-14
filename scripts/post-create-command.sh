#!/bin/bash

cd tests && go mod tidy; cd ..

.elam/update-status.sh
