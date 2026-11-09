cmake_minimum_required(VERSION 3.29)

# buildkit is loaded before project(): cmake/buildkit.cmake (the loader) uses
# BUILDKIT_DIR, else ../buildkit, else the pinned buildkit tag.
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/buildkit.cmake)

# The version comes from the latest vX.Y.Z git tag.
buildkit_git_version(${CMAKE_CURRENT_SOURCE_DIR}
    PENDULUM_VERSION PENDULUM_VERSION_FULL FALLBACK 0.1.0)

project(Pendulum VERSION ${PENDULUM_VERSION} LANGUAGES CXX)
set(${PROJECT_NAME}_VERSION_FULL "${PENDULUM_VERSION_FULL}")
message(STATUS "Pendulum version: ${PENDULUM_VERSION_FULL}")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# ---------------------------------------------------------------------------
# Build options
# ---------------------------------------------------------------------------
option(BUILD_SHARED_LIBS  "Build the libraries as shared libraries"           ON)
option(BUILD_APPS         "Build the applications"                            ON)
option(BUILD_QT_UI        "Build the Qt viewer (requires Qt 5 or 6)"          OFF)
option(GENERATE_SCAFFOLD  "Generate missing libraries from buildkit templates" ON)
option(ENABLE_COVERAGE    "Enable code coverage instrumentation"              OFF)
option(ENABLE_CLANG_TIDY  "Run clang-tidy during compilation"                 OFF)

include(CTest)     # BUILD_TESTING, ON by default
include(Coverage)  # the `coverage` target when ENABLE_COVERAGE is ON

if(ENABLE_CLANG_TIDY)
    find_program(CLANG_TIDY_EXE NAMES clang-tidy REQUIRED)
    set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY_EXE}")
endif()

if(BUILD_QT_UI)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/QtSupport.cmake)
endif()

# ---------------------------------------------------------------------------
# Libraries: add a name here and reconfigure to generate libraries/<Name>/
# (flat layout: <Name>::<Name>, include/<Name>/, namespace <Name>) and its
# console and wxWidgets apps under applications/<Name>/.
# ---------------------------------------------------------------------------
set(PENDULUM_LIBRARIES
    Pendulum
)

set(libraries_dir    ${CMAKE_CURRENT_SOURCE_DIR}/libraries)
set(applications_dir ${CMAKE_CURRENT_SOURCE_DIR}/applications)

if(GENERATE_SCAFFOLD)
    generate_libraries(
        LIBRARIES_LIST     ${PENDULUM_LIBRARIES}
        LIBRARIES_LOCATION ${libraries_dir}
        APPS_LOCATION      ${applications_dir}
        TEMPLATE_LOCATION  ${BUILDKIT_ROOT}/template
    )
endif()

if(EXISTS ${libraries_dir}/CMakeLists.txt)
    add_subdirectory(${libraries_dir})
endif()

if(BUILD_APPS AND EXISTS ${applications_dir}/CMakeLists.txt)
    add_subdirectory(${applications_dir})
endif()

if(EXISTS ${libraries_dir}/CMakeLists.txt)
    include(InstallConfig)
endif()
