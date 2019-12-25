<#

.SYNOPSIS
Create a new user.

.DESCRIPTION
Create a new user and all associated objects like home folders and set
relevant other attributes like office address and group memberships.

.PARAMETER First
The first name of the person the account is for.

.PARAMETER Last
The last name of the person the account is for.

.PARAMETER JobTitle
The Job Title, if supplied, of the person the account is for.

.PARAMETER Department
The name of the department to assign the user to.

.PARAMETER OfficeCode
The 2 or 3 letter code that relates to the entry in the config
file for the office address you want to assign to the user.

.PARAMETER Quals
Qualifications are appended to the Display Name of the user account. This
is used by the Exclaimer Signature service to put the qualifications on
the signature of the person the account is for.

.PARAMETER UserName
In some cases it might be desireable to override the default user name that 
is generated, for example if someone has a long name and would prefer an
abbreviation to be used.

.PARAMETER Local
This will create the account on the local computer instead of in the domain.

.PARAMETER ConfigPath
The default configu path is C:\ProgramData\Onebyte\Config.json. This will allow
an alternative path to be used.

.INPUTS
This script does not accept input from the Pipeline.

.OUTPUTS
The password for the user that is created will be copied to the clipboard.

.NOTES
Author : Simon Buckner
Email  : simon@onebyte.net
Date   : 16th December 2019

.LINK
Internal documentation: https://onebyte.eu.itglue.com/269174305390819/docs/1417313002815653
Github Repository: https://github.com/simononebyte/user-admin

#>

[CmdletBinding(SupportsShouldProcess = $False)]
Param(
  [Parameter(
    Mandatory = $True,
    Position = 0,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$First,

  [Parameter(
    Mandatory = $True,
    Position = 1,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$Last,
  
  [Parameter(
    Mandatory = $false,
    Position = 2,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$JobTitle,
  
  [Parameter(
    Mandatory = $false,
    Position = 3,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$Department,
  
  [Parameter(
    Mandatory = $false,
    Position = 4,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 3)]
  [String]$OfficeCode,

  [Parameter(
    Mandatory = $False,
    Position = 5,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$Quals,

  [Parameter(
    Mandatory = $false,
    Position = 6,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$UserName,

  [Parameter(
    Mandatory = $false,
    Position = 7,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]  
  [switch]$Local,

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
  .\ps\importScripts.ps1 -path ".\ps\"

 
  $config = loadConfig -Path $ConfigPath
  if ($config.RequireElevated -eq $true) {
    if (-not (isElevated) ) {
      Write-Error "elevated session required"
      Exit
    }
  }
}


Process {
  Set-StrictMode -Version Latest

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

  $EmailDomain = $config.EmailDomain
  $EmailAddress = "$UID@$EmailDomain"

  $OU = $config.OrgUnit
  if ($Local) {
    $OU = "N/A - Local account"
  }

  $OfficeName = ""
  $OfficePhone = ""
  if (-not $Local -and $config.Flags.OfficeAddress -eq $true) {
    $Office = checkOfficeCode -officeCode $OfficeCode -config $config
    $OfficeName = $Office.Name
    if (-not $Office) {
      Write-Error "Unable to find that Office"
      exit
    }
    $OfficePhone = $Office.Phone
  }

  Write-Host "Creating a new account with the following details"
  Write-Host
  Write-Host "First name       : $First"
  Write-Host "Last name        : $Last"
  Write-Host
  Write-Host "Display Name     : $DisplayName"
  Write-Host "Job Title        : $JobTitle"
  Write-host "Department       : $Department"
  Write-Host
  Write-Host "Office Name      : $OfficeName"
  Write-Host "Office Phone     : $OfficePhone"
  Write-Host
  Write-Host "User lgoin       : $UID" 
  Write-Host "Email Address    : $EmailAddress"
  
  $title = "User folders     :"
  foreach ($folder in $config.UserFolders) {
    $path = $folder.Path
    if ($path -match "\\$") {
      $path = "$($path)$($UID)"
    }
    else {
      $path = "$($path)\\$($UID)"
    }
    if ($folder.ProfileVersion -like "V*") {
      $path += ".$($folder.ProfileVersion)"
    }
    Write-Host "$title $path"
    $title = "                 :"
  }

  Write-Host
  $prompt = Read-Host "Please confirm this is correct? (Y)"
  if ($prompt -notmatch "y") {
    Exit
  }

    if ($Local) {
    $userObj = newLocalUser -uid $UID -display $DisplayName -uid2 $UID2
    if ($userObj.Name -ne $UID) {
      $UID = $userObj.Name
    }
  }
  else {
    Write-Verbose "newADUser -uid $UID -first $First -last $Last -display '$DisplayName' -emailDomain $EmailDomain -ou $OU -uid2 $UID2"
    $userObj = newADUser -uid $UID -first $First -last $Last -display "$DisplayName" -emailDomain $EmailDomain -ou $OU -uid2 $UID2
    $UID = $userObj.Name
  }
  
  # Not sure this is needed but there as a belt and braces check
  if ($null -eq $userObj) {
    Write-Error "User account not created"
    exit
  }

  if (-not $Local -and $JobTitle -ne "") {
    setJobTitle -adUser $userObj -title $JobTitle
  }

  if (-not $Local -and $Department -ne "") {
    setDepartment -adUser $userObj -department $Department
  }

  if (-not $Local -and $OfficeCode) {
    setOffice -adUser $userObj -Office $Office
  }

  if ($config.UserFolders.Length -gt 0) {
    createUserFolders -adUser $userObj -config $config
  }

  foreach ($groupOU in $config.GroupOUs) {
    Write-Host
    Write-Host "Please select which $($groupOu.Name) group to add the user to."
    Write-Host 
    $groups = promptGroupsFromOU -OU $groupOU.OU
    
    if ($null -ne $groups) {
      foreach ($group in $groups) {
        Add-ADGroupMember -Identity $group.SamAccountName -Members $userObj.SamAccountName
        Write-Verbose "Add $UID to group $($group.Name) complete"
      }
    }
    else {
      Write-Host "No $($groupOU.Name) groups selected"
    }
  }
  
  $pwd = newPassword
  $sec = ConvertTo-SecureString -AsPlainText $pwd -Force
  $userObj | Set-ADAccountPassword -Reset -NewPassword $sec
  Write-Host
  Write-Host "Password set to '$pwd' and copied to clipboard"
  Write-Host
  $pwd | clip

  $userObj | Set-ADUser -Enabled:$true
  Write-Verbose "User account enabled"
}

END {       
  # Finally, run one-time tear-down tasks here.
  Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Complete."
}
