# SMART Sony TV

Make a Sony Google TV fast, ad-free and tracking-free — using free tools, no root, and nothing you can't undo.

## What this project does

| Goal | How | Status |
| --- | --- | --- |
| Remove bloatware | ADB `disable-user` from a reviewed package list | In progress |
| Faster TV | Debloat + lightweight launcher (Projectivy) | In progress |
| Ad-free YouTube | [SmartTube](https://github.com/yuliskov/SmartTube) (open source) | Planned |
| Stop viewing tracking | Disable Samba Interactive TV / ACR | Planned |
| Mute Hulu ads automatically | Custom Android accessibility app (`hulu-ad-mute/`) | Feasibility test pending |

## What it can't do

- **Remove Hulu ads.** They're stitched into the video stream. The best possible is muting them.
- **Change the Apple TV.** tvOS doesn't allow sideloading.

## Requirements

- Sony TV running Google TV (Android TV OS)
- Windows 11 PC on the same Wi-Fi network
- [Android SDK Platform-Tools](https://developer.android.com/tools/releases/platform-tools) (`winget install Google.PlatformTools`)

## Quick start

1. **On the TV:** Settings → System → About → click *Android TV OS build* 7 times. Then Developer options → turn on **USB debugging** / **Network debugging**. Note the TV's IP (Settings → Network).
2. **On the PC (PowerShell):**

   ```powershell
   git clone https://github.com/nainashee/smart-sony-tv.git
   cd smart-sony-tv
   .\scripts\connect.ps1 -TvIp 192.168.1.50
   .\scripts\export-packages.ps1
   ```
3. Review `packages/sony-disable.txt` (see [docs/debloat.md](docs/debloat.md)).
4. Preview, then apply:

   ```powershell
   .\scripts\debloat.ps1            # dry run — shows what would be disabled
   .\scripts\debloat.ps1 -Apply     # actually disables
   ```
5. Something broke? Undo:

   ```powershell
   .\scripts\restore.ps1            # re-enables everything in the list
   ```

## Safety

- Packages are **disabled**, never uninstalled. Every change is reversible with `restore.ps1`, and a factory reset returns the TV to stock.
- `debloat.ps1` refuses to touch protected system packages (Play Services, settings, inputs, TV framework, setup wizard).
- Turn **debugging off** on the TV when you're done.

## Repo layout

```
docs/            setup, debloat decisions, Hulu mute design
scripts/         PowerShell helpers (connect, export, debloat, restore)
packages/        reviewed disable list
hulu-ad-mute/    Android app (Phase 3)
```

## Disclaimer

Personal project, provided as-is. You're responsible for your own device. Not affiliated with Sony, Google or Hulu.
