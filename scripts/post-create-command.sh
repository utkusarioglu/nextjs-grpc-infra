#!/bin/bash


echo 'Tidying tests…'
cd tests && go mod tidy; cd ..

echo 'Checking on elam…'
$HOME/elam/elam.sh repo status
