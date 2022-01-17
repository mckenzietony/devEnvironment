#!/bin/bash

# ssl debugging
echo "export SSLKEYLOGFILE=/home/ec2-user/dockme/ssl-key.log" >> ~/.bashrc

# give ECS something to chew on
while true; do
	sleep 1
done&

/bin/bash