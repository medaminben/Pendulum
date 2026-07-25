cmake_minimum_required(VERSION 3.29)

project(UnitPro VERSION 1.4.0 LANGUAGES CXX)

# Global project name used by library aliases (UnitPro::Pendulum)
set(CMAKE_ROOT_NAME ${PROJECT_NAME})

# ---------------------------------------------------------------------------
# Build options
# ---------------------------------------------------------------------------
option(BUILD_SHARED_LIBS    "Build project libraries as shared libraries" ON)
option(BUILD_APPS           "Build applications"                          ON)
option(BUILD_VERBOSE_OUTPUT "Dump CMake variables and verbose make"       OFF)
option(BUILD_TESTING        "Build and register unit tests"               ON)
option(BUILD_QT_UI          "Build Qt-based applications (requires Qt)"   OFF)
option(ENABLE_COVERAGE      "Enable code coverage instrumentation"        OFF)
option(ENABLE_CLANG_TIDY    "Run clang-tidy during compilation"           OFF)
option(GENERATE_SCAFFOLD    "Generate missing libraries from templates"   ON)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules)

include(Common)

# Libraries to generate / include. Add new names here for scaffold generation.
set(UNITPRO_LIBRARIES Pendulum)

set(libraries_dir    ${CMAKE_SOURCE_DIR}/libraries)
set(applications_dir ${CMAKE_SOURCE_DIR}/applications)
set(template_dir     ${CMAKE_SOURCE_DIR}/cmake/template)

if(GENERATE_SCAFFOLD)
    generate_libraries(
        LIBRARIES_LIST     ${UNITPRO_LIBRARIES}
        LIBRARIES_LOCATION ${libraries_dir}
        APPS_LOCATION      ${applications_dir}
        TEMPLATE_LOCATION  ${template_dir}
    )
endif()

if(EXISTS "${libraries_dir}/CMakeLists.txt")
    add_subdirectory(${libraries_dir})
endif()

if(BUILD_APPS AND EXISTS "${applications_dir}/CMakeLists.txt")
    add_subdirectory(${applications_dir})
endif()

include(InstallConfig)

if(BUILD_VERBOSE_OUTPUT)
    dump_cmake_vars(BuildLogEnd.log)
endif()
