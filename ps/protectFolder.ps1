# File to be dot sourced by main scripts
# Protects a folder from accidental move, delete or rename

function protectFolder([string]$folder) {

    $ACL = @("Delete", "DeleteSubdirectoriesAndFiles")

    Write-Verbose "Protecting folder: $folder"
    setPermission -StartingDir $folder -UserOrGroup "Authenticated Users" -AclRightsToAssign $ACL -AccessControlType "Deny" -InheritedFolderPermissions "None"
}