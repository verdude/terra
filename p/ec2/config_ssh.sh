#!/usr/bin/env bash

set -xeuo pipefail

username=""

while getopts u: flag
do
  case ${flag} in
    u) username="${OPTARG}";;
  esac
done

ip=$(terraform output -json | jq .ec2_public_ip.value | tr -d '"')

ls -1 ~/.ssh/*.pub | xargs -I{} ssh-copy-id -fi {} ${username:-ubuntu}@$ip
