# File to be dot sourced by main scripts
# Sets users & groups will read & write access to a folder and its subfolders

[CmdletBinding(SupportsShouldProcess = $False)]
Param(
    [Parameter(
        Mandatory = $True,
        Position = 0
    )]
    [ValidateLength(1, 256)]
    [String]$Folder,

    [Parameter(
        Mandatory = $True,
        Position = 1
    )]
    [ValidateLength(1, 256)]
    [String[]]$Users
)

$ACL = @("Write", "Read", "Delete", "Traverse", "AppendData", "DeleteSubdirectoriesAndFiles")

Write-Verbose "Setting read & write on folder: $Folder"

if ($Users -is [System.Array]) {
    foreach ($user in $Users) {
      Write-Verbose "Adding: $user"
      setPermission $Folder -UserOrGroup $user -AclRightsToAssign $ACL
    }
} else {
    Write-Verbose "Adding: $Users"
    setPermission $Folder -UserOrGroup $Users -AclRightsToAssign $ACL
}