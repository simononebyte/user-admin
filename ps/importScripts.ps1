# This script dot sources the rest of the scripts in this directory
# whilst ignoring itself and other non-script items

param (
    $path
)

$exclude = "$($MyInvocation.MyCommand.Name)"
  
# Dot source all necessary scripts
Get-ChildItem -Path "$path\*" -Include "*.ps1" -Exclude $exclude | ForEach-Object {
    Write-Verbose "dot Sourcing $($_.Fullname)"
    . $_.FullName
}