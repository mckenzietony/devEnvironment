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

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOt4ZBM8uAg7SkVj4h6iw4dsSPRaC4bg+cm48M4hVmr tmckenzie@vesuvius" >> /home/ec2-user/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzzLckaeONWN6iFD4AV4sNsfYhvLUEIEPNcZwhlWBIjMfwD4lVo+k7Z0uer272eXTOUd5D6CVN1wtK4ywpOGbJEFdfrqHxVe405vhvatHA1FJI7kM8Gz5sIz2HcVebW2hlTv2xmipbgleEq4YRAf5JcL6s56E+OG+bfEq9pQD1H2sbMBrq+oxxA5M/iae+t2evTU8OTfoYhNX0Fv3H3sbkCIj1YGGwIHjAlSk46EGGCdYAvPyODkDfwhR6cMt10C5zGG5Lw50dejGV4Nll0nwZpygbrrEYw/rbAVyU+unr6SnaPWkF+9QCIp0kSFfAtzr2Vf1Yd9ZmTJPlse5d1yov james-test-key-nrt" >> /home/ec2-user/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGKbJ6HuDz5iiY24qi1vCx8lMI9/xmeJrR9kqLCINip james@cantor" >> /home/ec2-user/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILEin9slpQoj+hECOPrFTdQKu516Wb1EmSNuI6uzZ0DX james@laplace" >> /home/ec2-user/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGKbJ6HuDz5iiY24qi1vCx8lMI9/xmeJrR9kqLCINip james@cantor" >> /home/ec2-user/.ssh/authorized_keys
systemctl restart sshd

# Force pull the image to confirm we aren't waiting for ecs to queue up --
# TODO investigate why ecs sometimes takes a while to grab the new docker image
yum install awscli -y
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 333153126918.dkr.ecr.ap-northeast-1.amazonaws.com
docker pull 333153126918.dkr.ecr.ap-northeast-1.amazonaws.com/worker:latest
