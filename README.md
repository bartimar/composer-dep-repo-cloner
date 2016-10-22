# composer-dep-repo-cloner

Bash script to parse dependency git repos from composer.json with [jq](https://stedolan.github.io/jq/) and clone them

The only argument of this script is a path of the file to parse (default is "./composer.json")

Example usage: 
./composer-repo-cloner.sh /var/repos/my-nette-project/composer.json

Added features:
 - jq docker container handles the json parsing if there is no jq installed on the system
