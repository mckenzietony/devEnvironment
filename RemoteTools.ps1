<# 
.SYNOPSIS Connect and interact with remote instance
.DESCRIPTION Connect to a remote instance and provide interactive terminal
.NOTES There is/may be place holder names and resources
.Parameter Hostname hostname or ip of instance
.Parameter User username to use for connection
.Parameter KeyFile pem to use for connection
.Parameter Command a command to send to remote server
#>


[CmdletBinding()]
param(
    [Parameter()]
    [string]$Hostname = '54.212.9.5', #prod.nrt.brinser.subject17.net

    [Parameter()]
    [string]$Username = 'ec2-user',

    [Parameter()]
    [System.IO.Path]$KeyFile = '/home/tmckenzie/Downloads/test-ec2-key.pem',

    [Parameter()]
    [System.Array] $Command
)

#Import-Module AWSPowerShell.Netcore
$ErrorActionPreference = "Continue"
$VerbosePreference = "Continue"

Function Connect-ToInstance {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Hostname,

        [Parameter()]
        [string]$UserName,

        [Parameter()]
        $KeyFile
    )
    
    Try {
        $Session = New-PSSession -Hostname $Hostname `
        -UserName $UserName `
        -KeyFilePath $KeyFile

        Write-Verbose 'Connected to remote host'
    } Catch {
        Write-Error 'Connection was not established'

        $Error
    }

    Return $Session
}

Function Stop-Session {
    [CmdletBinding()]
    param(
        $Session
    )

    Try {
        Remove-PSSession -Session $Session

        Write-Verbose 'Disconnnected from session'
    } Catch {
        Write-Error 'Unable to disconnect from session'
        break;
    }
}

Function Invoke-RemoteCommand {
    [CmdletBinding()]
    param(
        $Session,

        $Command
    )

    If (!($Session)) {
        $ConnectionSplat = @{
            'Hostname' = $Hostname;
            'UserName' = $Username;
            'KeyFile' = $KeyFile
        }
        
        Try {
            $Session = Connect-ToInstance @ConnectionSplat
            Write-Verbose 'Session established'
        } Catch {
            Write-Error 'Unable to establish session'
            Write-Error 'Please provide session token and try again'
        }
    }

    Try {
        $Response = Invoke-Command -Session $Session `
         -scriptblock {param($remoteCmd). Invoke-Expression $remoteCmd} `
         -ArgumentList $Command


    } Catch {
        Write-Error ("Unable to invoke command: {0}" -f $Command)

        $Error
        break;
    }

    Return $Response
}

# some stock commands
# maybe we can have a switch statement with common stuff?


# $code_ls = @"
# ls
# "@

# $code_javac = @"
# javac Main.java
# "@

# $ConnectionSplat = @{
#     'Hostname' = 54.212.9.5;
#     'UserName' = 'ec2-user';
#     'KeyFile' = '/home/tmckenzie/Downloads/test-ec2-key.pem'
# }

# Invoke-RemoteCommand `
# -Session $Session`
# -Command $code_javac

# Invoke-RemoteCommand `
# -Session $Session`
# -Command $code_ls

# Stop-Session -Session $Session