#!/bin/bash

sudo yum install wget python3 python3-pip ansible -y
sudo yum update -y
sudo ansible-galaxy collection install amazon.aws
