# Setup

About 10 minutes. The PC and the TV must be on the same Wi-Fi network.

## On the TV

1. Settings → System → About → click **Android TV OS build** 7 times to unlock Developer options.
2. Settings → System → Developer options → turn on **USB debugging** (and **Network debugging** if listed).
3. Settings → Network & Internet → your Wi-Fi → note the **IP address**.
4. Turn off viewing tracking: find **Samba Interactive TV** and any viewing-data / ACR options (usually under Privacy or Device Preferences) and opt out.
5. Optional quick win: Settings → Accounts & Sign In → your account → **Apps only mode**.

## On the Windows 11 PC

```powershell
winget install Google.PlatformTools
# close and reopen the terminal
git clone https://github.com/nainashee/smart-sony-tv.git
cd smart-sony-tv
.\scripts\connect.ps1 -TvIp <TV_IP>
```

Accept the **Allow USB debugging?** prompt on the TV and tick **Always allow from this computer**.

If PowerShell blocks the scripts, allow local scripts for your user once:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

## When you're finished

Turn **USB / Network debugging off** on the TV so the debug port isn't left open on your network.
