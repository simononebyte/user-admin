# File to be dot sourced by main scripts
# Sets Job Title

function setJobTitle($adUser, [string]$title) {

    # Setting Office information
    if ($adUser) {
        $adUser | Set-AdUser -Title "$title"
        Write-Verbose "Job title set"
    }

}