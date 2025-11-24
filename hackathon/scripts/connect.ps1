param(
    [Parameter(Mandatory=$true)][string]$Provider
)
$configPath = Join-Path (Get-Location) "config\providers.json"
if (-not (Test-Path $configPath)) {
    Write-Host "Config file not found at $configPath"
    exit 1
}
$configRaw = Get-Content -Raw $configPath
$config = $configRaw | ConvertFrom-Json
if (-not ($config.PSObject.Properties.Name -contains $Provider)) {
    Write-Host "Provider '$Provider' not found in config"
    exit 0
}
$providerCfg = $config.$Provider
if ($providerCfg.type -eq "oauth_device") {
    if (-not $providerCfg.client_id -or $providerCfg.client_id -eq "") {
        Write-Host "Provider '$Provider' is not configured. Add client_id to config/providers.json"
        exit 0
    }
    $body = @{ client_id = $providerCfg.client_id; scope = "read:user repo" }
    $device = Invoke-RestMethod -Method Post -Uri "https://github.com/login/device/code" -Body $body -ContentType "application/x-www-form-urlencoded"
    Write-Host "Go to:" $device.verification_uri
    Write-Host "Enter code:" $device.user_code
    try { Start-Process $device.verification_uri } catch {}
    $tokenBody = @{ client_id = $providerCfg.client_id; device_code = $device.device_code; grant_type = "urn:ietf:params:oauth:grant-type:device_code" }
    $maxWait = [int]$device.expires_in
    $elapsed = 0
    while ($elapsed -lt $maxWait) {
        $token = Invoke-RestMethod -Method Post -Uri "https://github.com/login/oauth/access_token" -Body $tokenBody -ContentType "application/x-www-form-urlencoded" -Headers @{ Accept = "application/json" }
        if ($null -ne $token.access_token -and $token.access_token -ne "") {
            Write-Host "Connected to GitHub"
            Write-Host ("Access token: {0}" -f $token.access_token)
            exit 0
        }
        if ($token.error -eq "authorization_pending") {
            Start-Sleep -Seconds ([int]$device.interval)
            $elapsed += [int]$device.interval
            continue
        }
        if ($token.error -eq "slow_down") {
            Start-Sleep -Seconds (([int]$device.interval) + 5)
            $elapsed += ([int]$device.interval) + 5
            continue
        }
        Write-Host ("Error: {0}" -f $token.error)
        exit 1
    }
    Write-Host "Device code expired"
    exit 1
}
Write-Host "Provider type '$($providerCfg.type)' not supported by this script"
exit 0