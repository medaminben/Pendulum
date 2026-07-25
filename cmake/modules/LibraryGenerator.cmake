# Scaffold generator: creates library + app trees from cmake/template when missing.

set(VAR_MARKER_START [[${]])
set(VAR_MARKER_END })

function(generate_libraries)
    set(options)
    set(single_value_args LIBRARIES_LOCATION APPS_LOCATION TEMPLATE_LOCATION)
    set(list_args LIBRARIES_LIST)
    cmake_parse_arguments(PARSE_ARGV 0 lib
        "${options}" "${single_value_args}" "${list_args}")

    foreach(arg IN LISTS lib_UNPARSED_ARGUMENTS)
        message(WARNING "unparsed argument: ${arg}")
    endforeach()

    if(NOT DEFINED lib_LIBRARIES_LOCATION OR lib_LIBRARIES_LOCATION STREQUAL "")
        message(STATUS "generate_libraries: missing LIBRARIES_LOCATION")
        return()
    endif()
    if(NOT DEFINED lib_TEMPLATE_LOCATION OR lib_TEMPLATE_LOCATION STREQUAL "")
        message(STATUS "generate_libraries: missing TEMPLATE_LOCATION")
        return()
    endif()

    foreach(item IN LISTS lib_LIBRARIES_LIST)
        if(IS_DIRECTORY ${lib_LIBRARIES_LOCATION}/${item})
            message(STATUS "scaffold: ${item} already present")
            continue()
        endif()

        message(STATUS "scaffold: generating ${item}")
        if(NOT DEFINED lib_APPS_LOCATION OR lib_APPS_LOCATION STREQUAL "")
            generate_library(
                NAME        ${item}
                DESTINATION ${lib_LIBRARIES_LOCATION}
                ROOT_NAME   ${CMAKE_ROOT_NAME}
                CFG_SRC     ${lib_TEMPLATE_LOCATION}
            )
        else()
            generate_library(
                NAME        ${item}
                DESTINATION ${lib_LIBRARIES_LOCATION}
                ROOT_NAME   ${CMAKE_ROOT_NAME}
                APPS_DIR    ${lib_APPS_LOCATION}
                CFG_SRC     ${lib_TEMPLATE_LOCATION}
            )
        endif()
    endforeach()
endfunction()

function(generate_library)
    set(options)
    set(list_args)
    set(single_value_args NAME DESTINATION ROOT_NAME APPS_DIR CFG_SRC)
    cmake_parse_arguments(PARSE_ARGV 0 lib
        "${options}" "${single_value_args}" "${list_args}")

    foreach(arg IN LISTS lib_UNPARSED_ARGUMENTS)
        message(WARNING "unparsed argument: ${arg}")
    endforeach()

    if(NOT DEFINED lib_NAME OR lib_NAME STREQUAL "")
        return()
    endif()

    set(lib_DIR ${lib_DESTINATION}/${lib_NAME})
    if(IS_DIRECTORY "${lib_DIR}")
        message(STATUS "scaffold: ${lib_NAME} already present")
        return()
    endif()

    if(NOT DEFINED lib_ROOT_NAME OR lib_ROOT_NAME STREQUAL "")
        set(lib_ROOT_NAME UnitPro)
        message(WARNING
            "${lib_NAME}: ROOT_NAME missing; defaulting to UnitPro")
    endif()

    set(lib_include_DIR ${lib_DIR}/include/${lib_ROOT_NAME}/${lib_NAME})
    set(lib_source_DIR  ${lib_DIR}/src)
    set(lib_test_DIR    ${lib_DIR}/test)
    set(lib_gen_DIR     ${lib_CFG_SRC}/lib)

    string(TOUPPER ${lib_ROOT_NAME} lib_ROOT_NAME_UPPER)
    string(TOUPPER ${lib_NAME}      lib_NAME_UPPER)

    configure_file(${lib_gen_DIR}/lib_CMakeLists.txt.in ${lib_DIR}/CMakeLists.txt)
    configure_file(${lib_gen_DIR}/lib.h.in              ${lib_include_DIR}/${lib_NAME}.h)
    configure_file(${lib_gen_DIR}/lib.cpp.in            ${lib_source_DIR}/${lib_NAME}.cpp)
    configure_file(${lib_gen_DIR}/lib_impl.h.in         ${lib_source_DIR}/${lib_NAME}_impl.h)
    configure_file(${lib_gen_DIR}/lib_impl.cpp.in       ${lib_source_DIR}/${lib_NAME}_impl.cpp)
    configure_file(${lib_gen_DIR}/test_lib.cpp.in       ${lib_test_DIR}/src/test_${lib_NAME}.cpp)
    file(WRITE ${lib_test_DIR}/data/${lib_NAME}TestData.txt "")

    if(NOT EXISTS ${lib_DESTINATION}/CMakeLists.txt)
        file(WRITE ${lib_DESTINATION}/CMakeLists.txt
            "# Auto-generated; do not hand-edit unless you know the consequences.\n")
    endif()
    file(APPEND ${lib_DESTINATION}/CMakeLists.txt "\nadd_subdirectory(${lib_NAME})\n")

    message(STATUS "scaffold: ${lib_NAME} library generated")

    if(NOT DEFINED lib_APPS_DIR OR lib_APPS_DIR STREQUAL "")
        return()
    endif()

    message(STATUS "scaffold: generating apps for ${lib_NAME}")

    if(NOT EXISTS ${lib_APPS_DIR}/${lib_NAME}/CMakeLists.txt)
        file(WRITE ${lib_APPS_DIR}/${lib_NAME}/CMakeLists.txt "")
    endif()
    file(APPEND ${lib_APPS_DIR}/${lib_NAME}/CMakeLists.txt
        "\nadd_subdirectory(${lib_NAME}_Console)\n")

    configure_file(${lib_CFG_SRC}/app/lib_console_CMakeLists.txt.in
        ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Console/CMakeLists.txt)
    configure_file(${lib_CFG_SRC}/app/lib_Console.cpp.in
        ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Console/${lib_NAME}_Console.cpp)

    if(Qt${QT_VERSION_MAJOR}_FOUND)
        file(APPEND ${lib_APPS_DIR}/${lib_NAME}/CMakeLists.txt
            "\nadd_subdirectory(${lib_NAME}_Qt_UI)\n")

        configure_file(${lib_CFG_SRC}/app/lib_qt_ui_CMakeLists.txt.in
            ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Qt_UI/CMakeLists.txt)
        configure_file(${lib_CFG_SRC}/app/lib_Qt_UI.cpp.in
            ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Qt_UI/${lib_NAME}_Qt_UI.cpp)
        configure_file(${lib_CFG_SRC}/app/lib_mainwindow.cpp.in
            ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Qt_UI/mainwindow.cpp)
        configure_file(${lib_CFG_SRC}/app/lib_mainwindow.h.in
            ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Qt_UI/mainwindow.h)
        configure_file(${lib_CFG_SRC}/app/lib_mainwindow.ui.in
            ${lib_APPS_DIR}/${lib_NAME}/${lib_NAME}_Qt_UI/mainwindow.ui)
    endif()

    if(NOT EXISTS ${lib_APPS_DIR}/CMakeLists.txt)
        file(WRITE ${lib_APPS_DIR}/CMakeLists.txt
            "# Auto-generated; do not hand-edit unless you know the consequences.\n")
    endif()
    file(APPEND ${lib_APPS_DIR}/CMakeLists.txt "\nadd_subdirectory(${lib_NAME})\n")
endfunction()
