[CmdletBinding()]
param (
    [Parameter(Mandatory=$true,
               Position=0,
               ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Path to config file.")]
    [ValidateNotNullOrEmpty()]
    [string]
    $ConfigFile
)

if (Test-Path $ConfigFile) {
    $config = Get-Content -Path $ConfigFile | ConvertFrom-JSON
}

$config