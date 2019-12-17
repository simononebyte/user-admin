<#
.SYNOPSIS
Adds a new office to the list of the configured offices


.PARAMETER OfficeCode
The 2 or 3 letter code to identify the office with. This must be
unique within the list of offices.

.PARAMETER Name
The name by which the office is generally described.

.PARAMETER Phone
The main phone numebr for that office.

.PARAMETER Street
The street address. If there is a building and street, then place
both on this parameter separated by commas.

.PARAMETER City
The town or city the office is located in.

.PARAMETER Postcode
The postcode for the office.

.PARAMETER ConfigPath
The default configu path is C:\ProgramData\Onebyte\Config.json. This will allow
an alternative path to be used.

.EXAMPLE
.\Add-OBNOffice.ps1
 
This will prompt you for each of the necessary inputs before adding them to the config file.

.EXAMPLE
.\Add-OBNOffice.ps1 -OfficeCode ldn -Name London -Phone "+44 (0) 203 189 2100" -Street "St. Marks Studios, 14 Chllingworth Road" -City London -Postcode "N7 8QJ"
 
This will add an entry which can be retrieved using the OfficeCode of 'ldn'.

.NOTES
Author : Simon Buckner
Email  : simonbuckner@hotmail.com
Date   : 17th December 2019

.INPUTS
None

.OUTPUTS
None

.LINK
Internal documentation: 
Github Repository: https://github.com/simononebyte/user-admin

#>

[CmdletBinding(SupportsShouldProcess = $True)]
Param(
  [Parameter(
    Mandatory = $true,
    Position = 0,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 3)]
  [String]$OfficeCode,

  [Parameter(
    Mandatory = $true,
    Position = 1,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$Name,
    
  [Parameter(
    Mandatory = $true,
    Position = 2,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$Phone,

  [Parameter(
    Mandatory = $true,
    Position = 3,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$Street,
  
  [Parameter(
    Mandatory = $true,
    Position = 4,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$City,
  
  [Parameter(
    Mandatory = $true,
    Position = 5,
    ValueFromPipeline = $False,
    ValueFromPipelineByPropertyName = $False
  )]
  [ValidateLength(1, 256)]
  [String]$Postcode,

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
  Get-ChildItem -Path $Path -Filter *.ps1 | ForEach-Object {
    . $_.FullName
  }

  $config = loadConfig -Path $ConfigPath
}

Process {

  $exists = checkOfficeCode -officeCode $OfficeCode -config $config
  Write-Host "exit -eq $exists"
  if ($null -eq $exists) {
    $newOffice = [Office]::New()
    $newOffice.OfficeCode = $OfficeCode
    $newOffice.Name = $Name
    $newOffice.Phone = $Phone
    $newOffice.Street = $Street
    $newOffice.City = $City
    $newOffice.Postcode = $Postcode
    $config.Offices += $newOffice

    saveConfig -config $config -path $
    Write-Verbose "Office with code '$OfficeCode' saved to config"
    
  }
  else {
    Write-Error "An office with the code '$OfficeCode' already exsits"
  }

}

END {       
  # Finally, run one-time tear-down tasks here.
  Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Complete."
}
