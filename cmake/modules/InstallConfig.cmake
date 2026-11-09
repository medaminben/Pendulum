# Install / export package configuration for consumers of Pendulum libraries.

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(PENDULUM_INSTALL_CMAKEDIR ${CMAKE_INSTALL_LIBDIR}/cmake/${CMAKE_ROOT_NAME})

write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_ROOT_NAME}ConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

configure_package_config_file(
    "${CMAKE_SOURCE_DIR}/cmake/PendulumConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_ROOT_NAME}Config.cmake"
    INSTALL_DESTINATION ${PENDULUM_INSTALL_CMAKEDIR}
)

install(
    FILES
        "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_ROOT_NAME}Config.cmake"
        "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_ROOT_NAME}ConfigVersion.cmake"
    DESTINATION ${PENDULUM_INSTALL_CMAKEDIR}
)

install(
    EXPORT ${CMAKE_ROOT_NAME}Targets
    NAMESPACE ${CMAKE_ROOT_NAME}::
    DESTINATION ${PENDULUM_INSTALL_CMAKEDIR}
)
