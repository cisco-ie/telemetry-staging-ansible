#!/bin/bash

declare -A hashmap

hashmap["pipeline"]="~/pipeline/bin/pipeline -config ~/environment/pipeline.conf -log ~/log/pipeline.log -pem ~/environment/pig > /dev/null 2>&1 &"
echo "Starting pipeline"
eval "${hashmap["pipeline"]}"
echo "pipeline started!"
