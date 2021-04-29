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
systemctl restart sshd