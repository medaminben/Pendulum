# Output directories relative to the binary dir (out-of-source builds).
# Falls back to <source>/build when configuring in-tree.

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    set(PROJECT_BUILD_OUTPUT ${CMAKE_SOURCE_DIR}/build)
else()
    set(PROJECT_BUILD_OUTPUT ${CMAKE_BINARY_DIR})
endif()

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BUILD_OUTPUT}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BUILD_OUTPUT}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BUILD_OUTPUT}/bin)

if(UNIX)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_BUILD_OUTPUT}/lib)
endif()

# Optional: set Qt6_DIR via -DQt6_DIR=... or CMAKE_PREFIX_PATH.
