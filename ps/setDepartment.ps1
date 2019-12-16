# File to be dot sourced by main scripts
# Sets Job Title

function setDepartment($adUser, [string]$department) {

    # Setting Office information
    if ($adUser) {
        $adUser | Set-AdUser -Department "$department"
        Write-Verbose "Department set"
    }

}