

function closeEXOPSession() {
    $sessions = Get-PSSession | Where-Object { $_.ConfigurationName -eq "Microsoft.Exchange" }
    foreach ($s in $sessions) {
        $s | Remove-PSSession
    }
}

