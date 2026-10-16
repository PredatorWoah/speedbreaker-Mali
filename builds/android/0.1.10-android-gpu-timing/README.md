# SpeedBreaker One 0.1.10 — Android pass timing

Optimized full-runtime arm64-v8a, code 11, same package and signing identity as
0.1.9. Existing branch; no alternate runtime. Source/build hashes in build.json.

Fixes persistent Android same-size SUBOPTIMAL swapchain recreation. Adds bounded
per-operation GPU timestamp sampling and shader compile/wait diagnostics.
GPU-pass CSV is included under app logs automatically; collector confirms output.
No game assets, private logs or signing material are committed.

Host pass timing bounds/wrap/unavailability and Android swapchain recovery tests
pass. Existing depth/shadow, ZPD, lifecycle, scheduling, clock and fullscreen
regressions pass. Full ARM64 link, all generated mapping symbols, new diagnostic
markers, packaged native byte identity, ZIP/alignment/version/ABI and v2 signature
checks pass. Collector mock covers success/missing-output/archive/Home paths.
RP6 speed, per-pass timing accuracy and visual correctness remain unverified.

Install over 0.1.9. Run the updated scripts/android/capture_performance.sh locally.
Warm same 720p/60 Quick Race, drive two minutes, start another race. Optionally
switch Asynchronous Shaders off live and repeat the warmed race. Keep scheduling
and work reduction unchanged. Type done: Home/background is automatic. Return
archive plus observed FPS, GPU usage and hitch differences.

Read docs/ANDROID_PERFORMANCE_0110.md for measurement limits and rollback.
