# File to be dot sourced by main scripts
# Load config from JSON

<# TODO
    Return a concrete object which validates the config file.
    Also allows for pascal case in the JSON file which is more common
    whilst retaining camel case in the script which is more common.
#>
function saveConfig($config, $path) {

    if (-not (isElevated) ) {
        Write-Error "elevated session required to saveConfig"
        Exit
    }

    $config | ConvertTo-Json | Out-File $path
    Write-Verbose "SAved config to $path"
}