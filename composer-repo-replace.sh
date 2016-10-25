#!/bin/bash
# maintainer bartimar6@gmail.com

display_usage() { 
  echo -e "\nUsage:\n$0 [json file path] [new relative path] \n" 
} 

if [  $# -gt 2 ] 
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
newpath=${2-.}
newpath=${newpath}
# json query string
query='.repositories[].type="path"'

# json parser
JQ_BINARY="jq"
if hash $JQ_BINARY 2>/dev/null; then
   # jq binary installed in system
   echo "Using jq binary..."
   output=$(jq $query $input |  sed -e ':loop;s/\(\"url\": \"\)[^/]*\/\(.*\)/\1\2/g;t loop' -e 's/.git//' -e 's/\(url":[^"]*"\)/\1'"$newpath"'\//' )
elif service docker status 1>/dev/null 2>/dev/null; then
   # docker service is running
   image="colstrom/jq"
   echo "Using docker container..."
   replace=$(docker run --rm -i $image $query <$input)
   output=$( echo $replace  |  sed -e ':loop;s/\(\"url\": \"\)[^/]*\/\(.*\)/\1\2/g;t loop' -e 's/.git//' )
else
   # no jq binary, no docker, no fun
   echo "FATAL ERROR: Your system doesn't seem to have installed neither jq binary nor docker. Exiting."
   exit 1
fi

echo "$output"
