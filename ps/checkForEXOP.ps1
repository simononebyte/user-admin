# File to be dot sourced by main scripts
# Check for the existence of the Exchange Online PowerShel modules

function checkForEXOP([switch]$hideHelp) {

    $path = "$($env:LOCALAPPDATA)\Apps\2.0\"
    $found = $false
    if ( (Test-Path $path) ) { 
        $dlls = (Get-ChildItem -Path $path -Filter Microsoft.Exchange.Management.ExoPowershellModule.dll -Recurse).FullName
        $mods = $dlls | Where-Object { $_ -notmatch "_none_" } | Select-Object -First 1

        if ( $mods.Length -gt 0) {
            $found = $true
        } else {
            Write-Verbose "ExoPowershellModule not found"
        }
    } else {
        Write-Verbose "$path not found"
    }

    if ( ($found -eq $false) -and ($hideHelp -eq $false) ) {
         Write-Host "Please install the Exchagne PowerShell modules. Instructions can be found here."
         Write-Host "https://docs.microsoft.com/en-us/powershell/exchange/exchange-online/connect-to-exchange-online-powershell/mfa-connect-to-exchange-online-powershell?view=exchange-ps"
    }
    $found    
}


