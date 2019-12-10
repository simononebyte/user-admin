# File to be dot sourced by main scripts
# Creates the folders specified int he config for the new user

function createUserFolders($adUser, $config) {

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
        
    New-Item -Path $path -ItemType Directory -ErrorVariable dirErr -ErrorAction SilentlyContinue

    if ($dirErr -and $dirErr[0].FullyQualifiedErrorId -like "DirectoryExist*") {
      Write-Error $dirErr
      exit
    }
    Write-Verbose "Created folder $path"

    # Protect folder from accidental rename/move/deletion
    protectFolder -folder $path
    Write-Verbose "Protected folder for rename/move or delete"

    setFolderReadWrite -Folder $path -Users $adUser.samAccountName
    Write-Host "Grant access to user"

    # Set owner if roaming profile 
    if ($folder.ProfileVersion -like "V*") {
      # setFolderOwner -Folder $path -Domain "$config.Domain" -User "Administrators"
      Write-Error "Setting own not supported yet. Please set manually to $($config.Domain)\Administrators"
      Write-verbose "Set owner on roaming profile"
    }

    if ($folder.AdminGroups.Length -gt 0) {
      setFolderAdmin -Folder $path -Users $folder.AdminGroups
      Write-Verbose "Granted Admin access"
    }
  }
}