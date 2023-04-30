#!/bin/bash


export cluster1_tag='SpotInterruptionTest-test-eks'
export cluster2_tag='SpotInterruptionTest-test-eks-1'


export experiment__template_id=$(aws fis list-experiment-templates| jq -r  '.experimentTemplates[] | select(.tags.Name=="'"$cluster1_tag"'") | .id')

aws fis start-experiment --experiment-template-id $target_experiment__template_id  --tags TargetCluster=$cluster1_tag & &&\
aws fis list-experiments | jq -r  '.experiments[] | select(.tags.Name=="'"$cluster1_tag"'")'

export experiment__template_id=$(aws fis list-experiment| jq -r  '.experiments[] | select(.tags.Name=="'"$cluster1_tag"'") | .id')


export Target_Experiment_ID=$(aws fis list-experiment-templates| jq -r  '.experimentTemplates[] | select(.tags.Name=="'"$cluster2_tag"'") | .id')
aws fis start-experiment --experiment-template-id $Target_Experiment_ID  --tags tag:TargetCluster=$cluster1_tag &
aws fis list-experiments | jq -r  '.experiments[] | select(.tags.Name=="'"$cluster2_tag"'")'