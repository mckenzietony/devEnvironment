<# 
.SYNOPSIS Functions to manipulate an autoscaling group
.DESCRIPTION add or remove an instance from a given asg
.COMPONENT Requires AWSPowerShell.Netcore be available and configured locally
.Parameter Region The region obviously
.Example Set-TraderASGDown -Region 'ap-northeast-1'
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$Region = 'ap-northeast-1'
)

$ErrorActionPreference='Continue'
$VerbosePreference='SilentlyContinue'

try {
    Import-Module AWSPowerShell.NetCore
} Catch {
    Install-Module -Name AWSPowerShell.NetCore
    Import-Module -Name AWSPowerShell.NetCore
}


function Set-TraderASGDown {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Region
    )

    $DesiredCap = 0
    $WhereFilter = 'asg'
    $AsgName = (Get-ASAutoScalingGroup `
        -Region $Region).AutoScalingGroupName

    foreach ($name in $AsgName | Where-Object {$_ -eq $WhereFilter}) {

        Set-ASDesiredCapacity `
            -autoscalinggroupname $name `
            -desiredcapacity $DesiredCap `
            -Region $Region
    }
}

function Set-TraderASGUp {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Region,

        [Parameter()]
        [string]$DesiredCap
    )    

    $WhereFilter = 'asg'
    $AsgName = (Get-ASAutoScalingGroup `
        -Region $Region).AutoScalingGroupName

    foreach ($name in $AsgName | Where-Object {$_.ToString() -eq $WhereFilter}) {

        Set-ASDesiredCapacity `
            -autoscalinggroupname $name `
            -desiredcapacity $DesiredCap `
            -Region $Region
    }
}

function Get-InstanceIPFromASG {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Region
    )   

    $Counter = 15
    Write-Verbose 'Retrieving instance details'

    do {
        if ($Counter -le 0) {
            Write-Warning 'maximum retry exceeded'
            Write-Warning 'no instances found for the auto scaling group'
            break
        }

        $AsgInstances = (Get-ASAutoScalingGroup `
            -Region $Region).Instances

        if (!$AsgInstances) {
            $Counter--
            Start-Sleep 1

        } else {
            Write-Verbose 'Instance details found'
        }

    } while (!$ASGInstances)

    Write-Verbose 'locating public IP address'
    $InstanceDetails = @()

    foreach ($Instance in $AsgInstances.InstanceId) {
        # should also append availability zone
        $InstanceDetails += (Get-EC2Instance `
            -Region $Region `
            -InstanceId $Instance).Instances.PublicIpAddress
    }

    Return $InstanceDetails
}


#Set-TraderASGDown -Region $Region