# Common project settings. Include early from the root CMakeLists.txt.

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

include(GNUInstallDirs)
include(BuildUtils)
include(LibraryGenerator)
include(BuildLocation)
include(CompilerWarnings)
include(Coverage)

if(BUILD_VERBOSE_OUTPUT)
    include(DebugUtils)
    set(CMAKE_VERBOSE_MAKEFILE ON)
    dump_cmake_vars(configLogStart.log)
endif()

if(ENABLE_CLANG_TIDY)
    find_program(CLANG_TIDY_EXE NAMES clang-tidy)
    if(CLANG_TIDY_EXE)
        set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY_EXE}")
        message(STATUS "clang-tidy enabled: ${CLANG_TIDY_EXE}")
    else()
        message(WARNING "ENABLE_CLANG_TIDY is ON but clang-tidy was not found")
    endif()
endif()

# Prefer a local _deps cache over network; do not ping external hosts.
if(DEFINED ENV{FETCHCONTENT_FULLY_DISCONNECTED})
    set(FETCHCONTENT_FULLY_DISCONNECTED $ENV{FETCHCONTENT_FULLY_DISCONNECTED})
endif()

if(BUILD_TESTING)
    include(CTest)
    enable_testing()
    include(TestUtils)
endif()

if(BUILD_QT_UI)
    include(QtSupport)
endif()

if(BUILD_VERBOSE_OUTPUT)
    dump_cmake_vars(configLogEnd.log)
endif()
