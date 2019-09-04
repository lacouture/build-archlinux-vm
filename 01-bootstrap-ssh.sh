#!/bin/bash

IP=$(ansible-inventory -i inventory.yaml --host=target -y | grep '^ansible_host: ' | sed 's/^ansible_host: //')

ssh-keyscan $IP >> ~/.ssh/known_hosts
ansible-playbook -i inventory.yaml --ask-pass 01-bootstrap-ssh.play
