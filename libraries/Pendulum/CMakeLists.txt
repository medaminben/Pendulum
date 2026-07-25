project(Pendulum VERSION 1.0.0 LANGUAGES CXX)

set(TARGET_NAME Pendulum)
set(TST_DISCOVER ON)

find_package(Threads REQUIRED)

set(TARGET_HEADERS
    src/${TARGET_NAME}_impl.h
    include/${CMAKE_ROOT_NAME}/${TARGET_NAME}/Constants.h
    include/${CMAKE_ROOT_NAME}/${TARGET_NAME}/${TARGET_NAME}.h
)

set(TARGET_SOURCES
    src/${TARGET_NAME}.cpp
    src/${TARGET_NAME}_impl.cpp
)

set(TARGET_RSC
    test/data/${TARGET_NAME}TestData.txt
)

set(PRIVATE_DEPS Threads::Threads)
set(PUBLIC_DEPS)

set(TARGET_FILES
    ${TARGET_HEADERS}
    ${TARGET_SOURCES}
)

set(TST_SOURCES
    test/src/test_${TARGET_NAME}.cpp
)

set(TEST_DEPS)

create_library(
    LIB_NAME             ${TARGET_NAME}
    LIB_FILES            ${TARGET_FILES}
    PRIVATE_DEPENDENCIES ${PRIVATE_DEPS}
    PUBLIC_DEPENDENCIES  ${PUBLIC_DEPS}
    TEST_DISCOVER        ${TST_DISCOVER}
    TEST_SOURCES         ${TST_SOURCES}
    TEST_DEPENDENCIES    ${TEST_DEPS}
    LIB_RSC              ${TARGET_RSC}
)
