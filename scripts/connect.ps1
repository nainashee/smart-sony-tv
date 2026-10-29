<#
.SYNOPSIS
    Connect to the Sony Google TV over Wi-Fi with ADB.
.EXAMPLE
    .\scripts\connect.ps1 -TvIp 192.168.1.50
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$TvIp,
    [int]$Port = 5555
)

if (-not (Get-Command adb -ErrorAction SilentlyContinue)) {
    Write-Error "adb not found. Install it with: winget install Google.PlatformTools (then reopen the terminal)."
    exit 1
}

$target = "$($TvIp):$Port"
Write-Host "Connecting to $target ..." -ForegroundColor Cyan
adb connect $target | Write-Host

Write-Host "`nIf the TV shows 'Allow USB debugging?', choose Allow and tick 'Always allow'." -ForegroundColor Yellow
Start-Sleep -Seconds 3

$devices = adb devices
Write-Host "`n$($devices -join "`n")"

if ($devices -match [regex]::Escape($target) + '\s+device') {
    Write-Host "`nConnected." -ForegroundColor Green
    $model = adb -s $target shell getprop ro.product.model
    $android = adb -s $target shell getprop ro.build.version.release
    Write-Host "Model: $model  |  Android TV OS: $android"
} elseif ($devices -match 'unauthorized') {
    Write-Warning "TV is unauthorized. Accept the prompt on the TV, then run this script again."
} else {
    Write-Warning "Not connected. Check the IP, that both devices are on the same Wi-Fi, and that debugging is on."
}
