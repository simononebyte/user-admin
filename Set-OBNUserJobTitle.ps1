<#
.SYNOPSIS
Sets the job title on a  user.

.PARAMETER Identity
The identity of the account you want to set the job title on

.PARAMETER JobTitle
The job title to set for the user

.PARAMETER ConfigPath
The default configu path is C:\ProgramData\Onebyte\Config.json. This will allow
an alternative path to be used.

.EXAMPLE
.\Set-OBNUserJobTitle.ps1 -Identity SBuckner -job title "Procurement Manager"
 
Set the job title for SBuckner to 'Procurement Manager'

.EXAMPLE
.\Set-OBNUserJobTitle.ps1 -Identity SBuckner, SRiches -job title "Procurement Manager"
 
Set the job title for SBuckner & SRiches to 'Procurement Manager'

.EXAMPLE
Get-ADUser -Filter "*" -SearchBase "dc=ad,dc=local" | .\Set-OBNUserJobTitle -job title "Procurement Manager"
 
Set the job title to 'Procurement Manager' for all users in the AD.

.NOTES
Author : Simon Buckner
Email  : simon@onebyte.net
Date   : 17th December 2019

.INPUTS
This script takes identity objects from the pipeline

.OUTPUTS
None

.LINK
Internal documentation: 
Github Repository: https://github.com/simononebyte/user-admin

#>

[CmdletBinding(SupportsShouldProcess = $True)]
Param(
  [Parameter(
    Mandatory = $True,
    Position = 0,
    ValueFromPipeline = $True,
    ValueFromPipelineByPropertyName = $True
  )]
  [ValidateLength(1, 256)]
  [String[]]$Identity,

  [Parameter(
    Mandatory = $True,
    Position = 1,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$JobTitle,

  [Parameter(
    Mandatory = $false,
    Position = 99,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  # [String]$ConfigPath="C:\ProgramData\Onebyte\config.json"
  [String]$ConfigPath = ".\config.json"
)

BEGIN {

  # Run one-time set-up tasks here, like defining variables, etc.
  Set-StrictMode -Version Latest
  Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Started."

  # Declare any supporting functions here
  # #########################################################################
  # Dot source all necessary scripts
  $Path = ".\ps\"
  Get-ChildItem -Path $Path -Filter "*.ps1" | ForEach-Object {
    if ( $_.Name -notlike "*.ps1xml") {
      Write-Verbose "dot Sourcing $($_.Fullname)"
      . $_.FullName
    }
  }

 
  if (-not (isElevated) ) {
    Write-Error "elevated session required"
    Exit
  }
}


Process {
  # Place all script elements within the process block to allow processing of
  # pipeline correctly.
    
  # The process block can be executed multiple times as objects are passed through the pipeline into it.
  ForEach ($user In $Identity) {
    setJobTitleitle -adUser $user -jobTitle $JobTitle
  }
}

END {       
  # Finally, run one-time tear-down tasks here.
  Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Complete."
}
