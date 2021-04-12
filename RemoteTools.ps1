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
# param(
#     [Parameter()]
#     [string]$Hostname,

#     [Parameter()]
#     [string]$Username,

#     [Parameter()]
#     [System.IO.Path]$KeyFile,

#     [Parameter()]
#     [System.Array] $Command
# )

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

Function Invoke-Trader {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Hostname, #prod.nrt.brinser.subject17.net
    
        [Parameter(Mandatory=$true)]
        [string]$Username,
    
        [Parameter(Mandatory=$true)]
        [string]$KeyFile,
    
        [Parameter(Mandatory=$true)]
        [string] $Command,

        [Parameter()]
        [switch] $StartTrader,

        [Parameter()]
        [switch] $StopTrader
    )

    Write-verbose ("Connecting to Trader at: {0}" -f $Hostname)

    if (Test-Connection -Count 1 $Hostname) {
        Write-Verbose "Host has been reached"

        if (!($StartTrader -or $StopTrader)) {
            ssh -t -i $KeyFile ("{0}@{1}" -f $Username, $Hostname) $Command
        }

        if ($StartTrader -and !$StopTrader) {
            ssh -i $KeyFile ("{0}@{1}" -f $Username, $Hostname) 'echo "FAKE: Starting Trader"'

            Write-Verbose "Trader has been started"
        }

        if ($StopTrader -and !$StartTrader) {
            ssh -i $KeyFile ("{0}@{1}" -f $Username, $Hostname) 'echo "FAKE: Stopping Trader'

            Write-Verbose "Trader has been stopped"
        }

    
    } Else {
        Write-Error ("Unable to reach host: {0}" -f $Hostname)
    }

    Write-Verbose "Closing connection to Trader"
    # exit code true/false
    Return $?
}

# modify with actual trader location
$TraderSplat = @{
    Hostname = 'prod.nrt.brinser.subject17.net'
    UserName = 'ec2-user';
    KeyFile = '~/Downloads/test-trader-nrt.pem';
    Command = 'java -cp volatility-1.0-SNAPSHOT-jar-with-dependencies.jar LauncherKt' 
}

Invoke-Trader @TraderSplat