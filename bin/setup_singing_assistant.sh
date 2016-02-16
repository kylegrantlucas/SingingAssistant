#!/bin/bash
bundle install
rake skills_config:generate_sample_utterances
rake skills_config:generate_custom_slots
rake skills_config:generate_intent_schema
rake skills_config:generate_lambda_router
./bin/package_lambda_router.sh