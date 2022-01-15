<# 
.SYNOPSIS Control the Trader-App
.DESCRIPTION Allows the user to stand up, tare down and ssh into the Trader-App
.AUTHOR mckenzietony@
.COMPONENT Requires AWSPowerShell.Netcore be available and configured locally
.PARAMETER Region The region obviously
.EXAMPLE Get-TraderAppMenu -Region 'ap-northeast-1'
.NOTE New-TraderInstance has hard coded values such as 'prod-trader-nrt'
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$Region = 'ap-northeast-1',
    [Parameter()]
    [string]$EC2KeyPair = 'prod-trader-nrt',
    [Parameter()]
    [string]$AMI = 'ami-0ad5a3959c516f3a5',
    [Parameter()]
    [string]$UserData = '../333153126918_prod/Terraform/trader_app/autoscaling_userdata.sh'       
)

$ErrorActionPreference='Continue'
$VerbosePreference='SilentlyContinue'
$Meme =@'
    
 QQQQQQQQQ#OOOOddHdO9e}/\||/lS6dDR88qk8&88Dkyu]vJ{{{{tttJJsJJJzv]]y6HDDDDDKazr=;',/;/ukdHDHHHdHHHHddddOOOOOOOOOOOOOOO
 QQQ#RHK9O6kU9KdDDDqev^r:.'/:?]EHR8RDe9qEe}ci\\clvzJJzzvlL/\\|\LLzyeX69OHd$uL;^'  |~>se9qUEXmwPUqKKqUPeaoyyySoZeP69KO
 #D6SzL|*=r>>?\7]2S}/;~^'  ?,:^veqK9XF/\r;::_::;^*|/ic/|r;;:::::;;;^r?LFeEe]\:^'  |,;L}u{c|r^r*\lvstv\r;:::::;;^r|/va
 Xs??;::"~~":::;r^r^;;;:`  ,_:|r7]]7?;;:_,,,,,::;,,:^*r;_|~,*,;:_,,,_:;_^7]7^,;'  ?',:;^;^;"_|\^^;:";;:,,,,,,~_:;:;rz
 cr^` -"::::_,'`:/;;:;;_`  ,~_|;||r:r:` ',,,,,` `::',;:"'r  '::,,,,'  `;_:?*:';'  |'''';;. ,;:;>=;'^, `,":::~,'`'|;?u
 >\` ,|::::__:;^;:^=r:,^'  ?,";?|r:>' `^"''''';:  :_.,"''^  ,^:,''':^.  *':^;,^'  |''::.`:;,,:*|r:~:  ?,,,,,,,,:;';cy
 |?, `":;;;;;;;;~;?/\r_^'  *':|vi^_|  ::-,:;:,'?- `r-',''r  r,_^;:_,;>  *',;;,^'  ?:;'  ^:,,:r||r:,r  ,:::::;:::',^ij
 Fr;;::_,,,,'` `:r;>|r";'  *':^|L^,|  ;,',^r;:'?' `>-',',r  >,;Li>;,:?  *'':;,r'  '-'::` :;',;zj{/;,::~,,,,,,- `,^:rv
 2=:::::::::;;r  :;;^;';'  *',;^;:'|  ,;'',:"''*` `r',,,,r  >,;iu\^,:?  *''_;~^'  ';;,,^, `;_,^\\?;'''.,,,,,,_;, `|:/
 v?;:;^;;:::;^;  ;;;>^:;,  ;::::;:,::  :::,,_::.  ^",::_,r  r'_?ju?_"*  *',;;,;'  ?'',,':;` ";',_,:;:::;:,,,,:;' -*;L
 {?:'``.,,,,'``,;>>lJz|;*'  `'/:;;:_:;,` `'''` .";:;|L\r:r  >:rvaot>;?  *,;rr;^'  |,;?|*;:^, -;"',=:,``-',,,'``.:r;|F
 au|**r;;;;;;^*=?voP$Uaz**^;;;?^r*|*^::;:::":::::;|fXPat?/^^/|seUUez|/^^/*izv\|?^r\?soeZF/rr^;^\;;;;;^;;:::::;^^;?v2E
 gB&kmeSFJsJ}uoX$ORgNDK6ejzi||\?*|||?r^;;::~_:^|/tek66PmSFJJFSm6$$6m2FtJFSemmaj}sJfoX9KK$wofJvvJFuju]zc\\|||\LvJue6Kd

'@

Write-Host $Meme

try {
    Import-Module AWSPowerShell.NetCore
} Catch {
    Install-Module -Name AWSPowerShell.NetCore
    Import-Module -Name AWSPowerShell.NetCore
    Set-AWSCredentials
}


function Set-TraderASGDown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
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

    Return ' ASG scaled down to zero'
}

function Set-TraderASGUp {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [string]$Region,

        [Parameter(Mandatory=$True)]
        [string]$DesiredAmount
    )    

    $WhereFilter = 'asg'
    $AsgName = (Get-ASAutoScalingGroup `
        -Region $Region).AutoScalingGroupName

    foreach ($name in $AsgName | Where-Object {$_.ToString() -eq $WhereFilter}) {

        Set-ASDesiredCapacity `
            -autoscalinggroupname $name `
            -desiredcapacity $DesiredAmount `
            -Region $Region
    }

    Return ("Trader is coming online with {0} instances" -f $DesiredAmount)
}

function Get-TraderInstances {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [string]$Region
    )   

    $Counter = 5

    Write-Verbose 'Retrieving instance details'

    do {
        if ($Counter -le 0) {
            Write-Warning ' maximum retry exceeded'
            Write-Warning ' no instances found for the auto scaling group'
            break
        }

        $InstanceByTag = (Get-RGTResource -Region $Region `
            -TagFilter @{Key="Name"; Values = @("trader-app")}).ResourceARN
        
        $Instances = @()
        foreach ($instance in $InstanceByTag) {
            $Instances += ($instance.Split('/')[1])
        }

        if (!$Instances) {
            $Counter--
            Start-Sleep 1

        } else {
            Write-Verbose 'Instance details found'
        }

    } while (!$Instances)

    Write-Verbose 'locating public IP address'

    $InstanceObj = @()
    $Ecr = '333153126918.dkr.ecr.ap-northeast-1.amazonaws.com/worker:latest'
    #$MikesKey = '-i D:\volatility-arbitrage\james-test-key-nrt.pem'
    foreach ($Instance in $Instances) {
        $InstanceDetails = (Get-EC2Instance `
            -Region $Region `
            -InstanceId $Instance).Instances

        #  -i D:/volatility-arbitrage/james-test-key-nrt.pem
        if ($InstanceDetails.State.Name.Value -eq 'running'){
            $InstanceObj += [PSCustomObject][Ordered]@{
                Az = (Get-EC2Subnet `
                    -SubnetId $InstanceDetails.SubnetId `
                    -region $Region).AvailabilityZone
                InstanceType = $InstanceDetails.InstanceType
                InstanceId = $InstanceDetails.InstanceId
                InstanceIP = $InstanceDetails.PublicIpAddress
                Ssh = (
                    "ssh -t ec2-user@{0}" -f `
                    $InstanceDetails.PublicIpAddress
                )
                DockerRun = (
                    "docker run -it --network host {0}" -f $Ecr
                )
                SshToDocker = (
                    "ssh -t ec2-user@{0} docker run -it --network host {1}" -f `
                    $InstanceDetails.PublicIpAddress, $Ecr
                )
            }   
        }
    }

    Return $InstanceObj
}

function Get-TraderConnection {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [string]$Region,
        [Parameter(Mandatory=$True)]
        [string]$Az
    )

    $InstanceObj = Get-TraderInstances -Region $Region

    switch ($Az) {
        'a' {$az = 'ap-northeast-1a'}
        'c' {$az = 'ap-northeast-1c'}
        default {Write-Error -Message 'Not a valid az'}
    }

    If ($InstanceObj) {
        Write-Host "How do you want to connect to the trader-app?"
        $Option = (Get-ValidInput -Prompt "ssh or docker" -ValidInput ('ssh', 'docker')).ToLower()
    
        Foreach ($instance in $InstanceObj | Where-Object {$_.Az -eq $Az}) {
            # nslookup is too slow to use
            # # we drop ICMP packets so we can't ping test here. Using nslookup as a "good enough"
            # If (((nslookup $instance.InstanceIP)[0]).Split("= ")[1] -like 'ec2*') {
            #     If ($Option -eq 'ssh') {
            #         pwsh -Command $instance.Ssh
    
            #     } else {
            #         pwsh -Command $instance.SshToDocker
            #     }
            # } else {
            #     Write-Warning ('Instance is unreachable: {0}' -f $instance.InstanceIP)
            # }
            If ($Option -eq 'ssh') {
                pwsh -Command $instance.Ssh

            } else {
                pwsh -Command $instance.SshToDocker
            }
        }
    } 
    else {
        Write-Host ' No instances to connect to'
    }
}

Function New-TraderInstance {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [string]$Region,
        [Parameter(Mandatory=$True)]
        [string]$Az,
        [Parameter(Mandatory=$True)]
        [string]$InstanceType,
        [Parameter()]
        [string]$UserData,
        [Parameter()]
        [string]$EC2KeyPair,
        [Parameter()]
        [string]$AMI              
    )

    If (Test-Path -Path $UserData) {
        $UserData  = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes((get-content $UserData -Raw)))

    } Else {
        # Hard coded userdata to make script portable
        $UserData = 'IyEvYmluL2Jhc2gKCmVjaG8gRUNTX0NMVVNURVI9dHJhZGVyLWJvaXMgPj4gL2V0Yy9lY3MvZWNzLmNvbmZpZwoKeXVtIHVwZGF0ZSAteQp5dW0gaW5zdGFsbCAteSB5dW0tdXRpbHMKYW1hem9uLWxpbnV4LWV4dHJhcyBpbnN0YWxsIGVwZWwgLXkKCiMgUmVnaXN0ZXIgdGhlIE1pY3Jvc29mdCBSZWRIYXQgcmVwb3NpdG9yeQpjdXJsIGh0dHBzOi8vcGFja2FnZXMubWljcm9zb2Z0LmNvbS9jb25maWcvcmhlbC83L3Byb2QucmVwbyB8IHN1ZG8gdGVlIC9ldGMveXVtLnJlcG9zLmQvbWljcm9zb2Z0LnJlcG8KCiMgSW5zdGFsbCBQb3dlclNoZWxsCnl1bSBpbnN0YWxsIHBvd2Vyc2hlbGwgLXkKCiMgQWxsb3cgYWNjZXNzIHVzaW5nIHBvd2Vyc2hlbGwKZWNobyAiICAiID4+IC9ldGMvc3NoL3NzaGRfY29uZmlnCmVjaG8gIiMgUG93ZXJzaGVsbCBTdWJzeXN0ZW0gLS0gQWxsb3cgcHdzaCByZW1vdGluZyIgPj4gL2V0Yy9zc2gvc3NoZF9jb25maWcKZWNobyAiU3Vic3lzdGVtIHBvd2Vyc2hlbGwgL3Vzci9iaW4vcHdzaCAtc3NocyAtTm9Mb2dvIiA+PiAvZXRjL3NzaC9zc2hkX2NvbmZpZwoKZWNobyAic3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUNPdDRaQk04dUFnN1NrVmo0aDZpdzRkc1NQUmFDNGJnK2NtNDhNNGhWbXIgdG1ja2VuemllQHZlc3V2aXVzIiA+PiAvaG9tZS9lYzItdXNlci8uc3NoL2F1dGhvcml6ZWRfa2V5cwplY2hvICJzc2gtcnNhIEFBQUFCM056YUMxeWMyRUFBQUFEQVFBQkFBQUJBUUN6ekxja2FlT05XTjZpRkQ0QVY0c05zZllodkxVRUlFUE5jWndobFdCSWpNZndENGxWbytrN1owdWVyMjcyZVhUT1VkNUQ2Q1ZOMXd0SzR5d3BPR2JKRUZkZnJxSHhWZTQwNXZodmF0SEExRkpJN2tNOEd6NXNJejJIY1ZlYlcyaGxUdjJ4bWlwYmdsZUVxNFlSQWY1SmNMNnM1NkUrT0crYmZFcTlwUUQxSDJzYk1CcnErb3h4QTVNL2lhZSt0MmV2VFU4T1Rmb1loTlgwRnYzSDNzYmtDSWoxWUdHd0lIakFsU2s0NkVHR0NkWUF2UHlPRGtEZndoUjZjTXQxMEM1ekdHNUx3NTBkZWpHVjRObGwwbndacHlnYnJyRVl3L3JiQVZ5VSt1bnI2U25hUFdrRis5UUNJcDBrU0ZmQXR6cjJWZjFZZDlabVRKUGxzZTVkMXlvdiBqYW1lcy10ZXN0LWtleS1ucnQiID4+IC9ob21lL2VjMi11c2VyLy5zc2gvYXV0aG9yaXplZF9rZXlzCmVjaG8gInNzaC1lZDI1NTE5IEFBQUFDM056YUMxbFpESTFOVEU1QUFBQUlLR0tiSjZIdUR6NWlpWTI0cWkxdkN4OGxNSTkveG1lSnJSOWtxTENJTmlwIGphbWVzQGNhbnRvciIgPj4gL2hvbWUvZWMyLXVzZXIvLnNzaC9hdXRob3JpemVkX2tleXMKZWNobyAic3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUxFaW45c2xwUW9qK2hFQ09QckZUZFFLdTUxNldiMUVtU051STZ1elowRFggamFtZXNAbGFwbGFjZSIgPj4gL2hvbWUvZWMyLXVzZXIvLnNzaC9hdXRob3JpemVkX2tleXMKZWNobyAic3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUtHS2JKNkh1RHo1aWlZMjRxaTF2Q3g4bE1JOS94bWVKclI5a3FMQ0lOaXAgamFtZXNAY2FudG9yIiA+PiAvaG9tZS9lYzItdXNlci8uc3NoL2F1dGhvcml6ZWRfa2V5cwplY2hvICJzc2gtcnNhIEFBQUFCM056YUMxeWMyRUFBQUFEQVFBQkFBQUJnUURiL2JkWE1iVVl1TVZzcXBVU0ZEV0FNV05SdzBtVnVwVjErdG1kejRlUHVJQlVueE9BMXdxQTZXVGNXREphQ1RrMjdpWm1pV1Z2OHlscnZKZVF2d1duUXphaFVsdXFkVWtUd3ozTVdBRks5L0ozc2JyUzVQQUQxSEd6ei9QZzArak5vSnY5cjc2dmVPS1BvRkt3Z0NCMEJOYWhtWmxsY2pPa256RWZJYVYvWERZZ0JORVYybWsxM09ERVVLOTYyQ09iSkZjd2ViKzkxNFJmT0w3MmUxMGh1OUh5MkY0SGpJT01yTUtMTjIyY1FDSlZLOXZsTVNKU3V0aFNYeUJlTUFYUlNaS24xSVEyL1c5bW9SZzlDWHpEbmJKTEhUMytneGpoOHpJUkFvRk44QUk5SnlvTkIwTFMwei9yc3NZelRheUN6aFlBSHRtTXg0dVQrdTliUkpaN2tPYXdPYVBJdmQ2MUtGVUVZZGlQa3ZoZWdMY1hUcE5ublNDNGJhajZock1SM1FiUEtnVFY0M1VEdWhqdE5EeFZzcDYybGFWUGNjRS9LalhnYWx3dzJnMUdORy9wdWJTMWRDdzNkL1lTRjkvaWNqTDFpSXNjczQvQ1IwSHFnWUdJaVpWZ1hHRXA2U01LcklDUk94SzNKOTl6SkNUMVBTNkJDTU94bFhncFMzTT0gdXNlckBQcmltYXJ5IiA+PiAvaG9tZS9lYzItdXNlci8uc3NoL2F1dGhvcml6ZWRfa2V5cwpzeXN0ZW1jdGwgcmVzdGFydCBzc2hkCgojIGNvbmZpZ3VyZSBzeXN0ZW0gcGVyZm9ybWFuY2UgcHJvZmlsZSBhbmQgcmV0dXJuIHJlc3VsdAp5dW0gaW5zdGFsbCB0dW5lZCAteQpzeXN0ZW1jdGwgc3RhcnQgdHVuZWQKc3lzdGVtY3RsIGVuYWJsZSB0dW5lZAp0dW5lZC1hZG0gcHJvZmlsZSBsYXRlbmN5LXBlcmZvcm1hbmNlCnR1bmVkLWFkbSBhY3RpdmUKCmVjaG8gIlB1bGxpbmcgZG9ja2VyIGltYWdlcyAtIHRoaXMgd2lsbCB0YWtlIHNvbWUgdGltZSIKIyBGb3JjZSBwdWxsIHRoZSBpbWFnZSB0byBjb25maXJtIHdlIGFyZW4ndCB3YWl0aW5nIGZvciBlY3MgdG8gcXVldWUgdXAgLS0KIyBUT0RPIGludmVzdGlnYXRlIHdoeSBlY3Mgc29tZXRpbWVzIHRha2VzIGEgd2hpbGUgdG8gZ3JhYiB0aGUgbmV3IGRvY2tlciBpbWFnZQp5dW0gaW5zdGFsbCBhd3NjbGkgLXkKYXdzIGVjciBnZXQtbG9naW4tcGFzc3dvcmQgLS1yZWdpb24gYXAtbm9ydGhlYXN0LTEgfCBkb2NrZXIgbG9naW4gLS11c2VybmFtZSBBV1MgLS1wYXNzd29yZC1zdGRpbiAzMzMxNTMxMjY5MTguZGtyLmVjci5hcC1ub3J0aGVhc3QtMS5hbWF6b25hd3MuY29tCmRvY2tlciBwdWxsIDMzMzE1MzEyNjkxOC5ka3IuZWNyLmFwLW5vcnRoZWFzdC0xLmFtYXpvbmF3cy5jb20vd29ya2VyOmxhdGVzdAo='
    }
    $AsgDetails = (Get-ASAutoScalingGroup -Region $Region)
    
    $Subnets = ($AsgDetails.VPCZoneIdentifier).Split(',')
    $Subnet = (get-ec2subnet -SubnetId $Subnets[0] -Region $Region)
    if ($Az.ToLower() -eq ($Subnet.AvailabilityZone)[-1]) {
        $SubnetId = $Subnets[0]

    } else  {
        $SubnetId = $Subnets[1]
    }

    # creates ec2 tags
    $TagSpecification = [Amazon.EC2.Model.TagSpecification]::new()
    $TagSpecification.ResourceType = 'Instance'

    $tags.PSObject.Properties | ForEach-Object {
        $tag = [Amazon.EC2.Model.Tag]@{
            Key   = 'Name'
            Value = 'trader-app'
        }
        $TagSpecification.Tags.Add($tag)
    } 
    
    $Details = (New-EC2Instance `
    -ImageId $AMI -AssociatePublicIp $True `
    -InstanceType $InstanceType `
    -KeyName $EC2KeyPair `
    -SecurityGroupId 'sg-0f9ba95fce336030d' `
    -SubnetId $SubnetId `
    -Region $Region `
    -UserData $UserData `
    -IamInstanceProfile_Name 'ecs-agent' `
    -TagSpecification $TagSpecification)

    Return (' Created Instance: {0}' -f ($Details.Instances.InstanceId).ToString())
}

function Remove-TraderAppsInstances {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Region,
        [Parameter()]
        [string]$InstanceId        
    )

    If (!$InstanceId) {
        $Instances = (Get-TraderInstances -Region $Region).InstanceId

        foreach ($instance in $instances) {
            Remove-EC2Instance -InstanceId $Instance -Region $Region -Force | Out-Null
        }

        Set-TraderASGDown -Region $Region

    } else {
        Remove-EC2Instance -InstanceId $InstanceId -Region $Region -Force | Out-Null
    }

    Return ' Killing Trader-App'

}

Function Get-ValidInput {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True)]
        [string]$Prompt,
        [Parameter()]
        [Array]$ValidInput
    )

    do {
        $ValidInput += 'q'
        Write-Host "type 'q' to return to previous menu"
        $UserInput = (Read-Host -Prompt $Prompt)
        $GoodInput = $ValidInput.Contains($UserInput.ToString())

    } while (!$GoodInput)

    if ($UserInput -eq 'q') {
        break
    }

    Return ($UserInput).ToString()
}
Function Get-TraderAppMenu {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Region,
        [Parameter()]
        [string]$EC2KeyPair = $EC2KeyPair,
        [Parameter()]
        [string]$AMI = $AMI,
        [Parameter()]
        [string]$UserData = $UserData    
    )


    $PrompOptions =@'
Select one of the following:
 1 - Shutdown all running Trader-App ASG EC2 instances
 2 - Bring Trader-App ASG Online/Change quantity of EC2 ASG instances
 3 - List all Trader-App EC2 instance info
 4 - Create new, single Trader-App EC2 instance
 5 - Connect to Trader-App over ssh or directly to Docker
 6 - Kill all Trader-App EC2 instances
 7 - Kill Trader-App EC2 Instance by Id
 q - Exit this utility
'@

    $Exit = $False
    Write-Host 'Welcome to Trader-App Menu v0.1'

    Do {
        Write-Host $PrompOptions
        $Option = (Read-Host -Prompt "trader-app >")

        Switch ($Option) {
            1 {
                Write-Host ' Setting ASG to 0 capacity'
                Set-TraderASGDown -Region $Region
            }         
            2 {
                $InstanceCount = (Read-Host -Prompt "How many ASG EC2 instances do you want - 1 or 2 is generally sane")
                Set-TraderASGUp -Region $Region -DesiredAmount $InstanceCount

                Write-Host ' Bringing Trader-App online - list details for additional information'
                Write-Host ' It may take several minutes for Trader-App to become available'
            }
            3 {
                $InstanceDetails = (Get-TraderInstances -Region $Region)

                if ($InstanceDetails) {
                    Write-Host ' Copy/paste the ssh or docker line into another console to connect'
                    Write-Host ' You can also use option 5 to connect to the EC2/AZ pair.'
                    $($InstanceDetails)

                } else {
                    Write-Host ' No instances found. If they were started recently, try again shortly'
                }
            }
            4 {
                $AvailbilityZone = (Get-ValidInput -Prompt "Which AZ do you want this trader-app in [a,c]?" `
                    -ValidInput ('a', 'c'))
                $InstanceType = (Read-Host -Prompt 'Instance type [t2.micro]?')
                New-TraderInstance -Region $Region `
                    -Az $AvailbilityZone `
                    -InstanceType $InstanceType `
                    -AMI $AMI `
                    -EC2KeyPair $EC2KeyPair `
                    -UserData $UserData
            }
            5 {
                $AvailbilityZone = (Get-ValidInput -Prompt 'Which AZ do you want to connect to [a,c]?' `
                -ValidInput ('a', 'c'))
                Get-TraderConnection -Region $Region -Az $AvailbilityZone
            }
            6 {
                $Kill = (Get-ValidInput -Prompt 'Are you absolutely sure you want to kill all Trader-App instances [y]' `
                -ValidInput ('y'))
                If ($kill.ToLower() -eq 'y'){
                    Remove-TraderAppsInstances -Region $Region
                } Else {
                    Write-Host 'Trader-App wil remain up - no action taken'
                }
            }
            7 {
                $Id = (Read-Host -Prompt 'InstanceId [i-0e3cfbccc4abb0a9c]')
                $Kill = (Get-ValidInput -Prompt 'Are you absolutely sure you want to kill this Trader-App instance [y]' `
                    -ValidInput ('y'))
                If ($kill.ToLower() -eq 'y'){
                    Remove-TraderAppsInstances -Region $Region -InstanceId $Id
                } Else {
                    Write-Host 'Trader-App wil remain up - no action taken'
                }
            }            
            'q' {$Exit = $True}

            default {
                Write-Host 'Not a valid option'
            }
        }

    } While ($Exit -ne $True)
}

Get-TraderAppMenu -Region $Region