#!/bin/bash


# Get a list of all contexts in the Kubernetes configuration file
contexts=$(kubectl config get-contexts -o name) 

# Loop through each context and uninstall karpenter
for context in $contexts; do
  echo "Listing pods for context: $context"
  kubectl config use-context $context
  helm uninstall karpenter --namespace karpenter
  kubectl delete deployment inflate
done && \


# Delete Event Bus
aws cloudformation delete-stack --stack-name "Karpenter-Event-Bus" 



# delete all cluster s
cluster_set=$(eksctl get cluster)

echo "$cluster_set" | while read -r line; do
  # skip the header row
  if [[ $line == NAME* ]]; then
    continue
  fi
  CLUSTER_NAME=$(echo "$line" | awk '{print $1}')

  # print cluster based configuration
  aws cloudformation delete-stack --stack-name "Karpenter-${CLUSTER_NAME}-role-and-interruption-queue" 
  aws cloudformation delete-stack --stack-name "Karpenter-${CLUSTER_NAME}-FIS-experiments" 

  eksctl delete cluster --name ${CLUSTER_NAME}
done