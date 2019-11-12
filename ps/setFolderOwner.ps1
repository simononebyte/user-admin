# File to be dot sourced by main scripts
# Sets users or groups own the folder

function setFolderOwner([string]$Folder, [string[]]$User) {

    Write-Verbose "Setting folder owner: $User"
    $ownerObject = System.Security.Principal.NTAccount($User)
    $acl = Get-Acl -Path $Folder
    $acl.SetOwner($ownerObject)
    Set-Acl -Path $Folder -AclObject $acl
}