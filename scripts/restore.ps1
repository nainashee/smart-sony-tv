<#
.SYNOPSIS
    Re-enable packages disabled by debloat.ps1.
.EXAMPLE
    .\scripts\restore.ps1                         # re-enable everything in the debloat log
    .\scripts\restore.ps1 -Package com.example    # re-enable one package
    .\scripts\restore.ps1 -AllDisabled            # re-enable every disabled package on the TV
#>
param(
    [string]$Package,
    [switch]$AllDisabled
)

if (-not ((adb devices) -match '\sdevice$')) {
    Write-Error "No TV connected. Run .\scripts\connect.ps1 -TvIp <ip> first."
    exit 1
}

if ($Package) {
    $targets = @($Package)
} elseif ($AllDisabled) {
    $targets = adb shell pm list packages -d | ForEach-Object { $_ -replace '^package:', '' }
} else {
    $log = Join-Path $PSScriptRoot "..\exports\debloat-log.txt"
    if (-not (Test-Path $log)) { Write-Error "No debloat log found at $log. Use -Package or -AllDisabled."; exit 1 }
    $targets = Get-Content $log | ForEach-Object { ($_ -split "`t")[1] } | Where-Object { $_ } | Sort-Object -Unique
}

foreach ($pkg in $targets) {
    $result = adb shell pm enable $pkg 2>&1
    if ($result -match 'enabled') {
        Write-Host "  enabled  $pkg" -ForegroundColor Green
    } else {
        # Fallback for a package removed by mistake with 'uninstall --user 0'
        $result2 = adb shell cmd package install-existing $pkg 2>&1
        Write-Host "  restore  $pkg  ($result2)" -ForegroundColor Yellow
    }
}

Write-Host "`nDone. Reboot the TV." -ForegroundColor Cyan
