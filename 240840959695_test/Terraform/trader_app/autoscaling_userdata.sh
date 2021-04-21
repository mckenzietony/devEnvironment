#!/bin/bash

echo ECS_CLUSTER=trader-bois >> /etc/ecs/ecs.config

yum update -y
yum install -y yum-utils

# Register the Microsoft RedHat repository
curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo

# Install PowerShell
yum install powershell -y

# Allow access using powershell
echo "  " >> /etc/ssh/sshd_config
echo "# Powershell Subsystem -- Allow pwsh remoting" >> /etc/ssh/sshd_config
echo "Subsystem powershell /usr/bin/pwsh -sshs -NoLogo" >> /etc/ssh/sshd_config
systemctl restart sshd