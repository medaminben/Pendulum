# Pendulum Simulation

https://github.com/user-attachments/assets/afd8e139-eb02-4788-b706-54277f482d8d

Physics library and Qt viewer for a simple pendulum, structured with the [UnitPro](docs/ARCHITECTURE.md) template: public library API, private implementation, console/Qt apps, tests, install/export, and CI.

## Layout

```
Pendulum/
├── applications/Pendulum/
│   ├── Pendulum_Console/   # CLI demo (library consumer)
│   └── Pendulum_Qt_UI/     # Qt Viewer (UI only)
├── libraries/Pendulum/     # Business logic (UnitPro::Pendulum)
│   ├── include/            # Public API
│   ├── src/                # Private implementation
│   └── test/               # GoogleTest
├── cmake/                  # UnitPro build helpers + scaffolds
└── .github/workflows/      # CI + release
```

## Requirements

| Tool | Version |
|------|---------|
| CMake | ≥ 3.29 |
| C++ compiler | GCC 12+, Clang 15+, or MSVC 19.3+ |
| Qt 5/6 | for `BUILD_QT_UI` / preset `qt` |

## Quick start

```bash
cmake --preset default
cmake --build --preset default
ctest --preset default --output-on-failure

./build/default/bin/Pendulum_Console
```

Qt viewer:

```bash
cmake --preset qt
cmake --build --preset qt
./build/qt/bin/Pendulum_Qt_UI
```

## Library usage

```cpp
#include <UnitPro/Pendulum/Pendulum.h>

UnitPro::Pendulum::Simulator sim({150.0F, 500.0F});
sim.start();
auto const [x, y] = sim.position();
```

Consumers link `UnitPro::Pendulum`.

## Install / deploy

```bash
cmake --preset default -DCMAKE_INSTALL_PREFIX=$PWD/install
cmake --build --preset default
ctest --preset default --output-on-failure
cmake --install build/default
```

With Qt UI included in the package:

```bash
cmake --preset qt -DCMAKE_INSTALL_PREFIX=$PWD/install
cmake --build --preset qt
cmake --install build/qt
```

Downstream:

```cmake
find_package(UnitPro REQUIRED)
target_link_libraries(my_app PRIVATE UnitPro::Pendulum)
```

Tagged releases (`v*`) build, test, install, and publish a Linux tarball via `.github/workflows/release.yml`.

## Build options

| Option | Default | Description |
|--------|---------|-------------|
| `BUILD_SHARED_LIBS` | `ON` | Shared vs static libraries |
| `BUILD_APPS` | `ON` | Build applications |
| `BUILD_TESTING` | `ON` | Unit tests |
| `BUILD_QT_UI` | `OFF` | Build `Pendulum_Qt_UI` |
| `ENABLE_COVERAGE` | `OFF` | gcov instrumentation |

## Documentation

| Doc | Topic |
|-----|-------|
| [Architecture](docs/ARCHITECTURE.md) | Layers and dependency rules |
| [Adding libraries](docs/ADDING_LIBRARIES.md) | Scaffold workflow |
| [Contributing](docs/CONTRIBUTING.md) | Style and commits |
| [CI/CD](docs/CI_CD.md) | Pipelines and presets |

## License

MIT — see [LICENSE](LICENSE).
