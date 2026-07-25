# Optional coverage flags (GCC/Clang + gcov / llvm-cov).

if(NOT ENABLE_COVERAGE)
    return()
endif()

if(NOT CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    message(WARNING "ENABLE_COVERAGE is supported for GCC/Clang only")
    return()
endif()

message(STATUS "Code coverage instrumentation enabled")
add_compile_options(--coverage -O0 -g)
add_link_options(--coverage)

find_program(GCOV_PATH gcov)
find_program(LCOV_PATH lcov)
find_program(GENHTML_PATH genhtml)

# Ubuntu 24.04+ lcov is stricter about gcov mismatches from macros (e.g. GTest).
if(LCOV_PATH AND GENHTML_PATH)
    add_custom_target(coverage
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/coverage
        COMMAND ${LCOV_PATH}
            --ignore-errors mismatch,gcov,unused,empty
            --directory ${CMAKE_BINARY_DIR}
            --zerocounters
        COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
        COMMAND ${LCOV_PATH}
            --ignore-errors mismatch,gcov,unused,empty
            --directory ${CMAKE_BINARY_DIR}
            --capture
            --output-file ${CMAKE_BINARY_DIR}/coverage/coverage.info
        COMMAND ${LCOV_PATH}
            --ignore-errors mismatch,gcov,unused,empty
            --remove ${CMAKE_BINARY_DIR}/coverage/coverage.info
            '/usr/*' '*/_deps/*' '*/test/*' '*/googletest/*'
            --output-file ${CMAKE_BINARY_DIR}/coverage/coverage.filtered.info
        COMMAND ${GENHTML_PATH}
            --ignore-errors source,empty
            ${CMAKE_BINARY_DIR}/coverage/coverage.filtered.info
            --output-directory ${CMAKE_BINARY_DIR}/coverage/html
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Generating coverage report in ${CMAKE_BINARY_DIR}/coverage/html"
        VERBATIM
    )
else()
    add_custom_target(coverage
        COMMAND ${CMAKE_COMMAND} -E echo
            "Coverage instrumentation is ON, but lcov/genhtml were not found."
        COMMENT "Install lcov to generate HTML coverage reports"
    )
endif()
