#!/bin/bash

ssh-keygen -f "/home/deck/.ssh/known_hosts" -R "pve-01.lan.pezlab.dev"
ssh-keygen -f "/home/deck/.ssh/known_hosts" -R "10.0.0.210"
ssh-keygen -f "/home/deck/.ssh/known_hosts" -R "pve-02.lan.pezlab.dev"
ssh-keygen -f "/home/deck/.ssh/known_hosts" -R "10.0.0.211"
ssh-keygen -f "/home/deck/.ssh/known_hosts" -R "pve-03.lan.pezlab.dev"
ssh-keygen -f "/home/deck/.ssh/known_hosts" -R "10.0.0.212"

