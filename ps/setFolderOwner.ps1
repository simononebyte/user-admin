# File to be dot sourced by main scripts
# Sets users or groups own the folder

function setFolderOwner([string]$Folder, [string]$Domain, [string]$User) {

    Write-Verbose "Setting folder owner: $User"
    $ownerObject = New-Object System.Security.Principal.NTAccount($domain, $User)
    $acl = Get-Acl -Path $Folder
    $acl.SetOwner($ownerObject)
    Set-Acl -Path $Folder -AclObject $acl
}