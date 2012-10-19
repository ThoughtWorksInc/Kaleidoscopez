#!/bin/bash

IP_ADDR=$1
USERNAME=$2
PASSWORD=$3
tar -cz /tmp/chef.tar.gz chef
scp /tmp/chef.tar.gz $USERNAME@$IP_ADDR:/tmp
ssh $USERNAME@$IP_ADDR '
cd /tmp
rm -rf chef kaleidoscopez
tar -xvf chef.tar.gz
mv chef kaleidoscopez
'
knife bootstrap $IP_ADDR -r 'role[webserver]' -x $USERNAME -P $PASSWORD --template-file bootstrap/chef-full.erb --sudo

