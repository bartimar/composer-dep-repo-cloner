# nette-dep-repo-cloner

Bash script to parse dependency git repos from nette composer.json with [jq](https://stedolan.github.io/jq/) and clone them

The only argument of this script is a path of the file to parse (default is "./composer.json")

Example usage: 
./nette-repo-cloner.sh /var/repos/my-nette-project/composer.json
