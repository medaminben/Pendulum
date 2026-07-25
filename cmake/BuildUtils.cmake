# Architecture detection and target helpers.

macro(get_project_arch)
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(PROJECT_ARCH_TARGET "amd64")
    elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(PROJECT_ARCH_TARGET "i386")
    else()
        message(WARNING "Unknown architecture!")
    endif()
endmacro()

function(check_project_name)
    set(options)
    set(single_value_args NAME)
    set(list_args NAME_LIST)
    cmake_parse_arguments(PARSE_ARGV 0 parameter "${options}" "${single_value_args}" "${list_args}")

    foreach(arg IN LISTS parameter_UNPARSED_ARGUMENTS)
        message(WARNING "unparsed argument: ${arg}")
    endforeach()

    foreach(proj IN LISTS parameter_NAME_LIST)
        if(proj STREQUAL parameter_NAME)
            message(FATAL_ERROR "name already exists: ${proj}")
        endif()
    endforeach()
endfunction()

macro(add_project name name_list)
    check_project_name(NAME ${name} NAME_LIST ${${name_list}})
    list(APPEND ${name_list} ${name})
endmacro()

# Convert "UnitPro::Core" -> "unitpro_core" for add_library().
macro(get_raw_target_name qualified_name out_var)
    string(REPLACE "::" "_" ${out_var} ${qualified_name})
    string(TOLOWER ${${out_var}} ${out_var})
endmacro()

# ---------------------------------------------------------------------------
# create_library — shared/static library with export header + optional tests
# ---------------------------------------------------------------------------
function(create_library)
    set(options)
    set(single_value_args LIB_NAME TEST_DISCOVER)
    set(list_args LIB_FILES PRIVATE_DEPENDENCIES PUBLIC_DEPENDENCIES
                  TEST_SOURCES TEST_DEPENDENCIES LIB_RSC)
    cmake_parse_arguments(PARSE_ARGV 0 parameter
        "${options}" "${single_value_args}" "${list_args}")

    foreach(arg IN LISTS parameter_UNPARSED_ARGUMENTS)
        message(WARNING "unparsed argument: ${arg}")
    endforeach()

    if(DEFINED CMAKE_ROOT_NAME AND NOT CMAKE_ROOT_NAME STREQUAL "")
        set(LIBRARY_NAME ${CMAKE_ROOT_NAME}::${parameter_LIB_NAME})
        get_raw_target_name(${LIBRARY_NAME} LIBRARY_NAME_RAW)
    else()
        set(LIBRARY_NAME ${parameter_LIB_NAME})
        set(LIBRARY_NAME_RAW ${LIBRARY_NAME})
    endif()

    add_library(${LIBRARY_NAME_RAW} ${parameter_LIB_FILES})
    add_library(${LIBRARY_NAME} ALIAS ${LIBRARY_NAME_RAW})

    include(GenerateExportHeader)
    string(TOUPPER ${CMAKE_ROOT_NAME} ROOT_FLAG)
    string(TOUPPER ${parameter_LIB_NAME} LIB_FLAG)

    set(_export_dir
        "${CMAKE_CURRENT_BINARY_DIR}/include/${CMAKE_ROOT_NAME}/${parameter_LIB_NAME}")
    file(MAKE_DIRECTORY "${_export_dir}")

    generate_export_header(${LIBRARY_NAME_RAW}
        EXPORT_FILE_NAME
            "${_export_dir}/${CMAKE_ROOT_NAME}_${parameter_LIB_NAME}_export.h"
        EXPORT_MACRO_NAME ${ROOT_FLAG}_${LIB_FLAG}_API
        BASE_NAME ${ROOT_FLAG}_${LIB_FLAG}
        DEFINE_NO_DEPRECATED
    )

    target_include_directories(${LIBRARY_NAME_RAW}
        PUBLIC
            $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
            $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
            $<INSTALL_INTERFACE:include>
    )

    target_link_libraries(${LIBRARY_NAME_RAW}
        PRIVATE ${parameter_PRIVATE_DEPENDENCIES}
        PUBLIC  ${parameter_PUBLIC_DEPENDENCIES}
    )

    unitpro_set_warnings(${LIBRARY_NAME_RAW})

    set_target_properties(${LIBRARY_NAME_RAW} PROPERTIES
        OUTPUT_NAME "${CMAKE_ROOT_NAME}${parameter_LIB_NAME}"
        EXPORT_NAME "${parameter_LIB_NAME}"
        VERSION ${PROJECT_VERSION}
        SOVERSION ${PROJECT_VERSION_MAJOR}
        CXX_VISIBILITY_PRESET hidden
        VISIBILITY_INLINES_HIDDEN ON
    )

    install(TARGETS ${LIBRARY_NAME_RAW}
        EXPORT ${CMAKE_ROOT_NAME}Targets
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )

    install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )
    install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/include/
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
    )

    if(BUILD_TESTING AND parameter_TEST_SOURCES)
        set(TEST_NAME "test_${LIBRARY_NAME_RAW}")
        set(GTEST_DEPENDENCIES GTest::gtest GTest::gmock GTest::gmock_main)

        build_gtest_executable(
            NAME ${TEST_NAME}
            SRC  ${parameter_TEST_SOURCES}
            DEPENDS
                ${parameter_TEST_DEPENDENCIES}
                ${GTEST_DEPENDENCIES}
                ${LIBRARY_NAME}
            DISCOVER ${parameter_TEST_DISCOVER}
        )
    endif()
endfunction()

# ---------------------------------------------------------------------------
# create_application — console or Qt executable
# ---------------------------------------------------------------------------
function(create_application)
    set(options)
    set(single_value_args NAME ENTRY UI)
    set(list_args HEADERS SOURCES RESOURCES BUILD_ARGS DEPENDENCIES)
    cmake_parse_arguments(PARSE_ARGV 0 app
        "${options}" "${single_value_args}" "${list_args}")

    foreach(arg IN LISTS app_UNPARSED_ARGUMENTS)
        message(WARNING "unparsed argument: ${arg}")
    endforeach()

    if(NOT DEFINED app_ENTRY OR app_ENTRY STREQUAL "")
        message(FATAL_ERROR "${app_NAME} is missing ENTRY [Console|QT_ui]")
    endif()

    set(PROJECT_FILES ${app_HEADERS} ${app_SOURCES} ${app_UI} ${app_RESOURCES})

    if(app_ENTRY STREQUAL "Console")
        add_executable(${app_NAME} ${app_BUILD_ARGS} ${PROJECT_FILES})
        if(DEFINED app_DEPENDENCIES AND NOT app_DEPENDENCIES STREQUAL "")
            target_link_libraries(${app_NAME} PRIVATE ${app_DEPENDENCIES})
        endif()
        unitpro_set_warnings(${app_NAME})

    elseif(BUILD_QT_UI AND app_ENTRY STREQUAL "QT_ui")
        qt_add_executable(${app_NAME} ${app_BUILD_ARGS} ${PROJECT_FILES})
        if(DEFINED app_DEPENDENCIES AND NOT app_DEPENDENCIES STREQUAL "")
            target_link_libraries(${app_NAME} PRIVATE ${app_DEPENDENCIES})
        endif()
        set_target_properties(${app_NAME} PROPERTIES
            WIN32_EXECUTABLE TRUE
            MACOSX_BUNDLE TRUE
        )
        unitpro_set_warnings(${app_NAME})
    endif()
endfunction()
