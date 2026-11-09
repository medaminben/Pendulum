add_subdirectory(Pendulum_Console)

# QtSupport.cmake only warns when Qt is missing; skip the viewer then.
if(BUILD_QT_UI AND TARGET Qt${QT_VERSION_MAJOR}::Widgets)
    add_subdirectory(Pendulum_Qt_UI)
endif()
