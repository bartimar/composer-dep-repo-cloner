#!/bin/bash
input=${1-composer.json}
query='.repositories[].url'
repos=$(jq $query $input)
cmd="git clone"

for repo in $repos
do
 $cmd $repo
done
