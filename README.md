# Steps for deployment (in progress) - init

![alt text](https://github.com/mckenzietony/devEnvironment/blob/main/Scratch/todo_notes.jpeg)

## Deploy terraform_base.template to cloudformation

* Once deployed, update backend.tf with the appropriate S3 and ddb table names
* Copy the updated backend.tf to the newly created terraform ec2 instance
* run terraform apply to set the terraform state configs

## Regional configs

* Copy the regional configs (ap-northeast-1/*) to the terraform instance (potentially new folder)
* run terraform apply to build out the aws environment

## Create codepipeline

TODO: create codepipeline terraform template

* Create code pipeline
* use buildspec.yml to define build process

Create and publish docker image
 create that shit

## modify autoscaling.tf with desired scaling group size

* terraform apply the shiz

## Ignore the below as it is being deprecated

ignooore

## Single instance dev environment

A quick run down and some notes for future development. This summary is almost certainly missing some
detail as it was written at the 11th hour. It should cover the basics for nom.

## Requirements

Current requiresments are:

* Powershell core 6/7
* AWSPowerShell.Netcore

## Setup

### Installing PowerShell

#### RTFM

<https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1>

Once you have powershell updated to at least version 6...

### Installing AWSPowershell tools

For now here are some links

#### Windows

<https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up-windows.html>

#### Linux

<https://docs.aws.amazon.com/powershell/latest/userguide/pstools-getting-set-up-linux-mac.html>

#### Setup AWS credentials

<https://docs.aws.amazon.com/powershell/latest/userguide/specifying-your-aws-credentials.html>

## AWS Account access

This tool should work with any account, but has one requirement:
You must create an ec2 keypair for ssh access. You will use the resulting pem to connect to the instance
The name of the key must be specified in the cloudformation param input. If this doesn't match, you will
not have access to the box.

The default user is most likely ec2-user but varies depending on instance type
> ssh -i ~/secretstuff/*.pem ec2-user@99.99.99.99

The above pem is the result is the matching key to that used with the instance

## SSH and Windows

Ssh should pretty much work out of the box on Linux, but if you're trying to remotely connect from
a windows machine, you may need a little bit of configuration. For now, follow the link

<https://adamtheautomator.com/powershell-ssh/>
<https://docs.microsoft.com/en-us/powershell/scripting/learn/remoting/ssh-remoting-in-powershell-core?view=powershell-7.1>

### Powershell ssh access

The server is configured with powershell/ssh access. You can gain access with the following syntax

PS /home/user> $Session = New-PSSession -Hostname xx.xx.xx.xx -UserName ec2-user -KeyFilePath ec2-key.pem
PS /home/user> Invoke-Command -Session $Session -Command {ls}
Main.class
Main.java
PS /home/user>

## This module

This module can be copied to:
/home/username/.local/share/powershell/Modules/

once transfered over you should be able to import it regardless of location with:
> Import-Module ./ControlPlane.psd1

It is not necessary to perform this step, but it will make the module global

## Using the tool

As mentioned above, usage looks like one of the following

Create new stack:
> pwsh ./ManageEnvironment.ps1 -CFNTask Create

Update stack - This is currently the same command as above - future use:
> pwsh ./ManageEnvironment.ps1 -CFNTask Update

Destroy the existing stack:
> pwsh ./ManageEnvironment.ps1 -CFNTask Remove

This command will tear down the stack, but will hang if you have not manually removed the code from s3.
This is just how AWS works, it can be handled in the future if we want to spend time on it. For now, you
have been put on notice! :D

## Using with some custom code

There is bare bones support for getting test code on the machine. You can specifiy code at runtime via CFN
params and the script will upload it to S3. The code will be pulled down onto the instance by way of user
data script as specified in CFN.template. Clearly this is a poor mans solution, but atm it seems to operate
as expected.

Stock config uses DummyCode.sh which just echos 'Hello World'.

## Disclaimer

This code is bleeding edge and probably has some kinks to work out. Use with care.

## TODO

* Make SSH key management more robust
* Test against windows environment - In theory netcore is portable, but its msft. who knows
