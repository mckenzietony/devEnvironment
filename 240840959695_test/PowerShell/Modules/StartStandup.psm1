<# 
.SYNOPSIS Stand up the environment
.DESCRIPTION This script will create a cloudformation based environment and necessary resources
.NOTES There is/may be place holder names and resources
.COMPONENT Requires AWSPowerShell.Netcore be available and configured locally
.Parameter Region The region obviously
.Parameter Stage dev/stage/prod etc
.Parameter StackName friendly name of the cloudformation stack
.Parameter S3BucketName name of the bucket in which to upload code
.Parameter SSHKeyName name of the ssh key the instance will run under - for use with ssh
.Parameter InstanceType size of instance - t2.micro is free tier
.Parameter Template location of the cloudformation template to use with the environment
.Parameter ServerCode code to upload to s3 and use on the the ec2 instance
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$Region,

    [Parameter()]
    [string]$Stage,

    [Parameter()]
    [string]$StackName,

    [Parameter()]
    [string]$S3BucketName,

    [Parameter()]
    [string]$SSHKeyName,

    [Parameter()]
    [string]$InstanceType,

    [Parameter()]
    [string]$Template,

    [Parameter()]
    [String]$ServerCode
)


#Import-Module AWSPowerShell.NetCore

$ErrorActionPreference = "Continue"
$VerbosePreference = "Continue"


Function Deploy-Stack{
    <# 
    .SYNOPSIS Deploy the stack
    .DESCRIPTION Build and manage creation and updates of the environment
    .NOTES There is/may be place holder names and resources
    .COMPONENT Requires AWSPowerShell.Netcore be available and configured locally
    .Parameter Region The region obviously
    .Parameter Stage dev/stage/prod etcreally digging this.
    .Parameter StackName friendly name of the cloudformation stack
    .Parameter S3BucketName name of the bucket in which to upload code
    .Parameter SSHKeyName name of the ssh key the instance will run under - for use with ssh
    .Parameter InstanceType size of instance - t2.micro is free tier
    .Parameter Template location of the cloudformation template to use with the environment
    #>

    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Region,
    
        [Parameter()]
        [string]$Stage,
    
        [Parameter()]
        [string]$StackName,
    
        [Parameter()]
        [string]$S3BucketName,
    
        [Parameter()]
        [string]$SSHKeyName,
    
        [Parameter()]
        [string]$InstanceType,
    
        [Parameter()]
        [string]$Template
    )

    Function Wait-ForStackBuild {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory)]
            [String]$StackName,

            [Parameter(Mandatory)]
            [String]$DesiredStatus
        )

        # move this to do/while - current logic is stupid 
        # oh, and make it an external function
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

    # Super Lazy mapping --
    # TODO make dynamic
    $ParRegion = New-Object -TypeName Amazon.CloudFormation.Model.Parameter
    $ParRegion.ParameterKey = 'Region'
    $ParRegion.ParameterValue = $Region

    $ParStageName = New-Object -TypeName Amazon.CloudFormation.Model.Parameter
    $ParStageName.ParameterKey = 'Stage'
    $ParStageName.ParameterValue = $Stage

    $ParS3BucketName = New-Object -TypeName Amazon.CloudFormation.Model.Parameter
    $ParS3BucketName.ParameterKey = 'S3BucketName'
    $ParS3BucketName.ParameterValue = $S3BucketName

    $ParKeyName = New-Object -TypeName Amazon.CloudFormation.Model.Parameter
    $ParKeyName.ParameterKey = 'KeyName'
    $ParKeyName.ParameterValue = $SSHKeyName

    $ParInstanceType = New-Object -TypeName Amazon.CloudFormation.Model.Parameter
    $ParInstanceType.ParameterKey = 'InstanceType'
    $ParInstanceType.ParameterValue = $InstanceType

    $ParServerCode = New-Object -TypeName Amazon.CloudFormation.Model.Parameter
    $ParServerCode.ParameterKey = 'ServerCode'
    $ParServerCode.ParameterValue = $ServerCode

    # example dynamic shit
    # $ParamList = @('Region', 'StageName', 'S3BucketName', 'KeyName', 'InstanceType')
    # $ParametersCol = @()
    # ForEach ($Param in $ParamList){
    #     $ParamName = $Param
    #     $Param = (New-Object -TypeName Amazon.CloudFormation.Model.Parameter)
    #     $Param.ParameterKey = $ParamName
    #     $Param.ParameterValue = $

    #     $ParametersCol += $Param
    # }
    
    Write-Verbose "Locating stack"

    # Move to function
    Try {
        $StackExists = Get-CFNStack -StackName $StackName -ErrorAction 'SilentlyContinue'

    } Catch {
        $StackExists = 0
    }


    If ($StackExists -ne 0) {
        Write-Verbose ("{0} : Already exists" -f $StackName)
        Write-Verbose ("{0} : Performing update operation" -f $StackName)
        Try {
            Update-CFNStack -StackName $StackName -TemplateBody $template -Parameter `
            $ParRegion, $ParStageName, $ParS3BucketName, $ParKeyName, $ParInstanceType, $ParServerCode `
            -capabilities 'CAPABILITY_NAMED_IAM'
        } Catch{
            Write-Verbose 'No updates to be performed'
        }

        Wait-ForStackBuild -StackName $StackName -DesiredStatus 'UPDATE_COMPLETE'

    } Else {
        Write-Verbose "Stack does not exist"
        Write-Verbose ("{0} : Creating" -f $StackName)
        
        # Add updates as template is created so it doesn't look like its hung
        New-CFNStack -StackName $StackName -TemplateBody $template -Parameter `
        $ParRegion, $ParStageName, $ParS3BucketName, $ParKeyName, $ParInstanceType, $ParServerCode `
        -capabilities 'CAPABILITY_NAMED_IAM'

        Wait-ForStackBuild -StackName $StackName -DesiredStatus 'Create_Complete'
    }

    # This will loop forever if the stack doesn't create perfectly.
    # TODO add better status control

    # $StackStatus = (Get-CFNStack -StackName $StackName).StackStatus.Value

    # While (($StackStatus -ne 'Create_Complete') -or ($StackStatus -ne 'UPDATE_COMPLETE')) {
    #     Write-Verbose $StackStatus
    #     Start-Sleep 10

    #     <#
    #         Add if statement to Remove-CFNStack if shit hits the fan
    #     #>
    #     $StackStatus = (Get-CFNStack -StackName $StackName).StackStatus.Value
    # }

    Write-Verbose "Cloudformation succesfully updated"

}

# This may introducce a race condition with the instance stand up
# if the file isn't availble on the server it can be manually downloaded
# aws s3 cp s3://test-us-west-2-controlplane-code/DummyCode.sh DummyCode.sh
# chmod +x DummyCode.sh
Function Invoke-S3CodeUploader {
    <# 
    .SYNOPSIS Lazy s3 uploader
    .DESCRIPTION Uploads some code to s3 - this is a placeholder for a more robust soln
    .NOTES There is/may be place holder names and resources
    .COMPONENT Requires AWSPowerShell.Netcore
    .Parameter S3BucketName name of the bucket in which to upload code
    .Parameter ServerCode code to upload to s3 and use on the the ec2 instance
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]$S3BucketName,

        [Parameter(Mandatory)]
        [String]$ServerCode
    )

    Write-Verbose "uploading files"
    Write-S3Object -BucketName $S3BucketName -File $ServerCode
}