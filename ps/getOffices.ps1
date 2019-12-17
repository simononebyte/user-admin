# File to be dot sourced by main scripts
# Gets the Office details from the config file

function getOffices($config) {

    $offices = @()
    foreach ($officeJson in $config.Offices) {
        $newOffice = [Office]::New()
        $newOffice.OfficeCode = $officeJson.OfficeCode
        $newOffice.Name = $officeJson.Name
        $newOffice.Phone = $officeJson.Phone
        $newOffice.Street = $officeJson.Street
        $newOffice.City = $officeJson.City
        $newOffice.Postcode = $officeJson.Postcode
        $offices += $newOffice
    }
 
    Write-Verbose "$($offices.Length) found in config"
    # Return the office if found, NULL if not
    $offices
}