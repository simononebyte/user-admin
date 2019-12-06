# File to be dot sourced by main scripts

# Represent the information that can be configured for an office address
Class Office {
    [string]$ShortCode
    [string]$Name
    [string]$Phone
    [string]$Street
    [string]$City
    [string]$Postcode

    # Constructor
    Office() { }
}