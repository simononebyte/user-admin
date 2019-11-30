# File to be dot sourced by main scripts
# Sets office name and address details using presets

function checkOfficeCode([string]$officeCode, $config) {

    $offices = @()
    foreach ($officeJson in $config.Offices) {
        $newOffice = [Office]::New()
        $newOffice.ShortCode = $officeJson.ShortCode
        $newOffice.Name = $officeJson.Name
        $newOffice.Phone = $officeJson.Phone
        $newOffice.Street = $officeJson.Street
        $newOffice.City = $officeJson.City
        $newOffice.Postcode = $officeJson.Postcode
        $offices += $newOffice
    }
    
    $office = $null
    foreach ($o in $offices) {
        if ($o.ShortCode -eq $OfficeCode) {
            $office = $o
            break
        }
    }
 
    # Return the office if found, NULL if not
    $office
}