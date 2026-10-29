<#
.SYNOPSIS
    Disable the packages listed in packages\sony-disable.txt.
.DESCRIPTION
    Dry run by default: shows what would change. Add -Apply to make changes.
    Uses 'pm disable-user --user 0' (reversible), never uninstall.
    Refuses protected system packages even if they appear in the list.
    Every change is logged to .\exports\debloat-log.txt for restore.ps1.
.EXAMPLE
    .\scripts\debloat.ps1            # preview
    .\scripts\debloat.ps1 -Apply     # disable
#>
param(
    [switch]$Apply,
    [string]$ListFile = (Join-Path $PSScriptRoot "..\packages\sony-disable.txt")
)

# Packages (or name fragments) that must never be disabled.
$Protected = @(
    'com.google.android.gms',            # Play Services
    'com.google.android.gsf',            # Google Services Framework
    'com.android.vending',               # Play Store
    'com.google.android.tvlauncher',     # stock launcher (disable only with a replacement set)
    'com.google.android.apps.tv.launcherx',
    'com.android.systemui',
    'com.android.settings',
    'com.android.tv.settings',
    'com.android.providers.',
    'com.android.inputmethod',
    'com.google.android.inputmethod',
    'com.google.android.tungsten.setupwraith',  # setup wizard
    'com.google.android.tv.setupwizard',
    'com.android.packageinstaller',
    'com.google.android.packageinstaller',
    'tvsettings',
    'tv.framework',
    'inputs',
    'tvinput',
    'com.sony.dtv.tvx',                  # Sony TV core
    'com.sony.dtv.systemui',
    'android'
)

function Test-Protected($pkg) {
    if ($pkg -eq 'android') { return $true }
    foreach ($p in $Protected) {
        if ($p -ne 'android' -and $pkg -like "*$p*") { return $true }
    }
    return $false
}

if (-not (Test-Path $ListFile)) { Write-Error "List not found: $ListFile"; exit 1 }
if (-not ((adb devices) -match '\sdevice$')) {
    Write-Error "No TV connected. Run .\scripts\connect.ps1 -TvIp <ip> first."
    exit 1
}

$installed = adb shell pm list packages | ForEach-Object { $_ -replace '^package:', '' }
$targets = Get-Content $ListFile |
    ForEach-Object { ($_ -split '#')[0].Trim() } |
    Where-Object { $_ }

$logDir = Join-Path $PSScriptRoot "..\exports"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$log = Join-Path $logDir "debloat-log.txt"

$mode = if ($Apply) { "APPLY" } else { "DRY RUN" }
Write-Host "Mode: $mode   |   $($targets.Count) packages in list`n" -ForegroundColor Cyan

$done = 0; $skipped = 0
foreach ($pkg in $targets) {
    if (Test-Protected $pkg) {
        Write-Host "  PROTECTED  $pkg" -ForegroundColor Red; $skipped++; continue
    }
    if ($installed -notcontains $pkg) {
        Write-Host "  not found  $pkg" -ForegroundColor DarkGray; $skipped++; continue
    }
    if (-not $Apply) {
        Write-Host "  would disable  $pkg"; continue
    }
    $result = adb shell pm disable-user --user 0 $pkg 2>&1
    if ($result -match 'disabled') {
        Write-Host "  disabled   $pkg" -ForegroundColor Green
        Add-Content -Path $log -Value "$(Get-Date -Format s)`t$pkg"
        $done++
    } else {
        Write-Host "  FAILED     $pkg  ($result)" -ForegroundColor Yellow
    }
}

Write-Host ""
if ($Apply) {
    Write-Host "Disabled $done, skipped $skipped. Log: $log" -ForegroundColor Green
    Write-Host "Reboot the TV and check inputs, sound and the remote. Undo with .\scripts\restore.ps1"
} else {
    Write-Host "Nothing changed. Re-run with -Apply to disable." -ForegroundColor Yellow
}
