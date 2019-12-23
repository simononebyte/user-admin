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
    $cloudUsers = Get-Mailbox
  }
  
  END {       
    # Finally, run one-time tear-down tasks here.
    Write-Verbose -Message "$($MyInvocation.MyCommand.Name): Complete."
  }
  