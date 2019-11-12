# File to be dot sourced by main scripts
# Protects a folder from accidental move, delete or rename

function protectFolder([string]$Folder) {

    $ACL = @("Delete", "DeleteSubdirectoriesAndFiles")

    Write-Verbose "Protecting folder: $Folder"
    Set-Permission $Folder -UserOrGroup "Authenticated Users" -AclRightsToAssign $ACL -AccessControlType "Deny" -InheritedFolderPermissions "None"
}