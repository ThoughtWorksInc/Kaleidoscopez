#!/bin/bash

IP_ADDR=$1
USERNAME=$2
PASSWORD=$3
knife bootstrap $IP_ADDR -x $USERNAME -P $PASSWORD -r 'role[deploy]' --template-file bootstrap/deploy.erb --sudo
