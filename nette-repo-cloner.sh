#!/bin/bash
# maintainer bartimar6@gmail.com

display_usage() { 
  echo -e "\nUsage:\n$0 [json file path] \n" 
} 

if [  $# -gt 1 ] 
then 
  display_usage
  exit 1
fi 

# check whether user had supplied -h or --help . If yes display usage 
if [[ ( $# == "--help") ||  $# == "-h" ]] 
then 
  display_usage
  exit 0
fi 

# input handler
input=${1-composer.json}

# json query string
query='.repositories[].url'

# json parser
JQ_BINARY="jq"
if hash $JQ_BINARY 2>/dev/null; then
   # jq binary installed in system
   echo "Using jq binary..."
   repos=$(jq $query $input)
elif service docker status 1>/dev/null 2>/dev/null; then
   # docker service is running
   image="colstrom/jq"
   echo "Using docker container..."
   repos=$(docker run --rm -i $image $query <$input)
else
   # no jq binary, no docker, no fun
   echo "FATAL ERROR: Your system doesn't seem to have installed neither jq binary nor docker. Exiting."
   exit 1
fi

echo "repos:"
echo $repos

# command to process the result of the query
cmd="git clone"

for repo in $repos
do
 $cmd $repo
done
