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
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzzLckaeONWN6iFD4AV4sNsfYhvLUEIEPNcZwhlWBIjMfwD4lVo+k7Z0uer272eXTOUd5D6CVN1wtK4ywpOGbJEFdfrqHxVe405vhvatHA1FJI7kM8Gz5sIz2HcVebW2hlTv2xmipbgleEq4YRAf5JcL6s56E+OG+bfEq9pQD1H2sbMBrq+oxxA5M/iae+t2evTU8OTfoYhNX0Fv3H3sbkCIj1YGGwIHjAlSk46EGGCdYAvPyODkDfwhR6cMt10C5zGG5Lw50dejGV4Nll0nwZpygbrrEYw/rbAVyU+unr6SnaPWkF+9QCIp0kSFfAtzr2Vf1Yd9ZmTJPlse5d1yov james-test-key-nrt" >> /home/ec2-user/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGKbJ6HuDz5iiY24qi1vCx8lMI9/xmeJrR9kqLCINip james@cantor" >> /home/ec2-user/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILEin9slpQoj+hECOPrFTdQKu516Wb1EmSNuI6uzZ0DX james@laplace" >> /home/ec2-user/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKGKbJ6HuDz5iiY24qi1vCx8lMI9/xmeJrR9kqLCINip james@cantor" >> /home/ec2-user/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDb/bdXMbUYuMVsqpUSFDWAMWNRw0mVupV1+tmdz4ePuIBUnxOA1wqA6WTcWDJaCTk27iZmiWVv8ylrvJeQvwWnQzahUluqdUkTwz3MWAFK9/J3sbrS5PAD1HGzz/Pg0+jNoJv9r76veOKPoFKwgCB0BNahmZllcjOknzEfIaV/XDYgBNEV2mk13ODEUK962CObJFcweb+914RfOL72e10hu9Hy2F4HjIOMrMKLN22cQCJVK9vlMSJSuthSXyBeMAXRSZKn1IQ2/W9moRg9CXzDnbJLHT3+gxjh8zIRAoFN8AI9JyoNB0LS0z/rssYzTayCzhYAHtmMx4uT+u9bRJZ7kOawOaPIvd61KFUEYdiPkvhegLcXTpNnnSC4baj6hrMR3QbPKgTV43UDuhjtNDxVsp62laVPccE/KjXgalww2g1GNG/pubS1dCw3d/YSF9/icjL1iIscs4/CR0HqgYGIiZVgXGEp6SMKrICROxK3J99zJCT1PS6BCMOxlXgpS3M= user@Primary" >> /home/ec2-user/.ssh/authorized_keys
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
