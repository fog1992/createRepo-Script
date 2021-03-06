#!/bin/bash

#repo_name=$1
#test -z $repo_name && echo "Repo name required." 1>&2 && exit 1
#curl -u 'your_github_username' https://api.github.com/user/repos -d "{\"name\":\"$repo_name\"}"

token=$(<token.txt)

echo "Your Token: $token"

echo "class name:"
read className

echo "Path to names list (default ./names.txt):"
read pathNames

if [[ "$pathNames" = "" ]]; then
  pathNames='names.txt'
fi

echo "private (y/n)?"
read private
if [[ "$private" = "y" ]]; then
  private="true"
else
  private="false"
fi

echo "auto_init (y/n)?"
read auto_init
if [[ "$auto_init" = "y" ]]; then
  auto_init="true"
else
  auto_init="false"
fi

echo "organization (y/n)?"
read org
if [[ "$org" = "y" ]]; then
  isOrg=true
  echo "name of the organization?"
  read orgName;
else
  isOrg=false
fi

description="Repo für den Kurs $className"

echo "Input: $pathNames private: $private auto_init: $auto_init isOrg: $isOrg"

for rn in $(<$pathNames); do
    echo "the next name is $rn"
    d='{"name":"'$className'_'$rn'","description":"'$description'","private":'$private',"auto_init":'$auto_init'}'
    echo $d;
    if [[ $isOrg = true ]]; then
      curl -H "Authorization: token $token" \
      https://api.github.com/orgs/$orgName/repos \
      -d "$d"
    else
      curl -H "Authorization: token $token" \
      https://api.github.com/user/repos \
      -d "$d"
    fi
done
