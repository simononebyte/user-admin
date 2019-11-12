<#
.SYNOPSIS
  Create a new user.

.DESCRIPTION
  Create a new user and all associated objects like home folders and set
  relevant other attributes like office address and group memberships.

.NOTES
  Authored By: Simon Buckner
  Email: simon@onebyte.net
  Date: 3rd November 2019

.LINK
  <link to any documentation relating to this script in IT Glue>

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
  [String]$First,

  [Parameter(
    Mandatory = $True,
    Position = 1,
    ValueFromPipeline = $True,
    ValueFromPipelineByPropertyName = $True
  )]
  [ValidateLength(1, 256)]
  [String]$Last,

  [Parameter(
    Mandatory = $False,
    Position = 2,
    ValueFromPipeline = $True,
    ValueFromPipelineByPropertyName = $True
  )]
  [ValidateLength(1, 256)]
  [String]$Quals,

  [Parameter(
    Mandatory = $false,
    Position = 3,
    ValueFromPipeline = $True,
    ValueFromPipelineByPropertyName = $True
  )]
  [int]$RDPServer = -1,

  [Parameter(
    Mandatory = $false,
    Position = 4,
    ValueFromPipeline = $True,
    ValueFromPipelineByPropertyName = $True
  )]
  [ValidateLength(1, 256)]
  [String[]]$UserName,

  [Parameter(
    Mandatory = $false,
    Position = 99,
    ValueFromPipeline = $True,
    ValueFromPipelineByPropertyName = $True
  )]
  [ValidateLength(1, 256)]
  # [String]$ConfigPath="C:\ProgramData\Onebyte\config.json"
  [String]$ConfigPath=".\config.json"

)

BEGIN {

  # Run one-time set-up tasks here, like defining variables, etc.
  Set-StrictMode -Version Latest
  Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Started."

  # Declare any classes used later in the sript
  # #########################################################################
  # Class MyClass {
  #   [string]$Field1

  #   [int]$Field2

  #   [ValidateSet("Opt1", "Opt2", "Opt3")]
  #   [string]$Field3

  #   # Constructor
  #   ProfileFolder($Field1, $Field2, $Field3) {
  #     $this.$Field1 = $Field1
  #     $this.$Field2 = $Field2
  #     $this.$Field3 = $Field3
  #   }
  # }

  # Declare any supporting functions here
  # #########################################################################
  # Dot source all necessary scripts
  $Path = ".\ps\"
  Get-ChildItem -Path $Path -Filter *.ps1 | ForEach-Object {
      . $_.FullName
  }
 
  $config = loadConfig -Path $ConfigPath
}


Process {
  # Place all script elements within the process block to allow processing of
  # pipeline correctly.

  $displayName = "$first $Last"
  $username = formatUsername -First $First -Last $Last -Format $config.username_format

  Write-Host "Creating a new account with the following details"
  Write-Host
  Write-Host "First name    : $First"
  Write-Host "Last name     : $Last"
  Write-Host "Display Name  : $displayName"
  Write-Host "Email Address : $username"




}

END {       
  # Finally, run one-time tear-down tasks here.
  Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Complete."
}
