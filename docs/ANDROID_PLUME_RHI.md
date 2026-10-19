# Plume RHI Android migration (work in progress)

Source branch: `android/rp6-bringup` at creation of `android/plume-rhi`.
Reference Plume upstream: `renderbag/plume` at `e48a55be0cff0f1e82b25cd0ab68be37357ee0f9` (2026-10-12).
License: Plume MIT; preserve attribution and ensure distribution includes its license.

## Actual state

Stage 0 only: `SB_PLUME_RHI=ON` fetches/compiles/links pinned Plume as an optional Android dependency. The existing `gpu/renderer.cpp` implementation continues using raw Vulkan. This is **not yet an alternate renderer**, no graphics commands are routed through Plume, and no Android build/device test has been performed. `SB_PLUME_RHI=OFF` preserves the prior path.

## Required architectural migration

Current rendering path: PM4 commands -> `gpu/command_processor.cpp` -> `gpu/renderer.cpp` -> native Vulkan; shader translation via `gpu/shader_translator.cpp`. Rendering uses external-host-memory imports, game EDRAM targets, compute resolves, Vulkan pipeline caches, async submissions and fences, dynamic rendering, surface presentation and GPU timestamps.

Plume exposes `RenderDevice`, `RenderCommandList`, resources, descriptor sets, graphics/compute pipelines, fences and Vulkan swapchain interfaces; it does not automatically implement Xenos EDRAM behavior. The migration must preserve guest memory coherency and correct draw/resolve order, especially Adreno/Android external memory and custom Turnip loader behavior.

1. **Loader interoperability gate:** Check Plume's Vulkan instance/device creation and volk global dispatch against SpeedBreaker's selected Android loader via libadrenotools. Never silently create a second device using the system loader. Prevent multiple volk implementations from interposing symbols. Explicitly test selected/system driver on device.
2. **Feature parity map:** Enumerate Vulkan usages in `gpu/renderer.cpp`. Map buffers, descriptors, shader modules, pipeline variants, attachments, barriers, memory imports and resolves onto Plume primitives. Identify uncovered features before rerouting rendering.
3. **Smallest real render pilot:** Route a non-gameplay offscreen graphics/compute pass through Plume on its own isolated code path; compare bitwise or bounded-error results to raw Vulkan. Avoid double ownership of host images or queues.
4. **Game rendering integration:** Move selected real game passes to Plume behind a per-pass and whole-backend rollback switch, preserving raw Vulkan as an independent implementation until parity and profiling pass.
5. **Performance:** Reuse the established 0.1.10/0.1.11 diagnostics; compare like-for-like warm Quick Race frames at 720p on RP6. Track complete-frame latency, pass GPU times, draw/resolve counts, power and thermals. Plume integration alone is not a measured optimization.

## Known risks and falsification criteria

- Different volk/Vulkan loader ownership -> wrong custom driver or crash. Verify actual driver ID/name and use one dispatch path.
- Backend migration reproduces existing 25.9ms color/offscreen work -> no meaningful performance gain; do not claim improvement without device evidence.
- Differences in barriers/texture layout/EDRAM synchronization -> visual corruption or invalid guest memory; compare render captures, race, tunnel, shadows and mirrors.
- Build dependency via Git submodules -> a CMake/NDK failure. Test clean Android configuration with `SB_PLUME_RHI=ON`; until then link integration is unverified.

## Validation not yet run

No build, APK signing, RP6 execution or benchmarking has been performed for this branch. The next action is a clean Android compile with `SB_PLUME_RHI=ON` and diagnostic verification of loader compatibility, followed by the first actual offscreen render pilot. Keep 0.1.11 and older APKs as rollback.
