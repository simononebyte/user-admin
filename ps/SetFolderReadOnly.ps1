# File to be dot sourced by main scripts
# Sets users & groups will read only access to a folder and its subfolders

function setFolderReadOnly([string]$Folder, [string[]]$Users) {

    $ACL = @("Read")

    Write-Verbose "Setting read-only on folder: $Folder"

    if ($Users -is [System.Array]) {
        foreach ($user in $Users) {
        Write-Verbose "Adding: $user"
        setPermission $Folder -UserOrGroup $user -AclRightsToAssign $ACL
        }
    } else {
        Write-Verbose "Adding: $Users"
        setPermission $Folder -UserOrGroup $Users -AclRightsToAssign $ACL

    }
}