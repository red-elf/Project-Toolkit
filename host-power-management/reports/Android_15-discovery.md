# Android_15 — Discovery Report

**Status:** Skipped from CONST-033 rollout per user instruction (2026-04-27).
This report records what was discovered so any future re-evaluation has a baseline.

## Repository

```
github	git@github.com:ATMOSphere1234321/ATMOSphere-Android-15.git (fetch)
github	git@github.com:ATMOSphere1234321/ATMOSphere-Android-15.git (push)
upstream	git@github.com:ATMOSphere1234321/ATMOSphere-Android-15.git (fetch)
upstream	git@github.com:ATMOSphere1234321/ATMOSphere-Android-15.git (push)
vasicdigitalmirror	git@github.com:vasic-digital/ATMOSphere-Android-15.git (fetch)
vasicdigitalmirror	git@github.com:vasic-digital/ATMOSphere-Android-15.git (push)
```

- Submodules (recursive): **74**
- Top-level layout (truncated): `AGENTS.md Android.bp art assets bionic bootable bootimage_build.log bootstrap.bash build BUILD build_flashing_images.sh build_full.log build_kernel.sh build_log.txt build_output.log build_session3.log build.sh build_super.log build_vndk33.log build_vndk_sp_compat.log CLAUDE.md config.ini CONTRIBUTING.md cts dalvik developers development device docs external `
- Recent commits:

```
070f0139ed6 smarttube-player: bump MediaServiceCore pointer to 600ef1a2 (Constitution §3 cascade)
05b1bad95e5 Final cascade — gramophone 87564110 / nova 83c15ee / smarttube 4ed2154f6 + HelixQA Challenges/Containers/DocProcessor/HelixQA/LLMProvider/VisionEngine pointer updates (Constitution §3 cascade, all child remotes pushed in this same session)
acd6eb491b1 Submodule pointer cascade — gramophone-player b9b583c0 + vlc-player 44ec7ea0b + smarttube-player 70fe83738 (Constitution §3 cascade)
893cd78b80b 1.1.4-dev-0.0.5 changelog exports (html/txt/json)
882c27483cd 1.1.4-dev-0.0.5 — re-validation cycle (no source change vs 0.0.4). Fresh rebuild + reflash on both devices, MD5 2e470e58b3d, build 21:44. Autonomous_qa 35/35 PASS each. Brightness 0664 verified end-to-end. 5 sampled tests outside autonomous_qa's mapping (test_audio_device_switching/test_settings_connected_devices/test_navigation_bar/test_internet_access/test_native_libraries) all PASS. Pre-build 1529/1529 PASS. Convergence reached for autonomously-addressable scope. test_all_fixes.sh Phase 3 (factory reset) skipped per Phase 4.5 architectural finding. External blockers (Pavel #1 GSF / Pavel #4 orientation / Netflix Dolby castlabs) unchanged. Tag is a checkpoint marker, not a fix release.
```

## Static-scanner result

`exit=1` — **29 forbidden host-power-management invocations found**, ALL in third-party / upstream / external code paths:

| Directory | Origin | Notes |
|-----------|--------|-------|
| `external/autotest/server/cros/faft` | ChromeOS Auto Test | DUT reboot for firmware tests |
| `external/autotest/server/site_tests/firmware_ConsecutiveBoot` | ChromeOS | DUT consecutive-boot test |
| `external/coreboot/Documentation` | coreboot | Firmware docs (text mentions of `reboot`) |
| `external/coreboot/src/ec/google/chromeec` | coreboot | ChromeEC reboot helpers |
| `external/grpc-grpc-java/core/src/test/java/io/grpc/internal` | gRPC Java | Test code |
| `external/grpc-grpc-java/okhttp/src/test/java/io/grpc/okhttp` | gRPC Java | Test code |
| `external/grpc-grpc/src/cpp/server` | gRPC C++ | Server graceful shutdown |
| `external/libcxx/utils/docker/scripts` | LLVM libc++ | Docker build helpers |
| `external/ltp/testcases/kdump` | Linux Test Project | kdump tests |
| `external/pytorch/.github/scripts` | PyTorch | CI scripts |
| `external/rust/android-crates-io/crates/grpcio-sys/grpc/src/cpp/server` | gRPC (vendored Rust) | Server graceful shutdown |
| `external/webrtc/rtc_base` | WebRTC | Test/utility |
| `frameworks/native/libs/binder/tests` | AOSP framework | Binder reboot tests |
| `kernel-5.10/arch/arm/mach-omap2` | Linux kernel | OMAP power management |
| `kernel-5.10/arch/arm/mach-spear` | Linux kernel | SPEAr power management |
| `kernel-5.10/drivers/net/ethernet/microchip` | Linux kernel | Driver text |
| `kernel-5.10/sound/soc/codecs` | Linux kernel | Codec docs |
| `kernel-5.10/tools/power/pm-graph` | Linux kernel | Power-management graph tool |
| `kernel/tests/net/test/rootfs` | Linux kernel | Network test rootfs |

**100 % of hits are in upstream third-party code** — `external/`, `frameworks/native/` (AOSP), `kernel-5.10/` (Linux kernel), `kernel/tests/` (Linux test code). None originate from project-owned source files.

## Why this is OK to skip

1. The user explicitly excluded Android_15 from the rollout.
2. Per the workspace skip policy ("skip 3rd party submodules / upstreams"), these matches are exactly the kind of third-party code that should be allowlisted, not modified.
3. None of the matches affect the **build host** running mission-critical CLI agents — they target the Device Under Test (Chromebook firmware, AOSP test harness, kernel internals) at runtime on those devices.

## If Android_15 is ever brought into the rollout

Recommended scanner allowlist additions (extend `EXCLUDE_PATHS` in `scripts/host-power-management/check-no-suspend-calls.sh`):

```bash
"external/"
"frameworks/native/libs/binder/tests/"
"kernel-5.10/"
"kernel/tests/"
```

After that, the deploy + governance flow can run as in any other project.

## What this report does NOT do

- No artifacts vendored into Android_15.
- No CONSTITUTION/AGENTS/CLAUDE patches applied to Android_15.
- No commits, no pushes.
- The Android_15 working tree was not modified by the scan (read-only `grep -RIn`).

