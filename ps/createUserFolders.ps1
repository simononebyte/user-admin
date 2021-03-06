# File to be dot sourced by main scripts
# Creates the folders specified int he config for the new user

function createUserFolders($adUser, $config) {

  $NTAccount = New-Object System.Security.Principal.NTAccount("$($config.Domain)\$($adUser.SamAccountName)")
  $UID = $adUser.SamAccountName
  
  Write-Verbose "Setting folders for user $NTAccount"
  
  foreach ($folder in $config.UserFolders) {
    $path = $folder.Path
    if ($path -match "\\$") {
      $path = "$($path)$($UID)"
    }
    else {
      $path = "$($path)\\$($UID)"
    }
    if ($folder.ProfileVersion -like "V*") {
      $path += ".$($folder.ProfileVersion)"
    }
        
    Write-Host "Creating $path"
        
    New-Item -Path $path -ItemType Directory -ErrorVariable dirErr -ErrorAction SilentlyContinue | Out-Null

    if ($dirErr -and $dirErr[0].FullyQualifiedErrorId -like "DirectoryExist*") {
      Write-Error $dirErr[0]
      exit
    }
    Write-Verbose "Created folder $path"

    # Protect folder from accidental rename/move/deletion
    if ($folder.Protect -eq $true) {
      protectFolder -folder $path
      Write-Verbose "Folder prtected for rename/move or delete"
    }

    setFolderReadWrite -Folder $path -Users $NTAccount
    Write-Host "Set user permissions"

    # Set owner if roaming profile 
    if ($folder.ProfileVersion -like "V*") {
      # TODO: Set the profile attribute on the user account
      setFolderOwner -Folder $path -Domain "$config.Domain" -User "Administrators"
      Write-verbose "Set owner on roaming profile"
    }

    if ($folder.AdminGroups.Length -gt 0) {
      setFolderAdmin -Folder $path -Users $folder.AdminGroups
      Write-Verbose "Granted Admin access"
    }
  }
}