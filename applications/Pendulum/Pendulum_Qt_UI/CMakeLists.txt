# buildkit's create_application has no Qt entry, so the Qt viewer is a plain
# executable. AUTOMOC and AUTOUIC come from cmake/QtSupport.cmake.
add_executable(Pendulum_Qt_UI WIN32 MACOSX_BUNDLE
    Pendulum_Qt_UI.cpp
    Viewer.cpp
    Viewer.h
    Viewer.ui
    Imager.cpp
    Imager.h
    Trigger.h
)

target_link_libraries(Pendulum_Qt_UI PRIVATE
    Pendulum::Pendulum
    Qt${QT_VERSION_MAJOR}::Widgets
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Core
)

buildkit_set_warnings(Pendulum_Qt_UI)

install(TARGETS Pendulum_Qt_UI
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    BUNDLE  DESTINATION ${CMAKE_INSTALL_BINDIR}
)
