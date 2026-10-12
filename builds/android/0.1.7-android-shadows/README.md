# SpeedBreaker One 0.1.7 — solid-shadow test

Signed optimized full ARM64 build. Package unchanged, code 8, same certificate as
0.1.6. Compiled clean source: 02a9f372a5a2305a8cb7b7217719f162607fdc8a.

Includes the isolated upstream v0.1.3 depth-only solid-caster fix. Car, wall,
barrier and tunnel-roof draws use the empty fragment shader appropriate for Xenos
rather than the stale alpha-killing tree shader. The existing depth24 sunlight
fix remains. Other v0.1.3 changes are deferred for this comparison.

Install the directly delivered APK over 0.1.6 without clearing data. Run the same
720p Quick Race. Check the car's solid shadow and road/car shade in an available
tunnel/underpass. Check direction/stability while turning, mirror/HUD and audio.
No Career progression required. Allow first-run shader warm-up and automatic
captures to finish before comparing frame rate. No measured performance claim.

Optional local collection:

```sh
scripts/android/capture_visual_fidelity.sh
```

The collector accepts supported capture-enabled version codes >=6. It does not
require 0.1.5's old version name. It runs on the user's Linux desktop, never in
Work. Return one private archive if the defect remains. No device test yet.

APK checksum, native Build ID, source, certificate and toolchain are recorded in
build.json, SHA256SUMS and signature-verification.txt. Previous APKs are retained.
The new APK is delivered directly through ChatGPT; no new GitHub binary release
is claimed. No XEX, generated game source, credentials or private logs published.
