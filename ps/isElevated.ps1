# File to be dot sourced by main scripts
# Checks to see if the scripted is running in a elvated session
# return true if it is, false if it is now

function isElevated() {

    Write-Verbose "Checking for elevated session"
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $elevated = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    $elevated
}