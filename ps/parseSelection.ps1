# File to be dot sourced by main scripts
# Parses slections input when selecting multiple items from a list

function parseSelection([string]$selections) {

    $selected = @()

    $parts = $selections.Replace(" ", "").Split(",")
    foreach ($part in $parts) {
        if ($part -like "*-*") {
            $range = $part.Split("-")
            $from = [int]$range[0]
            $to = [int]$range[1]

            if ($to -le $from) {
                Write-Error "$part must be a range from a low number to a higher number"
            }
            for ($i=$from; $i -le $to; $i++) {
                if ($selected -notContains $i) {
                    $selected += $i
                }
            }
        } else {
            if ($selected -notContains [int]$part) {
                $selected += [int]$part
            }
        }
    }
    $selected
}