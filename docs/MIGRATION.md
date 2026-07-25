# Migration guide (≤ 1.3 → 1.4)

This guide explains how to move an existing UnitPro-based tree onto the 1.4 boilerplate.

## Summary of breaking / notable changes

| Area | Before (≤ 1.3) | After (1.4) |
|------|----------------|-------------|
| Version | `1.3.0` | `1.4.0` |
| Scaffold | Often only generated at configure time | `Core` committed; generator optional |
| GoogleTest | `GIT_TAG main` | Pinned `v1.15.2` |
| Network probe | Ping `www.google.com` | Removed; use `FETCHCONTENT_FULLY_DISCONNECTED` if needed |
| Export headers | Written into source `include/` | Generated under the **build** tree |
| Public include | `"UnitPro_Core_export.h"` (relative) | `<UnitPro/Core/UnitPro_Core_export.h>` |
| Verbose build | Default `ON` | Default `OFF` |
| Warnings | Global `-Wall -Werror` flags | Per-target via `unitpro_set_warnings` |
| Generator module | `cmake/libraryGenerator.cmake` | `cmake/modules/LibraryGenerator.cmake` |
| Install/export | Missing | `InstallConfig` + `UnitProConfig.cmake` |
| Docs folder | Requirements PDFs | Architecture / contributing docs |
| CI | None | GitHub Actions CI + release |

## Step-by-step

### 1. Update the root project

- Bump `project(UnitPro VERSION …)` or rename `CMAKE_ROOT_NAME` if you forked under another brand.
- Replace ad-hoc options with the 1.4 option set (`ENABLE_COVERAGE`, `GENERATE_SCAFFOLD`, …).
- Point `CMAKE_MODULE_PATH` at both `cmake/` and `cmake/modules/`.

### 2. Move custom CMake helpers

| Old | New |
|-----|-----|
| Keep using `include(BuildUtils)` | Still valid |
| `include(libraryGenerator)` | `include(LibraryGenerator)` (loaded from `Common.cmake`) |
| Copy any local patches from old `libraryGenerator.cmake` into `cmake/modules/LibraryGenerator.cmake` | Prefer extending templates under `cmake/template/` |

### 3. Fix export header includes

In every public header:

```cpp
// old
#include "UnitPro_Core_export.h"

// new
#include <UnitPro/Core/UnitPro_Core_export.h>
```

Remove tracked `*_export.h` files from the source tree; they are generated at build time and gitignored.

### 4. Commit generated libraries you care about

If your workflow only generated trees during configure:

1. Configure once with `GENERATE_SCAFFOLD=ON`.
2. Review `libraries/` and `applications/`.
3. Commit the ones that are product code.
4. Optionally set `GENERATE_SCAFFOLD=OFF` in CI for hermetic builds.

### 5. Adopt presets and CI

- Copy `CMakePresets.json`, `.clang-format`, `.clang-tidy`, `package.json`, and `.github/workflows/`.
- Run `npm install` once per developer machine for hooks.
- Ensure CI images install CMake ≥ 3.29 and a C++20 toolchain.

### 6. Adjust application CMakeLists

Avoid passing empty `UI` / `HEADERS` / `RESOURCES` keywords (CMake CMP0174). Prefer:

```cmake
create_application(
    NAME         Core_Console
    ENTRY        Console
    SOURCES      Core_Console.cpp
    DEPENDENCIES UnitPro::Core
)
```

### 7. Verify

```bash
cmake --preset ci
cmake --build --preset ci --parallel
ctest --preset ci --output-on-failure
```

## Decision log (why these changes)

1. **Pinned GoogleTest** — reproducible CI; `main` can break overnight.
2. **No internet ping** — sandboxes and air-gapped agents fail otherwise.
3. **Binary-dir export headers** — keeps the source tree clean and merge-friendly.
4. **Committed Core scaffold** — template must build on a fresh clone without side effects.
5. **Per-target warnings** — avoids forcing `-Werror` onto third-party FetchContent targets.
6. **Install/export** — libraries become consumable components, not just in-repo targets.
7. **Node only for hooks** — C++ remains the product; Commitlint/Husky are optional DX.

## Rollback

If you must stay on 1.3 behavior temporarily:

- Keep your old `libraryGenerator.cmake` and export-in-source layout.
- Do not merge 1.4 CI until export includes and presets are updated.
- Prefer a short-lived branch rather than mixing both layouts in `main`.
