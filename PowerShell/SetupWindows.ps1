<# 
.SYNOPSIS Configure windows for use with these scripts
.DESCRIPTION Run this script as admin and hold onto your butt
.NOTES There is/may be place holder names and resources
#>

[CmdletBinding()]
param()


## ADD AUTO CONFIRM FLAGS!!!!


# sets policy
Set-ExecutionPolicy Unrestricted
# Powershell file
$pwshmsi = 'PowerShell-7.2.0-preview.4-win-x64.msi'
# uri
$PwshUri = ('https://github.com/PowerShell/PowerShell/releases/download/v7.2.0-preview.4/{0}' -f $pwshmsi)

Write-Verbose 'This script will try and configure your computer'
Write-Verbose 'ATM it is a best bet. Please see README.md for options and manual steps'

## Install powershell core
# get and install
Try {
    Invoke-Webrequest -uri $PwshUri -OutFile $pwshmsi -UseDefaultCredentials
    & msiexec.exe /package ($pwshmsi) /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1
} Catch {
    Write-Error 'Unable to install powershell'
    break;
}
## aws stuff
# Install aws netcore
Install-Module -Name AWSPowerShell.NetCore

# setup aws creds
# https://docs.aws.amazon.com/powershell/latest/userguide/specifying-your-aws-credentials.html

## SOMETHING IS WRONG WITH THIS LINE
Set-AWSCredential

## configure ssh on windows 10

if (Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*') {
    # install
    Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

} Else {

    # https://github.com/PowerShell/Win32-OpenSSH/releases
    # get binaries from above and drop in C:\Program Files\OpenSSH
    Write-Verbose 'Script did not detect an option to install ssh'
    Write-Verbose 'manually confiugre this'
    Write-Verbose 'We need a windows system to test this process before automation'
    Write-Verbose 'Visit this link for troubleshooting solutions'
    Write-Verbose 'https://docs.microsoft.com/en-us/powershell/scripting/learn/remoting/ssh-remoting-in-powershell-core?view=powershell-7.1'
}