<#
.SYNOPSIS
    Make a launcher the default home screen without disabling Google TV.
.DESCRIPTION
    Google TV stays enabled as a fallback, so a broken launcher never leaves a black screen.
    Google TV can reclaim the default after a full restart; just run this again.
.EXAMPLE
    .\scripts\set-home.ps1                 # CleanFrame TV (default)
    .\scripts\set-home.ps1 -Reset          # back to Google TV
#>
param(
    [string]$Activity = "io.github.mdrzn.cleanframetv/.HomeActivity",
    [switch]$Reset
)

if (-not ((adb devices) -match '\sdevice$')) {
    Write-Error "No TV connected. Run .\scripts\connect.ps1 -TvIp <ip> first."
    exit 1
}

if ($Reset) { $Activity = "com.google.android.apps.tv.launcherx/.home.HomeActivity" }

# Safety: Google TV launcher must stay enabled as the fallback
$disabled = adb shell pm list packages -d
if ($disabled -match 'com.google.android.apps.tv.launcherx') {
    Write-Host "Re-enabling Google TV launcher as fallback..." -ForegroundColor Yellow
    adb shell pm enable com.google.android.apps.tv.launcherx | Out-Null
}

$result = adb shell cmd package set-home-activity $Activity
Write-Host "set-home-activity $Activity -> $result"
adb shell input keyevent KEYCODE_HOME
Write-Host "Pressed Home. The TV should now show the chosen launcher." -ForegroundColor Green
