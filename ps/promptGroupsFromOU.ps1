# File to be dot sourced by main scripts
# Get all groups from an OU and present selection menu
# before then adding the selection

function promptGroupsFromOU([string]$OU) {

    $groups = Get-ADGroup -SearchBase "$ou" -Filter "*"
    $groups = $groups | Sort-Object -Property Name
    $opt = 1
    foreach ($group in $groups) {
        $optStr = ([string]$opt).PadLeft(3, " ")
        Write-Host "$optStr - $($group.Name)"
        $opt++
    }
    Write-Host 
    Write-Host "Enter selection, multiple values separated by commas. Us - to indicate ranges."
    $selections = Read-Host "(E.g. 1,4,6-9) or 0 for none"

    $selGroups = @()

    if ($selections -ne "" -and $selections -ne "0") {
        $selected = parseSelection -selections $selections
        $selGroups = @()
        foreach ($sel in $selected) {
            $selGroups += $groups[$sel-1]
        }
    }
    
    $selGroups
}