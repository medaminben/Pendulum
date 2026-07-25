find_package(QT NAMES Qt6 Qt5 COMPONENTS Widgets Gui Core QUIET)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Widgets Gui Core QUIET)

if(NOT Qt${QT_VERSION_MAJOR}_FOUND)
    message(WARNING "BUILD_QT_UI is ON but Qt was not found; Qt apps will be skipped")
    return()
endif()

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

message(STATUS "Qt ${QT_VERSION_MAJOR} support enabled")
