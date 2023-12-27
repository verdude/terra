#!/usr/bin/env bash

set -xeuo pipefail

scriptpath="$(cd "$(dirname "$0")"; pwd -P)/.."
_wait=""
username=""
darlose=""
pattern="# auto-ec2$"

if [[ "$(uname)" = Darwin ]]; then
  darlose='""'
fi

while getopts s:p:u:w flag
do
  case ${flag} in
    w) _wait="true";;
    u) username="${OPTARG}";;
    s) scriptpath="${OPTARG}";;
    p) pattern="${OPTARG}";;
  esac
done

cd $scriptpath
ip=$(terraform output -json | jq .ec2_public_ip.value | tr -d '"')

if [[ $ip == "null" ]]; then
  echo "Null ip"
  exit 1
fi

sed -Eri $darlose "
/${pattern}/ {
  N
  s/(HostName).*$/\1 ${ip}/g
}
" ~/.ssh/config

if [[ -n "$_wait" ]]; then
  echo "waiting a bit..."
  sleep 10
fi

pk=(~/.ssh/*.pub)
for k in "${pk[@]}"; do
  ssh-copy-id -fi "${k}" "${username:-admin}@$ip"
done
