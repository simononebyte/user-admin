# File to be dot sourced by main scripts
# Sets office name and address details using presets

function setOffice([string]$uid, [Office]$office) {

    # Setting Office information
    $adUser = Get-AdUser $uid
    if ($adUser) {
        $adUser | Set-AdUser -Office $($office.Name)
        $adUser | Set-AdUser -OfficePhone $($office.Phone)
        $adUser | Set-AdUser -StreetAddres $($office.Street)
        $adUser | Set-AdUser -City $($office.City)
        $adUser | Set-AdUser -PostalCode $($office.Postcode)
    }

}