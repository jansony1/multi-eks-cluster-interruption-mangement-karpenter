#!/bin/bash

export KARPENTER_VERSION=v0.27.3
export AWS_DEFAULT_REGION="us-west-2"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export TEMPOUT=$(mktemp)

aws cloudformation deploy \
    --stack-name "Karpenter-interruption_handler_event_bus" \
    --template-file ./cloudformations/interruption_handler_event_bus.yaml \
    --capabilities CAPABILITY_NAMED_IAM 

