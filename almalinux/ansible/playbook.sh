#!/usr/bin/env bash
#ansible-playbook -i hosts/docker site.yml -l almalinux8  -vvv
ansible-playbook -i hosts/docker site.yml -l almalinux8 --tags mysql8 -vvv

