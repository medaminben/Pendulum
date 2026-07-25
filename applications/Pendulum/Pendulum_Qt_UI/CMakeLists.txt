project(Pendulum_Qt_UI VERSION 1.0.0 LANGUAGES CXX)

set(PROJECT_LIST)
set(EXECUTABLE_NAME ${PROJECT_NAME})
add_project(${EXECUTABLE_NAME} PROJECT_LIST)

set(BUILD_${EXECUTABLE_NAME} ${BUILD_APPS})
set(${EXECUTABLE_NAME}_ENTRY "QT_ui")

set(${EXECUTABLE_NAME}_HEADERS
    Viewer.h
    Trigger.h
    Imager.h
)

set(${EXECUTABLE_NAME}_SOURCES
    Pendulum_Qt_UI.cpp
    Viewer.cpp
    Imager.cpp
)

set(${EXECUTABLE_NAME}_UI
    Viewer.ui
)

set(${EXECUTABLE_NAME}_DEPS
    ${CMAKE_ROOT_NAME}::Pendulum
    Qt${QT_VERSION_MAJOR}::Widgets
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Core
)

set(${EXECUTABLE_NAME}_BUILD_ARGS
    MANUAL_FINALIZATION
)

foreach(item IN LISTS PROJECT_LIST)
    if(BUILD_${item})
        create_application(
            NAME         ${item}
            ENTRY        ${${item}_ENTRY}
            HEADERS      ${${item}_HEADERS}
            SOURCES      ${${item}_SOURCES}
            UI           ${${item}_UI}
            BUILD_ARGS   ${${item}_BUILD_ARGS}
            DEPENDENCIES ${${item}_DEPS}
        )
        if(TARGET ${item})
            if(QT_VERSION_MAJOR EQUAL 6)
                qt_finalize_executable(${item})
            endif()
            install(TARGETS ${item}
                RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                BUNDLE DESTINATION .
            )
        endif()
    endif()
endforeach()
