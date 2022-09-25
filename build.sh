#!/usr/bin/env bash

set -e

#terraform apply 1>/dev/null
ip=$(terraform output -json | jq .ec2_public_ip.value | tr -d '"')

sed -iE "
/# auto-ec2$/ {
  N
  s/(HostName).*$/\1 ${ip}/
}
" ~/.ssh/config
