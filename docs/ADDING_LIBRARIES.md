# Adding libraries and applications

## Add a new library (recommended)

1. Edit the root `CMakeLists.txt` and append a name:

```cmake
set(UNITPRO_LIBRARIES Core Math)
```

2. Reconfigure:

```bash
cmake --preset default
```

3. If `libraries/Math` did not exist, the scaffold generator creates:

```
libraries/Math/
  CMakeLists.txt
  include/UnitPro/Math/Math.h
  src/Math.cpp
  src/Math_impl.h
  src/Math_impl.cpp
  test/src/test_Math.cpp
  test/data/MathTestData.txt

applications/Math/
  CMakeLists.txt
  Math_Console/
    CMakeLists.txt
    Math_Console.cpp
```

4. Implement the real API in `include/` + `src/`, expand tests, rebuild:

```bash
cmake --build --preset default
ctest --preset default --output-on-failure
```

## Public vs private headers

| Location | Visibility | Include style |
|----------|------------|---------------|
| `include/UnitPro/<Lib>/` | Public | `#include <UnitPro/Lib/Lib.h>` |
| `src/` | Private | `#include "Lib_impl.h"` |

Keep export macros on public symbols only:

```cpp
int UNITPRO_MATH_API multiply(int lhs, int rhs);
```

## Wire custom dependencies

In the library `CMakeLists.txt`:

```cmake
set(PRIVATE_DEPS Some::PrivateDep)
set(PUBLIC_DEPS  Other::PublicDep)

create_library(
    LIB_NAME             ${TARGET_NAME}
    LIB_FILES            ${TARGET_FILES}
    PRIVATE_DEPENDENCIES ${PRIVATE_DEPS}
    PUBLIC_DEPENDENCIES  ${PUBLIC_DEPS}
    TEST_DISCOVER        ON
    TEST_SOURCES         ${TST_SOURCES}
    TEST_DEPENDENCIES    ${TEST_DEPS}
)
```

- **PUBLIC** — consumers inherit include paths / link flags
- **PRIVATE** — only this library sees them

## Disable generation

If you manage trees entirely by hand:

```bash
cmake --preset default -DGENERATE_SCAFFOLD=OFF
```

Remember to keep `libraries/CMakeLists.txt` and `applications/CMakeLists.txt` in sync with `add_subdirectory(...)` entries.

## Qt UI apps

1. Install Qt 5 or 6 and ensure CMake can find it (`CMAKE_PREFIX_PATH` / `Qt6_DIR`).
2. Configure with `-DBUILD_QT_UI=ON`.
3. New scaffolds get a `*_Qt_UI` app when Qt is found at generation time.
4. Existing libraries need a manual Qt app (copy from `cmake/template/app/`).

## Checklist for a production-ready library

- [ ] Public headers document intent (brief comments are enough)
- [ ] Implementation details stay in `*_impl`
- [ ] Unit tests cover happy path and edge cases
- [ ] No includes from other libraries’ `src/`
- [ ] CI green (format, build, test)
