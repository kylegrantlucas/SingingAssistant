#!/bin/bash
mkdir ./lambda_router
cp ./skills_setup/lambda_router.js ./lambda_router/lambda_router.js
( cd ./lambda_router && npm install async )
zip -r ./lambda_router.zip ./lambda_router
rm -rf ./lambda_router