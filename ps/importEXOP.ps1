# File to be dot sourced by main scripts
# Check for the existence of the Exchange Online PowerShel modules

function importEXOP() {

    if (checkForEXOP) {
        $SaveVerbosePreference = $global:VerbosePreference
        $global:VerbosePreference = 'SilentlyContinue'

        $ps = (Get-PSSession | Where-Object { $_.ConfigurationName -eq "Microsoft.Exchange"})
        if ($null -eq $ps) {
            Import-Module $(( Get-ChildItem -Path $($env:LOCALAPPDATA + "\Apps\2.0\") -Filter Microsoft.Exchange.Management.ExoPowershellModule.dll -Recurse).FullName | Where-Object { $_ -notmatch "_none_" } | Select-Object -First 1)
            $EXOSession = New-ExoPSSession
            Import-PSSession $EXOSession
            Write-Verbose "EXOP session imported"
        }

        $global:VerbosePreference = $SaveVerbosePreference
    }
}


