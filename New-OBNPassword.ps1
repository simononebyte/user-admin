<#
.SYNOPSIS
Generates a new password similar to Office 365 generated passwords

.EXAMPLE
.\NewOBNPassword.ps1
 
Generates a new password

.EXAMPLE
.\NewOBNPassword.ps1 | clip
 
Generates a new password and places it in the clipboard

.NOTES
Author : Simon Buckner
Email  : simon@onebyte.net
Date   : 20th December 2019

.INPUTS
None

.OUTPUTS
None

.LINK
Internal documentation: 
Github Repository: https://github.com/simononebyte/user-admin

#>

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

}


Process {
  # Place all script elements within the process block to allow processing of
  # pipeline correctly.
    
  # The process block can be executed multiple times as objects are passed through the pipeline into it.
  newPassword
}

END {       
  # Finally, run one-time tear-down tasks here.
  Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Complete."
}
