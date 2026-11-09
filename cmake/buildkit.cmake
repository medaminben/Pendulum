# buildkit loader. A product keeps a copy as cmake/buildkit.cmake and includes
# it BEFORE project():
#
#   cmake_minimum_required(VERSION 3.29)
#   include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/buildkit.cmake)
#   project(MyProduct ...)
#
# buildkit is taken from, in this order:
#   1. BUILDKIT_DIR (cache entry, e.g. -DBUILDKIT_DIR=..., or environment)
#   2. ${CMAKE_SOURCE_DIR}/../buildkit, if it contains cmake/Buildkit.cmake
#   3. a git fetch of BUILDKIT_REPOSITORY at BUILDKIT_TAG into
#      ${CMAKE_BINARY_DIR}/_buildkit/src (populate only, nothing is built); the
#      fetched tag is written to ${CMAKE_BINARY_DIR}/_buildkit/tag
# and Buildkit.cmake is included. BUILDKIT_TAG (a tag or a branch name, not a
# commit SHA) and BUILDKIT_REPOSITORY may be set before including.
#
# Offline (BUILDKIT_OFFLINE or FETCHCONTENT_FULLY_DISCONNECTED ON, as a cache
# entry, a variable or an environment variable; they are OR'ed, so
# -DBUILDKIT_OFFLINE=OFF cannot undo an environment one), or a remote
# that does not answer a 30 s probe: an already fetched copy is reused when its
# stamped tag equals BUILDKIT_TAG ("tag vX.Y.Z, cached"); another tag is a
# FATAL_ERROR naming both. Without a copy it is a FATAL_ERROR too, because
# buildkit itself is required. Online with a changed tag, it is fetched again.
#
# Needs no compiler, so it works before project(). Idempotent.
include_guard(GLOBAL)

if(NOT DEFINED BUILDKIT_TAG)
    set(BUILDKIT_TAG "v2.0.1")
endif()
if(NOT DEFINED BUILDKIT_REPOSITORY)
    set(BUILDKIT_REPOSITORY "https://github.com/medaminben/buildkit.git")
endif()

set(_bk_from "")
if(NOT BUILDKIT_DIR AND DEFINED ENV{BUILDKIT_DIR})
    set(BUILDKIT_DIR "$ENV{BUILDKIT_DIR}")
endif()

if(BUILDKIT_DIR)
    if(NOT EXISTS "${BUILDKIT_DIR}/cmake/Buildkit.cmake")
        message(FATAL_ERROR
            "buildkit: BUILDKIT_DIR is '${BUILDKIT_DIR}', but "
            "${BUILDKIT_DIR}/cmake/Buildkit.cmake does not exist")
    endif()
    set(_bk_from "local working copy")
elseif(EXISTS "${CMAKE_SOURCE_DIR}/../buildkit/cmake/Buildkit.cmake")
    get_filename_component(BUILDKIT_DIR "${CMAKE_SOURCE_DIR}/../buildkit" ABSOLUTE)
    set(_bk_from "local working copy")
else()
    set(_bk_src   "${CMAKE_BINARY_DIR}/_buildkit/src")
    set(_bk_stamp "${CMAKE_BINARY_DIR}/_buildkit/tag")
    # A populated copy is reusable only for the tag it was fetched with.
    set(_bk_cache FALSE)
    set(_bk_cached_tag "")
    if(EXISTS "${_bk_src}/cmake/Buildkit.cmake")
        set(_bk_cache TRUE)
        if(EXISTS "${_bk_stamp}")
            file(READ "${_bk_stamp}" _bk_cached_tag)
            string(STRIP "${_bk_cached_tag}" _bk_cached_tag)
        endif()
    endif()
    set(_bk_use_cache FALSE)

    set(_bk_env_offline "$ENV{BUILDKIT_OFFLINE}")
    set(_bk_env_disc "$ENV{FETCHCONTENT_FULLY_DISCONNECTED}")
    if(BUILDKIT_OFFLINE OR FETCHCONTENT_FULLY_DISCONNECTED OR _bk_env_offline OR _bk_env_disc)
        if(NOT _bk_cache)
            message(FATAL_ERROR
                "buildkit: no local copy and offline mode is on. Set BUILDKIT_DIR to "
                "a buildkit checkout, or put one at ${CMAKE_SOURCE_DIR}/../buildkit")
        endif()
        set(_bk_use_cache TRUE)
    else()
        find_package(Git QUIET)
        if(NOT GIT_EXECUTABLE)
            message(FATAL_ERROR
                "buildkit: git not found, cannot fetch ${BUILDKIT_REPOSITORY}. Set "
                "BUILDKIT_DIR or install git")
        endif()
        # Probe first so a dead network fails in 30 s and not after minutes.
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E env GIT_TERMINAL_PROMPT=0
                    "${GIT_EXECUTABLE}" ls-remote --exit-code "${BUILDKIT_REPOSITORY}" "${BUILDKIT_TAG}"
            RESULT_VARIABLE _bk_rc OUTPUT_QUIET ERROR_QUIET TIMEOUT 30)
        if(NOT _bk_rc EQUAL 0)
            if(NOT _bk_cache)
                message(FATAL_ERROR
                    "buildkit: cannot reach ${BUILDKIT_REPOSITORY} (tag ${BUILDKIT_TAG}). Set "
                    "BUILDKIT_DIR to a local checkout")
            endif()
            set(_bk_use_cache TRUE)
        endif()
    endif()

    if(_bk_use_cache)
        if(NOT _bk_cached_tag STREQUAL BUILDKIT_TAG)
            message(FATAL_ERROR
                "buildkit: the cached copy in ${_bk_src} is tag "
                "'${_bk_cached_tag}', but BUILDKIT_TAG is ${BUILDKIT_TAG}, and buildkit "
                "cannot be fetched (offline or unreachable). Set BUILDKIT_DIR, or "
                "reconfigure online")
        endif()
        set(_bk_from "tag ${BUILDKIT_TAG}, cached")
    else()
        include(FetchContent)
        set(_bk_old_base "${FETCHCONTENT_BASE_DIR}")
        set(FETCHCONTENT_BASE_DIR "${CMAKE_BINARY_DIR}/_buildkit")
        FetchContent_Declare(buildkit_src
            GIT_REPOSITORY "${BUILDKIT_REPOSITORY}"
            GIT_TAG        "${BUILDKIT_TAG}"
            GIT_SHALLOW    TRUE
            SOURCE_DIR     "${_bk_src}"
            SOURCE_SUBDIR  buildkit_populate_only)  # folder does not exist: no add_subdirectory
        FetchContent_MakeAvailable(buildkit_src)
        if(_bk_old_base)
            set(FETCHCONTENT_BASE_DIR "${_bk_old_base}")
        else()
            unset(FETCHCONTENT_BASE_DIR)
        endif()
        file(WRITE "${_bk_stamp}" "${BUILDKIT_TAG}\n")
        set(_bk_from "tag ${BUILDKIT_TAG}")
    endif()
    set(BUILDKIT_DIR "${_bk_src}")
endif()

message(STATUS "buildkit: using ${BUILDKIT_DIR} (${_bk_from})")
include("${BUILDKIT_DIR}/cmake/Buildkit.cmake")
unset(_bk_from)
