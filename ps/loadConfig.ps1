# File to be dot sourced by main scripts
# Load config from JSON

<# TODO
    Return a concrete object which validates the config file.
    Also allows for pascal case in the JSON file which is more common
    whilst retaining camel case in the script which is more common.
#>
function loadConfig($Path) {

    if (Test-Path $Path) {
        $config = Get-Content -Path $Path | ConvertFrom-JSON
    }

    $config
}