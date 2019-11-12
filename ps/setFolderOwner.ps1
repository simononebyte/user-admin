# File to be dot sourced by main scripts
# Sets users or groups own the folder

[CmdletBinding(SupportsShouldProcess = $False)]
Param(
    [Parameter(
        Mandatory = $True,
        Position = 0
    )]
    [ValidateLength(1, 256)]
    [String]$Folder,

    [Parameter(
        Mandatory = $False,
        Position = 1
    )]
    [ValidateLength(1, 256)]
    [String]$User
)

Write-Verbose "Setting folder owner: $User"
$ownerObject = System.Security.Principal.NTAccount($User)
$acl = Get-Acl -Path $Folder
$acl.SetOwner($ownerObject)
Set-Acl -Path $Folder -AclObject $acl
