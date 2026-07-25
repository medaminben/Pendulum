include(FetchContent)

# Pin GoogleTest for reproducible builds (do not track `main`).
set(UNITPRO_GTEST_VERSION "v1.15.2" CACHE STRING "GoogleTest git tag")

FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG        ${UNITPRO_GTEST_VERSION}
    GIT_SHALLOW    TRUE
)

set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

include(GoogleTest)
