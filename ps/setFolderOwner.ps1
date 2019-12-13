# File to be dot sourced by main scripts
# Sets users or groups own the folder

function setFolderOwner([string]$folder, [string]$domain, [string]$user) {

    Write-Verbose "Setting folder owner: $user"
    $id = New-Object System.Security.Principal.NTAccount("$domain\$user")

    $dir= New-Object System.IO.DirectoryInfo($folder)
    $dirSec = $dir.GetAccessControl()

    $dirSec.SetOwner($id)
    $dir.SetAccessControl($dirSec)

    Write-Verbose "Owner set on folder"
}