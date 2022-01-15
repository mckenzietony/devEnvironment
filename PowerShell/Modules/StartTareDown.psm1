<# 
.SYNOPSIS Tear down the environment
.DESCRIPTION This script will destroy a cloudformation based environment and necessary resources
.NOTES There is/may be place holder names and resources
.COMPONENT Requires AWSPowerShell.Netcore be available and configured locally
.Parameter Region The region obviously
.Parameter StackName friendly name of the cloudformation stack
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$Region,

    [Parameter()]
    [string]$StackName
)

#Import-Module AWSPowerShell.Netcore
$ErrorActionPreference = "Continue"
$VerbosePreference = "Continue"
Function Remove-Stack{
    <# 
    .SYNOPSIS Remove the stack
    .DESCRIPTION Tear down the stack
    .NOTES There is/may be place holder names and resources
    .COMPONENT Requires AWSPowerShell.Netcore be available and configured locally
    .Parameter Region The region obviously
    .Parameter StackName friendly name of the cloudformation stack
    #>
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Region,
    
        [Parameter()]
        [string]$StackName
    )

    Function Wait-ForStackBuild {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory)]
            [String]$StackName,

            [Parameter(Mandatory)]
            [String]$DesiredStatus
        )

        $StackStatus = (Get-CFNStack -StackName $StackName).StackStatus.Value
        While ($StackStatus.ToString() -eq $DesiredStatus.ToString()) {
            Write-Verbose $StackStatus
            Start-Sleep 10
    
            <#
                Add if statement to Remove-CFNStack if shit hits the fan
            #>
            $StackStatus = (Get-CFNStack -StackName $StackName).StackStatus.Value
        }

    }


    Write-Verbose "Locating stack"

    # Move to function
    Try {
        $StackExists = Get-CFNStack -StackName $StackName -ErrorAction 'SilentlyContinue'
        $StackExists = 1
    } Catch {
        $StackExists = 0
    }

    If ($StackExists -eq 1) {
        Write-Verbose "Found Stack"
        Write-Verbose ("{0} : Removing" -f $StackName)
        
        # Add updates as template is created so it doesn't look like its hung
        Remove-CFNStack -StackName $StackName -Region $Region -Confirm:$false

        # TODO add better status control
        # $StackStatus = (Get-CFNStack -StackName $StackName).StackStatus.Value

        Wait-ForStackBuild -StackName $StackName -DesiredStatus 'UPDATE_COMPLETE'
        # While ($StackStatus.ToString() -ne 'DELETE_COMPLETE') {
        #     Start-Sleep 10
        #     $StackStatus = (Get-CFNStack -StackName $StackName).StackStatus.Value
        # }

        Write-Verbose "Removed Stack"

    } Else {

        Write-Verbose ("{0} : Cannot locate this template" -f $StackName)
    }

}
