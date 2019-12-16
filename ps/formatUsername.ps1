# File to be dot sourced by main scripts
# Taks the users names and returns the username as indicated by the format

function formatUsername([string]$First, [string]$Last, [string]$Format) {

    $p1 = ""
    $p2 = ""

    if ($Format -match "^first") {
        # Matches 'first' at the beginning of the format string.
        $p1 = $First

    }
    elseif ($Format -match "first$") {
        # Matches 'first' at the end of the format string.
        $p2 = $First
    }

    # Matches 'last' at the beginning of the format string.
    if ($Format -match "^last") {
        $p1 = $Last

    }
    elseif ($Format -match "last$") {
        # Matches 'last' at the end of the format string.
        $p2 = $Last
    }


    if ($Format -match "^f[0-9]+") {
        # Matches 'f' followed by a number at the beginning of the format string.
        $len = [int]$matches[0].Substring(1)
        $p1 = $First.Substring(0, $len)

    }
    elseif ($Format -match "f[0-9]+$" ) {
        # Matches 'f' followed by a number at the end of the format string.
        $len = [int]$matches[0].Substring(1)
        $p2 = $First.Substring(0, $len)
    }

    # Matches 'l' followed by a number at the beginning of the format string.
    if ($Format -match "^l[0-9]+") {
        $len = [int]$matches[0].Substring(1)
        $p1 = $Last.Substring(0, $len)

    }
    elseif ($Format -match "l[0-9]+$") {
        # Matches 'l' followed by a number at the end of the format string.
        $len = [int]$matches[0].Substring(1)
        $p2 = $Last.Substring(0, $len)
    }

    ## Return value to calling script
    $uid = "$($p1.ToLower())$($p2.ToLower())"

    Write-Verbose "Generated user name '$uid' using format '$Format'"
    $uid
}