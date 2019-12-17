<#
.SYNOPSIS
Gets a list of the configured offices

.PARAMETER ConfigPath
The default configu path is C:\ProgramData\Onebyte\Config.json. This will allow
an alternative path to be used.

.EXAMPLE
.\Get-OBNOffice.ps1
 
Gets a list of the Office details stored in the config file.

.NOTES
Author : Simon Buckner
Email  : simonbuckner@hotmail.com
Date   : 17th December 2019

.INPUTS
None

.OUTPUTS
Array of type [Office]

.LINK
Internal documentation: 
Github Repository: https://github.com/simononebyte/user-admin

#>

[CmdletBinding(SupportsShouldProcess = $True)]
Param(
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
  # Place all script elements within the process block to allow processing of
  # pipeline correctly.
 
    $offices = getOffices -config $config
    $offices
}

END {       
  # Finally, run one-time tear-down tasks here.
  Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Complete."
}
