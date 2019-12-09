# File to be dot sourced by main scripts
# Sets users & groups will read & write access to a folder and its subfolders

function setFolderReadWrite([string]$Folder, [string[]]$Users) {

    $ACL = @("Write", "Read", "Delete", "Traverse", "AppendData", "DeleteSubdirectoriesAndFiles")

    Write-Verbose "Setting read & write on folder: $Folder"

    if ($Users -is [System.Array]) {
        foreach ($user in $Users) {
            Write-Verbose "Adding: $user"
            setPermission -StartingDir $Folder -UserOrGroup $user -AclRightsToAssign $ACL
        }
    }
    else {
        Write-Verbose "Adding: $Users"
        setPermission -StartingDir $Folder -UserOrGroup $Users -AclRightsToAssign $ACL
    }
}