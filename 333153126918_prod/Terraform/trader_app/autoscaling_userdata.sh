#!/bin/bash

echo ECS_CLUSTER=trader-bois >> /etc/ecs/ecs.config

yum update -y
yum install -y yum-utils
amazon-linux-extras install epel -y

# Register the Microsoft RedHat repository
curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo

# Install PowerShell
yum install powershell -y

# Allow access using powershell
echo "  " >> /etc/ssh/sshd_config
echo "# Powershell Subsystem -- Allow pwsh remoting" >> /etc/ssh/sshd_config
echo "Subsystem powershell /usr/bin/pwsh -sshs -NoLogo" >> /etc/ssh/sshd_config
echo "export DOTNET_CLI_TELEMETRY_OPTOUT=true" >> /home/ec2-user/.bashrc

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOt4ZBM8uAg7SkVj4h6iw4dsSPRaC4bg+cm48M4hVmr tmckenzie@vesuvius" >> /home/ec2-user/.ssh/authorized_keys
systemctl restart sshd

# configure system performance profile and return result
yum install tuned -y
systemctl start tuned
systemctl enable tuned
tuned-adm profile latency-performance
tuned-adm active

echo "Pulling docker images - this will take some time"
# Force pull the image to confirm we aren't waiting for ecs to queue up --
# TODO investigate why ecs sometimes takes a while to grab the new docker image
yum install awscli -y
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 333153126918.dkr.ecr.ap-northeast-1.amazonaws.com
docker pull 333153126918.dkr.ecr.ap-northeast-1.amazonaws.com/worker:latest
