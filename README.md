<h1 align="center">Pendulum</h1>

<p align="center">
  <a href="https://github.com/medaminben/Pendulum/actions/workflows/ci.yml"><img alt="CI" src="https://github.com/medaminben/Pendulum/actions/workflows/ci.yml/badge.svg?branch=main"></a>
  <a href="https://github.com/medaminben/Pendulum/actions/workflows/codeql.yml"><img alt="CodeQL" src="https://github.com/medaminben/Pendulum/actions/workflows/codeql.yml/badge.svg?branch=main"></a>
  <a href="https://github.com/medaminben/Pendulum/releases/latest"><img alt="release" src="https://img.shields.io/github/v/release/medaminben/Pendulum"></a>
  <img alt="C++20" src="https://img.shields.io/badge/C%2B%2B-20-00599C">
  <img alt="CMake 3.29" src="https://img.shields.io/badge/CMake-3.29-064F8C">
  <img alt="Qt 5 | 6" src="https://img.shields.io/badge/Qt-5%20%7C%206-41CD52">
  <img alt="GoogleTest" src="https://img.shields.io/badge/tests-GoogleTest-4285F4">
  <img alt="platform: Linux" src="https://img.shields.io/badge/platform-Linux-555">
  <a href="LICENSE"><img alt="license: MIT" src="https://img.shields.io/github/license/medaminben/Pendulum"></a>
</p>

<p align="center">
  <a href="#quick-start">Quick start</a> ·
  <a href="docs/">Docs</a> ·
  <a href="docs/architecture.md">Architecture</a> ·
  <a href="docs/CI_CD.md">CI/CD</a> ·
  <a href="https://github.com/medaminben/Pendulum/releases">Changelog</a>
</p>

Pendulum simulates a simple pendulum. The `Pendulum::Pendulum` library steps the
physics on a background thread at 60 steps per second; the Qt viewer draws the
rod and the bob, and the console app prints the first ten positions. The build
uses [buildkit](https://github.com/medaminben/buildkit).

https://github.com/user-attachments/assets/afd8e139-eb02-4788-b706-54277f482d8d

## Quick start

Debian/Ubuntu:

```bash
sudo apt install build-essential cmake git ninja-build
cmake --preset default
cmake --build --preset default
ctest --preset default
./build/default/bin/Pendulum_Console
```

The Qt viewer needs Qt 5 or 6 (`sudo apt install qt6-base-dev`):

```bash
cmake --preset qt
cmake --build --preset qt
./build/qt/bin/Pendulum_Qt_UI
```

The **hold** button stops and restarts the redraw; the simulation keeps running
in the background.

## Requirements

| Tool | Version |
|------|---------|
| CMake | 3.29 or newer |
| Ninja | any recent version (all presets use it) |
| C++ compiler | C++20: GCC 12+ or Clang 15+ (CI uses GCC and Clang 18 on Ubuntu) |
| Qt | 5 or 6, only for the viewer (`BUILD_QT_UI=ON`, preset `qt`) |

CMake loads [buildkit](https://github.com/medaminben/buildkit) from `BUILDKIT_DIR`, else a sibling checkout
`../buildkit`, else it fetches the pinned tag `v2.0.0`. GoogleTest v1.15.2 is
used when installed and fetched otherwise.

## Repository layout

```
Pendulum/
├── libraries/Pendulum/        Pendulum::Pendulum, the physics library
│   ├── include/Pendulum/      public headers
│   ├── src/                       private implementation
│   └── test/                      GoogleTest
├── applications/Pendulum/
│   ├── Pendulum_Console/      prints ten simulation steps
│   └── Pendulum_Qt_UI/        Qt viewer
├── cmake/                     build helpers and library scaffolds
└── .github/workflows/         CI and release
```

## Using the library

```cpp
#include <Pendulum/Pendulum.h>

Pendulum::Simulator sim({150.0F, 500.0F});  // bob position in scene pixels
sim.step();                                          // or sim.start() for the 60 Hz thread
auto const [x, y] = sim.position();
```

The [library README](libraries/Pendulum/README.md) describes the API, the
coordinates and the threading rules.

Installed, the library is found with:

```cmake
find_package(Pendulum REQUIRED)
target_link_libraries(my_app PRIVATE Pendulum::Pendulum)
```

```bash
cmake --preset default -DCMAKE_INSTALL_PREFIX=$PWD/install
cmake --build --preset default
cmake --install build/default
```

## Build options

| Option | Default | Description |
|--------|---------|-------------|
| `BUILD_SHARED_LIBS` | `ON` | Shared or static libraries |
| `BUILD_APPS` | `ON` | Build the applications |
| `BUILD_TESTING` | `ON` | Build and register the unit tests |
| `BUILD_QT_UI` | `OFF` | Build `Pendulum_Qt_UI` |
| `ENABLE_COVERAGE` | `OFF` | gcov instrumentation |
| `ENABLE_CLANG_TIDY` | `OFF` | Run clang-tidy while compiling |
| `GENERATE_SCAFFOLD` | `ON` | Create missing libraries from buildkit's templates |

## Documentation

| Document | For | Topic |
|----------|-----|-------|
| [docs/README.md](docs/README.md) | everyone | Index of all documents |
| [Architecture](docs/architecture.md) | developers | Layers, targets, threading, dependency rules |
| [Pendulum library](libraries/Pendulum/README.md) | library users | API, coordinates, invariants |
| [Adding libraries](https://github.com/medaminben/buildkit/blob/main/docs/ADDING_LIBRARIES.md) | developers | Scaffolding a new library (buildkit) |
| [CI/CD](docs/CI_CD.md) | maintainers | Workflows, presets, releases |
| [Contributing](CONTRIBUTING.md) | contributors | Workflow, style, commits |

## Contributing

Bug reports and pull requests are welcome; see [CONTRIBUTING.md](CONTRIBUTING.md)
and the [Code of Conduct](CODE_OF_CONDUCT.md). Report security problems as
described in [SECURITY.md](SECURITY.md).

## License

[MIT](LICENSE)
