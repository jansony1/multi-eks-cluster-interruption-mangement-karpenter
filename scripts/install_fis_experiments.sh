#!/bin/bash

export KARPENTER_VERSION=v0.27.3 
export CLUSTER_NAME=$1
export AWS_DEFAULT_REGION="us-west-2"
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export TEMPOUT=$(mktemp)

aws cloudformation deploy \
    --stack-name "Karpenter-${CLUSTER_NAME}-FIS-experiments" \
    --template-file ./cloudformations/fis_experiment_template.yaml \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ClusterName=${CLUSTER_NAME}"


