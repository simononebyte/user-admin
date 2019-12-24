# File to be dot sourced by main scripts
# Sets office name and address details using presets

function setOffice($adUser, [OBNOffice]$office) {

    # Setting Office information
    if ($adUser) {
        $adUser | Set-AdUser -Office $($office.Name)
        $adUser | Set-AdUser -OfficePhone $($office.Phone)
        $adUser | Set-AdUser -StreetAddres $($office.Street)
        $adUser | Set-AdUser -City $($office.City)
        $adUser | Set-AdUser -PostalCode $($office.Postcode)
    }

}