<#
.SYNOPSIS
Sets the office details ona  user.

.DESCRIPTION
Using previously stored values, this scripts sets office details 
like address and office phone number. Each stored address is given
2 or 3 character code.

.PARAMETER Identity
The identity of the account you want to set the office details on

.PARAMETER OfficeCode
The 2 or 3 character code for the offce you want to use

.PARAMETER ConfigPath
The default configu path is C:\ProgramData\Onebyte\Config.json. This will allow
an alternative path to be used.

.EXAMPLE
.\Set-OBNUserOffice.ps1 -Identity SBuckner -OfficeCode ldn
 
Set the office details for SBuckner to those for the 'ldn' office.

.EXAMPLE
.\Set-OBNUserOffice.ps1 -Identity SBuckner, SRiches -OfficeCode ldn
 
Set the office details for SBuckner & SRiches to those for the 'ldn' office.

.EXAMPLE
Get-ADUser -Filter "*" -SearchBase "dc=ad,dc=local" | .\Set-OBNUserOFfice.ps1 -Office ldn
 
Set the office details to those for 'ldn' for all users in the AD.

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
  [ValidateLength(1, 3)]
  [String]$OfficeCode,

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

 
  $config = loadConfig -Path $ConfigPath
  if ($config.RequireElevated -eq $true) {
    if (-not (isElevated) ) {
      Write-Error "elevated session required"
      Exit
    }
  }

  $office = checkOfficeCode -officeCode $OfficeCode -config $config
  if ($null -eq $office) {
    Write-Error "There is no office associated with the code: $OfficeCode"
  }
}


Process {
  # Place all script elements within the process block to allow processing of
  # pipeline correctly.
    
  # The process block can be executed multiple times as objects are passed through the pipeline into it.
  if ($null -ne $office) {
    ForEach ($user In $Identity) {
      setOffice -adUser $user -Office $Office
    }
  }
}

END {       
  # Finally, run one-time tear-down tasks here.
  Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Complete."
}
