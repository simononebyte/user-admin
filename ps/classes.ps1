# File to be dot sourced by main scripts

# Represent the information that can be configured for an office address
Class Office {
    [string]$OfficeCode
    [string]$Name
    [string]$Phone
    [string]$Street
    [string]$City
    [string]$Postcode

    # Constructor
    Office() { }
}

Class OBNUser {
    [string]$FirstName
    [string]$LastName
    [string]$DisplayName
    [string]$Qualifications
    [string]$Email
    [string[]]$EmailAliases
    [string]$SAMAccount
    [string]$UPN
    [switch]$Cloud
    [switch]$OnPremise
}