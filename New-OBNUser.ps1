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
  [String]$UserName,
  
  [Parameter(
    Mandatory = $false,
    Position = 5,
    ValueFromPipeline = $True,
    ValueFromPipelineByPropertyName = $True
  )]
  [ValidateLength(1, 3)]
  [String]$OfficeCode,

  [Parameter(
    Mandatory = $false,
    Position = 98,
    ValueFromPipeline = $True,
    ValueFromPipelineByPropertyName = $True
  )]  
  [switch]$Local,

  [Parameter(
    Mandatory = $false,
    Position = 99,
    ValueFromPipeline = $True,
    ValueFromPipelineByPropertyName = $True
  )]
  [ValidateLength(1, 256)]
  # [String]$ConfigPath="C:\ProgramData\Onebyte\config.json"
  [String]$ConfigPath = ".\config.json"

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
  if ($config.RequireElevated -eq $true) {
    if (-not (isElevated) ) {
      Write-Error "elevated session required"
      Exit
    }
  }
}


Process {
  # Place all script elements within the process block to allow processing of
  # pipeline correctly.

  $DisplayName = "$First $Last"
  if ($Quals) {
    $DisplayName = "$DisplayName $Quals"
  }
  
  $UID = formatUsername -First $First -Last $Last -Format $config.UsernameFormat
  if ($UserName) {
    $UID = $UserName
  }
  $UID2 = formatUsername -First $First -Last $Last -Format $config.UsernameFallback
  $EmailAddress = "$UID@$($config.EmailDomain)"

  $OU = $config.OrgUnit
  if ($Local) {
    $OU = "N/A - Local account"
  }

  $RDP = "Not Set"
  if ($RDPServer -ne -1) {
    $RDP = "RDESKTOP0$($RDPServer) User"
  }

  $OfficeName = "N/A - Local Account"
  if (-not $Local) {
    $Office = checkOfficeCode -officeCode $OfficeCode -config $config
    $OfficeName = $Office.Name
    if (-not $Office) {
      Write-Error "Unable to find that Office"
      exit
    }
  }

  Write-Host "Creating a new account with the following details"
  Write-Host
  Write-Host "First name       : $First"
  Write-Host "Last name        : $Last"
  Write-Host "Display Name     : $DisplayName"
  Write-Host "User lgoin       : $UID" 
  Write-Host "Email Address    : $EmailAddress"
  Write-Host "Org Unit         : $OU"
  Write-Host "Office Name      : $OfficeName"
  Write-Host
    Write-Host "RDP Server Group : $RDP"
  
  $title = "User folders     :"
  foreach ($folder in $config.UserFolders) {
    $path = $folder.Path
    if ($path -match "\\$") {
      $path = "$($path)$($UID)"
    }
    else {
      $path = "$($path)\\$($UID)"
    }
    Write-Host "$title $path"
    $title = "                 :"
  }

  Write-Host
  $prompt = Read-Host "Please confirm this is correct? (Y)"
  if ($prompt -notmatch "y") {
    Exit
  }

  Write-Host "Create user"
  if ($Local) {
    $userObj = newLocalUser -uid $UID -display $DisplayName -uid2 $UID2
  }
  else {
    $userObj = newADUser -uid $UID -first $First -last $Lasty -display $DisplayName -ou $OU -uid2 $UID2
  }
  
  # Not sure this is needed but there as a belt and braces check
  if (-not $userObj) {
    Write-Error "User account not created"
  }

  if (-not $Local -and $OfficeCode) {
    setOffice -uid $UID -Office $Office
  }
}

END {       
  # Finally, run one-time tear-down tasks here.
  Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Complete."
}
