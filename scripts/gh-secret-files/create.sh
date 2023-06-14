#!/bin/bash

TEMP_ZIP_FILE_ABSPATH=/tmp/secrets.zip
TEMP_B64_FILE_ABSPATH=/tmp/secrets.b64

zip -r $TEMP_ZIP_FILE_ABSPATH vars/* secrets/* .certs/*
echo "$(cat $TEMP_ZIP_FILE_ABSPATH | base64)" > $TEMP_B64_FILE_ABSPATH
gh secret set SECRET_FILES < $TEMP_B64_FILE_ABSPATH
rm $TEMP_ZIP_FILE_ABSPATH $TEMP_B64_FILE_ABSPATH 
