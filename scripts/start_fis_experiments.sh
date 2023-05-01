#!/bin/bash


$ export cluster1_tag='SpotInterruptionTest-test-eks'
$ export cluster2_tag='SpotInterruptionTest-test-eks-1'
$ export log_group_name='fis-log-group'


experiment__template_id=$(aws fis list-experiment-templates| jq -r  '.experimentTemplates[] | select(.tags.Name=="'"$cluster1_tag"'") | .id' | awk 'NR==1 {print $1}') 
aws fis start-experiment --experiment-template-id $experiment__template_id  --tags Name=$cluster1_tag & 

# 没必要
experiment_id=$(aws fis list-experiments | jq -r  '.experiments[] | select(.tags.Name=="'"$cluster1_tag"'") | .id' | awk 'NR==1 {print $1}') 

aws logs filter-log-events --log-group-name $log_group_name --cli-input-json '{ "filterPattern": "{ $.id = \"'"$experiment_id"'\" }" }'



export Target_Experiment_ID=$(aws fis list-experiment-templates| jq -r  '.experimentTemplates[] | select(.tags.Name=="'"$cluster2_tag"'") | .id')
aws fis start-experiment --experiment-template-id $Target_Experiment_ID  --tags tag:TargetCluster=$cluster1_tag &
aws fis list-experiments | jq -r  '.experiments[] | select(.tags.Name=="'"$cluster2_tag"'")'



aws logs   filter-log-events --log-group-name 'fis-log-group'  --filter-pattern '{$.id = "EXPWCqm2EQJxd3YBSz"}'


VENT_TYPE="UpdateTrail"
aws logs filter-log-events --log-group-name <LOG_GROUP_NAME> --cli-input-json '{ "filterPattern": "{ $.eventType = \"'"$EVENT_TYPE"'\" }" }'