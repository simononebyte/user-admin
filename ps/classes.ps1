# File to be dot sourced by main scripts

# Represent the information that can be configured for an office address
Class OBNOffice {
    [string]$OfficeCode
    [string]$Name
    [string]$Phone
    [string]$Street
    [string]$City
    [string]$Postcode

    # Constructor
    Office() {

        $this.pstypenames.Clear()
        $this.pstypenames.Add("Onebyte.Office")
        $this.OfficeCode = ""
        $this.Name = ""
        $this.Phone = ""
        $this.Street = ""
        $this.CityPostcode = ""
     }
}

Class OBNUser {
    [switch]$IsEnabled
    [string]$FirstName
    [string]$LastName
    [string]$DisplayName
    [string]$Email
    [string]$EmailAliases
    [string]$SAMAccount
    [string]$UPN
    [switch]$IsCloud
    [switch]$IsOnPremise
    [string]$Server

    OBNUser() {
        $this.pstypenames.Clear()
        $this.pstypenames.Add("Onebyte.User")
        $this.IsEnabled = $false
        $this.FirstName = ""
        $this.LastName = ""
        $this.DisplayName = ""
        $this.Email = ""
        $this.EmailAliases = ""
        $this.SAMAccount = ""
        $this.UPN = ""
        $this.IsCloud = $false
        $this.IsOnPremise = $false
        $this.Server = ""
    }
}



