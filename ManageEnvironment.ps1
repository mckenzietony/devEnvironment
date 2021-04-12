<# 
.SYNOPSIS Master control script for env
.DESCRIPTION Build and manage the environment
.NOTES There is/may be place holder names and resources
.NOTES AWS response error handling needs to be improved. This is very "day 1" code
.COMPONENT Requires AWSPowerShell.Netcore be available and configured locally
.Parameter Region The region obviously
.Parameter Stage dev/stage/prod etc
.Parameter StackName friendly name of the cloudformation stack
.Parameter S3BucketName name of the bucket in which to upload code
.Parameter SSHKeyName name of the ssh key the instance will run under - for use with ssh
.Parameter InstanceType size of instance - t2.micro is free tier
.Parameter Template location of the cloudformation template to use with the environment
.Parameter ServerCode code to upload to s3 and use on the the ec2 instance
.Parameter CFNTask primary operation to perform against the environment create/update/remove
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$Region = 'ap-northeast-1',

    [Parameter()]
    [string]$Stage = 'test',

    [Parameter()]
    [string]$StackName = 'controlplane',

    [Parameter()]
    [string]$S3BucketName = 'test-trader-code-bucket-666',

    # Key must already exist in ec2 keystore!!!
    # If it doesn't go create it now
    [Parameter()]
    [string]$SSHKeyName = 'test-trader-nrt',

    [Parameter()]
    [string]$InstanceType = 'm5.2xlarge',

    [Parameter()]
    [string]$Template = "CloudFormation/DayOne.template",

    [Parameter()]
    [String]$ServerCode = "echo_loop.py",

    [Parameter(Mandatory)]
    [ValidateSet("Create", "Update", "Remove")]
    [String]$CFNTask
)

Import-Module AWSPowerShell.NetCore
#Import-Module ./ControlPlane.psd1
Import-Module ./Modules/StartStandup.psm1
Import-Module ./Modules/StartTearDown.psm1

$ErrorActionPreference = "Continue"
$VerbosePreference = "Continue"

$Template = (Get-Content -Path $Template -Raw)

$StackUpdateSplat = @{
    Region = $Region;
    Stage = $Stage;
    StackName = $StackName;
    S3BucketName = $S3BucketName;
    SSHKeyName = $SSHKeyName;
    InstanceType = $InstanceType;
    Template = $Template
}

If (($CFNTask -eq "Create") -or ($CFNTask -eq "Update")) {
    Write-Verbose "Attempting to stand up stack"
    Deploy-Stack @StackUpdateSplat

    Write-Verbose "Stack is up"

    # Basic code uploader
    #Invoke-S3CodeUploader -ServerCode $ServerCode -S3BucketName $S3BucketName

    Write-Verbose ("Uploaded: {0} to {1}" -f $ServerCode, $S3BucketName)
}

# YOU MUST MANUALLY REMOVE ANY FILES FROM THE S3 BUCKET OR THE RESOURCE WILL NOT BE REMOVED
If ($CFNTask -eq "Remove") {
    Write-Verbose "Attempting Removal of stack deployment"
    Remove-Stack -Region $Region -StackName $StackName

    Write-Verbose "Stack is removed"
}

Write-Verbose "Complete"