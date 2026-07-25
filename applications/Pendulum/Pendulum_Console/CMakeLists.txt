project(Pendulum_Console VERSION 1.0.0 LANGUAGES CXX)

set(PROJECT_LIST)
set(EXECUTABLE_NAME ${PROJECT_NAME})
add_project(${EXECUTABLE_NAME} PROJECT_LIST)

set(BUILD_${EXECUTABLE_NAME} ${BUILD_APPS})
set(${EXECUTABLE_NAME}_ENTRY "Console")
set(${EXECUTABLE_NAME}_SOURCES Pendulum_Console.cpp)
set(${EXECUTABLE_NAME}_DEPS ${CMAKE_ROOT_NAME}::Pendulum)

foreach(item IN LISTS PROJECT_LIST)
    if(BUILD_${item})
        create_application(
            NAME         ${item}
            ENTRY        ${${item}_ENTRY}
            SOURCES      ${${item}_SOURCES}
            DEPENDENCIES ${${item}_DEPS}
        )
        if(TARGET ${item})
            install(TARGETS ${item}
                RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
                BUNDLE DESTINATION .
            )
        endif()
    endif()
endforeach()
