# File to be dot sourced by main scripts
# Create a new AD user

function newADUser([string]$uid, [string]$first, [string]$last, [string]$display, [string]$emailDomain, [string]$ou, [string]$uid2) {
  
  $upnClashError = "ActiveDirectoryServer:8648,Microsoft.ActiveDirectory.Management.Commands.NewADUser"

  $name = "$first $last"
  $emailUPN = "$uid@$emailDomain"

  try {
    $userObj = New-ADUser -SamAccountName $UID -Name "$name" -UserPrincipalName $emailUPN `
      -GivenName $first -Surname $last -DisplayName $display -EmailAddress $emailUPN `
      -Path $ou -PasswordNeverExpires:$true -ErrorVariable userErr -ErrorAction SilentlyContinue -PassThru

    return $userObj

  }
  catch {
    if ( $_.CategoryInfo.Reason -ne "ADIdentityAlreadyExistsException" -and $_.FullyQualifiedErrorId -ne $upnClashError) {
      Write-Error $_
      exit
    }
  }
  
  Write-Host
  Write-Host "The account '$uid' already exists."
  $p = Read-Host "Do you want to (u)se this account or (c)reate '$uid2' or (e)xit? (u/c/E)"
  if ($p -match "e" -or $p -eq "") {
    Write-Host "Exit selected"
    Exit
  }
  elseif ($p -match "u") {
    $userObj = Get-Aduser "$name"
    return $userObj
  }

  # Try creating the user with the fallback user ID
  $emailUPN = "$uid2@$emailDomain"
  try {
    $userObj = New-ADUser -SamAccountName $UID2 -Name "$name" -UserPrincipalName $emailUPN `
      -GivenName $first -Surname $last -DisplayName $display -EmailAddress $emailUPN `
      -Path $ou -PasswordNeverExpires:$true -ErrorVariable userErr -ErrorAction SilentlyContinue -PassThru

    return $userObj
  }
  catch {
    if ( $_.CategoryInfo.Reason -ne "ADIdentityAlreadyExistsException" -and $_.FullyQualifiedErrorId -ne $upnClashError) {
      Write-Error $_
      exit
    }
  }

  Write-Host
  Write-Host "The account '$uid2' already exists."
  $p = Read-Host "Do you want to (u)se this account or (e)xit? (u/E)"
  if ($p -match "e" -or $p -eq "") {
    Write-Host "Exiting script"
    Exit
  }
  elseif ($p -match "u") {
    $userObj = Get-Aduser "$name"
    return $userObj
  }   

  Write-Verbose "User created successfullly"
  $userObj

}