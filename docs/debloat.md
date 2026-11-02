# Debloat decisions

Reviewed on a **BRAVIA 4K VH21, Android TV OS 12**: 250 packages total, 239 preinstalled, 2 already disabled by Sony (`b2b.softap`, `b2b.vendorprotocol`).

Every package gets one of three verdicts:

| Verdict | Meaning |
| --- | --- |
| Disable | Ads, promos, tracking or demo mode. No visible feature loss. |
| Your call | Works fine either way; depends on what you use. |
| Keep | Needed for the TV to boot, show inputs, play sound, update or control connected devices. |

## Rules

- Disable with `pm disable-user --user 0`, never `uninstall`.
- Disable in small batches; reboot and test inputs, sound, picture and the remote after each.
- Replace the launcher (Projectivy) **before** touching the stock Google TV launcher.
- Keep `exports/all-packages.txt` as the original record.

## Disable (batch 1)

| Package | What it is | Why |
| --- | --- | --- |
| `tv.samba.ssm`, `tv.samba.ssm.ui` | Samba TV | ACR tracking: identifies what's on screen, including HDMI inputs, for ad targeting |
| `com.sonyericsson.idd.agent` | Sony IDD agent | Usage-data telemetry |
| `com.sony.dtv.promos` | Sony promos | Promotional content |
| `com.sony.dtv.sonyselect` | Sony Select | Promoted-apps row |
| `com.sonypicturescore` | Sony Pictures Core | Preloaded movie store |
| `com.sony.dtv.demosupport`, `demosystemsupport`, `multiscreendemo` | Retail demo mode | Only used on store display units |
| `com.google.android.feedback` | Google feedback | Crash/feedback reporter |
| `com.android.printspooler` | Print service | No printing on a TV |
| `com.google.android.play.games` | Play Games | Unused |

## Your call (batch 2)

| Group | Packages | Disable if |
| --- | --- | --- |
| Diagnostics | `com.qterics.da.product`, `com.sony.dtv.da.service` | You don't need Sony remote support |
| BRAVIA CAM | `sensingcamera.*`, `gestureapp`, `distancealert` | No BRAVIA CAM attached |
| Streaming apps | Prime Video, Disney+, Netflix, Paramount+, Sling, Tubi, Xumo, Pluto, Vudu, ESPN, Spotify, Apple TV app, YouTube Kids/Music/TV, Google TV Shop | You never open them |
| Extras | TalkBack, Eco dashboard, help guide, ambient screensaver, AirPlay, HomeKit | You don't use the feature |

## Keep

| Area | Packages (examples) | Why |
| --- | --- | --- |
| Android / Google core | `android`, `com.android.*` providers, `systemui`, `gms`, `gsf`, `vending`, `webview`, `permissioncontroller`, `packageinstaller`, `setupwraith` | OS won't function |
| TV core | `com.sony.dtv.tvx`, `tvapi`, `tvinput.*`, `mtktvapi.agent`, `com.mediatek.*`, `sonysystemservice`, `sonyvendorservice` | Inputs, tuner, picture pipeline |
| Settings | `com.android.tv.settings`, `com.sony.dtv.settings*`, `panelsettings`, `networksettings`, `audiooutput` | Settings menus |
| Sound & devices | `HomeTheatreControl`, `braviasync*`, `dolby.android.audio.service`, `irblaster`, `remotecontrolsettings`, `com.android.bluetooth` | Soundbar (HDMI-CEC), remote, Bluetooth |
| Casting & voice | `com.google.android.apps.mediashell` (Chromecast), `katniss` (Assistant), `tv.remote.service` (phone remote) | Features in daily use |
| Updates | `systemupdate`, `update`, `otaurlprovisioning` | Security patches |
| Hotel / pro mode | `com.sony.dtv.b2b.*` | Unused, but tied to system framework — little gain, not worth the risk |

## Log

| Date | Batch | Result |
| --- | --- | --- |
| _pending_ | 1 | |
