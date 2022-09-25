#!/usr/bin/env bash

set -e

ip=$(terraform output -json | jq .ec2_public_ip.value | tr -d '"')

sed -Eri "
/# auto-ec2$/ {
  N
  s/(HostName).*$/\1 ${ip}/
}
" ~/.ssh/config

ls -1 ~/.ssh/*.pub | xargs -I{} ssh-copy-id -fi {} guru
