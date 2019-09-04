#!/bin/bash

ansible-playbook -i inventory.yaml --ask-pass 01-bootstrap-ssh.play
