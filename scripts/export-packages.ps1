<#
.SYNOPSIS
    Export the TV's installed packages so they can be reviewed before debloating.
.DESCRIPTION
    Writes three files to .\exports\ (git-ignored):
      all-packages.txt       every package
      system-packages.txt    preinstalled system packages
      disabled-packages.txt  packages already disabled
    Review them and copy the packages you want gone into packages\sony-disable.txt.
#>
param(
    [string]$OutDir = (Join-Path $PSScriptRoot "..\exports")
)

if (-not (Get-Command adb -ErrorAction SilentlyContinue)) {
    Write-Error "adb not found. Run: winget install Google.PlatformTools"
    exit 1
}

if (-not ((adb devices) -match '\sdevice$')) {
    Write-Error "No TV connected. Run .\scripts\connect.ps1 -TvIp <ip> first."
    exit 1
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

function Export-List($flags, $file) {
    $path = Join-Path $OutDir $file
    adb shell pm list packages $flags |
        ForEach-Object { $_ -replace '^package:', '' } |
        Sort-Object |
        Set-Content -Path $path -Encoding utf8
    $count = (Get-Content $path | Measure-Object).Count
    Write-Host ("{0,-24} {1,4} packages" -f $file, $count)
}

Export-List ""   "all-packages.txt"
Export-List "-s" "system-packages.txt"
Export-List "-d" "disabled-packages.txt"

Write-Host "`nSaved to $((Resolve-Path $OutDir).Path)" -ForegroundColor Green
Write-Host "Next: review the lists, then edit packages\sony-disable.txt and run .\scripts\debloat.ps1 (dry run)."
