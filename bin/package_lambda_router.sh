#!/bin/bash
cp ./skills_setup/lambda_router.js ./index.js
zip -r ./index.zip ./index.js
rm ./index.js