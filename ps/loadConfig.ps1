# File to be dot sourced by main scripts
# Load config from JSON

function loadConfig($Path) {

    if (Test-Path $Path) {
        $config = Get-Content -Path $Path | ConvertFrom-JSON
    }

    $config
}