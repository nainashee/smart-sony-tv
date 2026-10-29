# Debloat decisions

Every package considered for disabling gets one of three verdicts:

| Verdict | Meaning |
| --- | --- |
| Disable | Ads, promos, tracking or unused vendor apps. Safe to disable. |
| Your call | Works fine either way; depends on what you use (e.g. a streaming app, voice features). |
| Keep | Needed for the TV to boot, show inputs, play sound or update. Never disable. |

## Rules

- Disable with `pm disable-user --user 0`, never `uninstall`.
- Disable in small batches; reboot and test inputs, sound, picture and the remote after each.
- Replace the launcher (Projectivy) **before** touching the stock Google TV launcher.
- Keep `exports\all-packages.txt` as the original record.

## Decision log

| Package | What it is | Verdict | Notes |
| --- | --- | --- | --- |
| _to be filled from this TV's export_ | | | |
