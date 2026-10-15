# Signed Android 0.1.8 performance + upstream test

Full upstream v0.1.4 merged into the Android branch, including gamma and
brightness, nitrous trails, tuning labels, queued/low-rate timing and renderer /
presentation fixes. Preserves Android ISO, stereo audio, shaders, shadows and
lifecycle paths. Native source is 3bea7fc; build.json records exact identities.

GPU Scheduling trials guarded overlap (default), Conservative restores full
barriers, and Compare alternates policies every 480 frames. No image readbacks
by default. No on-device speed gain is claimed; a neutral result is possible.
Existing 0.1.7 artifact is preserved and its checksum verified unchanged.

Install over the current app without clearing data. Same Quick Race/car/track,
720p, Frame Rate 60, same driver/power mode. Warm up 60 seconds, then Compare
for 4 minutes. Check road, car/tunnel shadows, mirror, reflections, foliage,
audio, nitrous trails, tuning labels and brief background/resume. Start a second
race. Return one scripts/android/capture_performance.sh archive plus observed
FPS/power ranges. If faults appear, choose Conservative and restart; 0.1.7 is
the full previous-release rollback. No Career progression or cloud ADB needed.

Gamma is on by upstream default; if washed out reset the game's brightness
slider to middle. Gamma off + wrapper brightness 0 restores previous tone.

Validation: optimized full ARM64 link, all 56,146 regenerated mapping symbols,
26 host regression suites (edge-bars uses Clang; GCC rejects its existing lambda
default argument), eight compiled/optimized/validated Vulkan 1.1/1.2 synthetic
SPIR-V modules, script syntax, APK zip/native-library equality, package/version,
APK v2 certificate and preserved 0.1.7 checksum. Source/build checks do not
establish Adreno visual correctness, installation or performance.

Packaging used installed SDK Build Tools 35.0.0 via a Gradle init override and
android.aapt2FromMavenOverride, sbNativeDir=build/package-018, sbDiagnostics=OFF,
sbBringup=ON. Native build uses build/android-perf, RelWithDebInfo (-O2), NDK r28c.
No XEX, generated game code, signing inputs or private device logs are published.
