# File to be dot sourced by main scripts
# Create a new local user

function newLocalUser([string]$uid, [string]$display, [string]$uid2) {

  $userObj = New-LocalUser -Name $uid -FullName $display -NoPassword -AccountNeverExpires -ErrorVariable userErr -ErrorAction SilentlyContinue

  if ($userErr -and $userErr[0].CategoryInfo.Reason -eq "UserExistsException") {
    Write-Host
    Write-Host "The account '$uid' already exists."
    $p = Read-Host "Do you want to (u)se this account or (c)reate '$uid2' or (e)xit? (u/c/E)"
    if ($p -match "e" -or $p -eq "") {
      Write-Host "Exit selected"
      Exit

    }
    elseif ($p -match "u") {
      $userObj = Get-LocalUser -Name $uid

    }
    else {
      $userObj = New-LocalUser -Name $uid2 -FullName $display -NoPassword -AccountNeverExpires -ErrorVariable userErr -ErrorAction SilentlyContinue
    }
    if ($userErr -and $userErr[0].CategoryInfo.Reason -eq "UserExistsException") {
      Write-Host
      Write-Host "The account '$uid2' already exists."
      $p = Read-Host "Do you want to (u)se this account or (e)xit? (u/E)"
      if ($p -match "e" -or $p -eq "") {
        Write-Host "Exiting script"
        Exit

      }
      elseif ($p -match "u") {
        $userObj = Get-LocalUser -Name $uid2
      }   
    }
  }
  Write-Host "User created"
  $userObj

}