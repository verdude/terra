#!/usr/bin/env bash

set -euo pipefail

_wait=""

while getopts w flag
do
  case ${flag} in
    w) _wait="true";;
  esac
done

ip=$(terraform output -json | jq .ec2_public_ip.value | tr -d '"')

sed -Eri "
/# auto-ec2$/ {
  N
  s/(HostName).*$/\1 ${ip}/
}
" ~/.ssh/config

if [[ -n "$_wait" ]]; then
  echo "waiting a bit..."
  sleep 10
fi

ls -1 ~/.ssh/*.pub | xargs -I{} ssh-copy-id -fi {} guru
