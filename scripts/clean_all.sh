#!/bin/bash

export CLUSTER_NAME=$1
export CLUSTER_NAME_1=$2


# Get a list of all contexts in the Kubernetes configuration file
contexts=$(kubectl config get-contexts -o name) 

# Loop through each context and uninstall karpenter
for context in $contexts; do
  echo "Listing pods for context: $context"
  kubectl config use-context $context
  helm uninstall karpenter --namespace karpenter
done && \


aws cloudformation delete-stack --stack-name "Karpenter-${CLUSTER_NAME}-role-and-interruption-queue" && \
aws cloudformation delete-stack --stack-name "Karpenter-Event-Bus" && \
aws cloudformation delete-stack --stack-name "Karpenter-${CLUSTER_NAME}-FIS-experiments"  && \

eksctl delete cluster --name "${CLUSTER_NAME}" && \
eksctl delete cluster --name "${CLUSTER_NAME_1}" && \