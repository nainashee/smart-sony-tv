# Hulu ad auto-mute

Goal: mute the TV while a Hulu ad plays and unmute when it ends. Hulu ads can't be removed, because they're part of the stream, but the volume is ours.

## How it would work

An Android **Accessibility Service** that watches only the Hulu app. About once per second it checks the on-screen text for Hulu's ad indicator (an "Ad" label or countdown). Indicator appears → mute. Indicator disappears → unmute.

## Step 1: Feasibility test

The whole idea depends on whether Hulu's TV app exposes the ad label as readable text.

1. Play a show in the Hulu app on the Sony and wait for an ad.
2. During the ad:

   ```powershell
   adb shell uiautomator dump /sdcard/ad.xml
   adb pull /sdcard/ad.xml exports\ad.xml
   ```
3. During normal playback, repeat and save as `exports\show.xml`.
4. Compare. If `ad.xml` contains ad-related text that `show.xml` doesn't, it's a go.

**Result:** _pending_

## Step 2: Build (if the test passes)

- Android Studio project in `hulu-ad-mute/`
- Accessibility Service scoped to the Hulu package
- Mute/unmute via `AudioManager`
- Sideload with `adb install`, enable under Settings → Accessibility

## Known limits

- About 1 second of ad audio before the mute kicks in.
- Hulu app updates can rename or move the label and break detection.
- Works only in the Hulu app on the Sony, not on an Apple TV over HDMI.
