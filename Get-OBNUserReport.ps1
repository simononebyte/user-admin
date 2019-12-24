<#
.SYNOPSIS
Generates a user report

.PARAMETER OutCSV
Path to a CSV file to output the report to

.EXAMPLE
.\Get-OBNUserReport.ps1
 
Generates a new password

.EXAMPLE
.\Get-OBNUserReport.ps1 -OutCSV report.csv
 
Generates the report and places it in the CSV file report.csv

.NOTES
Author : Simon Buckner
Email  : simon@onebyte.net
Date   : 23rd December 2019

.INPUTS
None

.OUTPUTS
None

.LINK
Internal documentation: 
Github Repository: https://github.com/simononebyte/user-admin

#>

[CmdletBinding(SupportsShouldProcess = $False)]
Param(
  [Parameter(
    Mandatory = $false,
    Position = 0,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$OutCSV,

  [Parameter(
    Mandatory = $false,
    Position = 1,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]  
  [switch]$LeaveEXOPOpen,

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
}
  
  
Process {
  # Place all script elements within the process block to allow processing of
  # pipeline correctly.
      
  # The process block can be executed multiple times as objects are passed through the pipeline into it.
  if (checkForEXOP) {
    importEXOP
  }
  else {
    Exit
  }
 
  $users = @{ }

  $cloudUsers = Get-Mailbox -RecipientTypeDetails UserMailbox

  foreach ($u in $cloudUsers) {
    $user = [OBNUser]::New()
    $user.UPN = $u.UserPrincipalName
    $user.DisplayName = $u.DisplayName
    $user.Email = $u.PrimarySmtpAddress
    $user.IsEnabled = (-not $u.AccountDisabled)
    $user.IsCloud = $true
    $div = ""
    foreach ($alias in $u.EmailAddresses) {
      if ($alias -clike "smtp*") {
        if ($alias -notlike "*.onmicrosoft.com") {
          $user.EmailAliases = "$($user.EmailAliases)$div$($alias.Substring(5))"
          $div = ";"
        }
      }
    }
    $users[$user.UPN] = $user
  }

  $adUsers = Get-ADUser -SearchBase "$($config.OrgUnit)" -Filter "*" -Properties DisplayName
  foreach ($u in $adUsers) {
    if ($null -eq $users[$u.UserPrincipalName]) {
      $user = [OBNUser]::New()
      $user.FirstName = $u.GivenName
      $user.LastName = $u.Surname
      $user.DisplayName = $u.DisplayName
      $user.SAMAccount = $u.SamAccountName
      $user.UPN = $u.UserPrincipalName
      $user.IsOnPremise = $true
    }
    else {
      $user = $users[$u.UserPrincipalName]
      $user.FirstName = $u.GivenName
      $user.LastName = $u.Surname
      $user.SAMAccount = $u.SamAccountName
      $user.IsOnPremise = $true
      if ($user.IsEnabled -ne $u.Enabled) {
        Write-Error "Mismatch between Cloud and On-Premise enabled state for user $($user.DisplayName). Cloud is $($user.IsEnabled) and On-Prem is $($u.Enabled)"
        $user.Enabled = $null
      }
    }
    $server = Get-ADPrincipalGroupMembership $($u.DistinguishedName)| Where-Object { $_.Name -Like "RDESKTOP*"}
    if ($null -ne $server) {
      $div = ""
      foreach ($s in $server) {
        $user.Server = "$($user.Server)$div" + ($s.Name.Replace("RDESKTOP0", "Server ").Replace(" Users", ""))
        $div = ";"
      }
    }
  }

  foreach ($u in $users.Values) {
    if ($u.IsCloud -eq $true -and $u.IsOnPremise -eq $false) {
      $user = Get-User $u.UPN
      if ($null -ne $user) {
        $u.FirstName = $user.FirstName
        $u.LastName = $user.LastName
      }
    }
  }
  $users.Values
}
  
END {
  if (-not $leaveEXOPOpen) {
    closeEXOPSession
  }

  # Finally, run one-time tear-down tasks here.
  Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Complete."
}
  