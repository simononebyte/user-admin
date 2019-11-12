# File to be dot sourced by main scripts
# Protects a folder from accidental move, delete or rename

[CmdletBinding(SupportsShouldProcess = $False)]
Param(
    [Parameter(
        Mandatory = $True,
        Position = 0
    )]
    [ValidateLength(1, 256)]
    [String]$Folder
)

$ACL = @("Delete", "DeleteSubdirectoriesAndFiles")

Write-Verbose "Protecting folder: $Folder"
Set-Permission $Folder -UserOrGroup "Authenticated Users" -AclRightsToAssign $ACL -AccessControlType "Deny" -InheritedFolderPermissions "None"
