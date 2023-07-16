#!/bin/bash

TARGET_FOLDER_RELPATH=.ignore/gh-actions-artifacts
ARTIFACT_GLOB_PATTERN='utkusarioglu-nextjs-grpc-infra-*'


rm -rf $TARGET_FOLDER_RELPATH
mkdir -p $TARGET_FOLDER_RELPATH

cd $TARGET_FOLDER_RELPATH

gh run download -p "$ARTIFACT_GLOB_PATTERN"
