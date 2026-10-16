# SpeedBreaker One Android 0.1.11 — renderer trials and custom Turnip

Full signed game runtime, ARM64, API 33+, code 12. Install over 0.1.10 with the
same package and retained certificate. No game data or custom driver included.
Compiled source: 53fcdf587c91aea76cfdd077735ed23a134109b2 (clean).

Shader predicate coalescing and conservative depth-stage reduction default ON,
with separate restart rollbacks in Advanced. Custom driver selection/import is
on the launch screen; System is the initial choice. Resume retains the current
loader; Restart applies selection. Import a flat ARM64 Turnip ZIP with meta.json.
Startup probes actual driver identity and falls back for loading/probe failure.
For native driver crashes, reopen the selector and select System.

Verification: 44 standalone host suites, Java archive boundary tests, release
Java compilation, 94 optimized/validated synthetic shader modules, full ARM64
link and all 56,736 mapping entries. APK v2/certificate, version/ABI/debug access,
ZIP/alignment, seven exact packaged libraries and BSD/MIT notices verified.
No direct libvulkan DT_NEEDED or exported Volk core dispatch symbols in libmain.
Gradle could not perform additional stripping on some libraries; these were
already stripped with NDK llvm-strip before packaging and byte identity passes.

No RP6 launch, Turnip compatibility, visual parity or FPS gain is verified.
The old 0.1.10 APK remains unchanged. First compare System at 720p60 with fixed
quality/scheduling, warm the same race, then compare one rollback or driver at
a time. Existing async preference is retained. Hardware vertex input and sky
reordering are not part of this build. See docs/ANDROID_PERFORMANCE_0111.md and
scripts/android/capture_performance.sh for measurements and acceptance.
