# Plume Vulkan integration tests

Requires CMake 3.24+, C++20 compiler, Ninja, X11 development headers, glslang,
spirv-val, a Vulkan 1.2 implementation with dynamic rendering, and Khronos
validation layers. Mesa lavapipe works without a physical GPU or game assets.

```sh
cmake -S tests/plume -B build/plume-test -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build/plume-test -j4
# Select your lavapipe ICD JSON if another Vulkan implementation is default.
ctest --test-dir build/plume-test --output-on-failure
```

CMake fetches the exact Plume and submodule revisions and applies the source
patch used by Android. GLSL is synthetic and SPIR-V is validated before linking.
The test enables Khronos core and synchronization validation, and fails on errors.

- Standard Plume shader/pipeline/framebuffer/image/buffer APIs render an offscreen
  image. Diagnostic image-to-buffer readback uses native Vulkan because Plume's
  current Vulkan copyTextureRegion doesn't implement that direction.
- The same image must match direct Vulkan and the game's Plume interoperability
  path byte-for-byte, including indexed draws, viewport/scissor and push constants.
- A Plume-owned compute pipeline, descriptor set and storage buffer produce 257
  reference-checked words through both native and Plume command recording.
- An allocated mutable-format image is owned/freed by the shared Plume allocator.
- The native instance/device/dispatch survive Plume initialization and shutdown.
- Runtime Legacy selection executes the same comparison with zero Plume backend
  operation counters. A separate target compiles/links the adapter without Plume
  and checks recovery from a stale saved Plume setting.

A host GPU test is not an Adreno test or a game-image parity/performance result.
