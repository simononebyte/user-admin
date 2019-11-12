# File to be dot sourced by main scripts
# Checks to see if the scripted is running in a elvated session
# return true if it is, false if it is now

function isElevated() {

    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

}