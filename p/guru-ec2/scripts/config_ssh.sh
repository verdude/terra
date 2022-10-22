#!/usr/bin/env bash

set -xeuo pipefail

scriptpath="$(cd "$(dirname "$0")"; pwd -P)"
_wait=""
username=""

if [[ "$(uname)" = Darwin ]]; then
  darlose='""'
fi

while getopts u:w flag
do
  case ${flag} in
    w) _wait="true";;
    u) username="${OPTARG}";;
  esac
done


cd $scriptpath/..
ip=$(terraform output -json | jq .ec2_public_ip.value | tr -d '"')

sed -Eri $darlose "
/# auto-ec2$/ {
  N
  s/(HostName).*$/\1 ${ip}/g
}
" ~/.ssh/config

if [[ -n "$_wait" ]]; then
  echo "waiting a bit..."
  sleep 10
fi

ls -1 ~/.ssh/*.pub | xargs -I{} ssh-copy-id -fi {} ${username:-ubuntu}@$ip
