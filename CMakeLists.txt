set(STM32_CHIP "stm32f103c8")
set(CMAKE_TOOLCHAIN_FILE "$ENV{HOME}/Projects/0embedded/stm32-cmake/cmake/gcc_stm32.cmake")
set(CMAKE_MODULE_PATH "$ENV{HOME}/Projects/0embedded/stm32-cmake/cmake")
set(TOOLCHAIN_PREFIX "$ENV{HOME}/.arduino15/packages/arduino/tools/arm-none-eabi-gcc/4.8.3-2014q1")
set(STM32Cube_DIR "$ENV{HOME}/.stm32cubemx/STM32Cube/Repository/STM32Cube_FW_F1_V1.4.0")
set(CMAKE_BUILD_TYPE "Debug")

PROJECT(xUnitTest)

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
ENABLE_LANGUAGE(ASM)

FIND_PACKAGE(CMSIS REQUIRED)
FIND_PACKAGE(STM32HAL COMPONENTS gpio pcd tim uart usb REQUIRED)

INCLUDE_DIRECTORIES(
	${CMAKE_CURRENT_SOURCE_DIR}/Inc
	${CMAKE_CURRENT_SOURCE_DIR}/../local/include
	${CMSIS_INCLUDE_DIRS}
	${STM32HAL_INCLUDE_DIR}
)
LINK_DIRECTORIES(
	${CMAKE_CURRENT_SOURCE_DIR}/../local/lib
)

SET(PROJECT_SOURCES
	Src/_main.c
	Src/main.c
	Src/stm32f1xx_hal_msp.c
	Src/stm32f1xx_hal_timebase_TIM.c
	Src/stm32f1xx_it.c
	Src/AllTests.c
	Src/assertTest.c
	Src/MockTestCase.c
	Src/MockTestCase.h
	Src/RepeatedTestTest.c
	Src/stdImplTest.c
	Src/TestCallerTest.c
	Src/TestCaseTest.c
	Src/TestResultTest.c
)

set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${CMAKE_PROJECT_NAME}.map -specs=nano.specs")

ADD_EXECUTABLE(${CMAKE_PROJECT_NAME}.elf ${PROJECT_SOURCES} ${CMSIS_SOURCES} ${STM32HAL_SOURCES})
target_link_libraries(${CMAKE_PROJECT_NAME}.elf embUnit)
add_custom_command(TARGET ${CMAKE_PROJECT_NAME}.elf
	POST_BUILD
	COMMAND ${CMAKE_SIZE} ${CMAKE_PROJECT_NAME}.elf)

STM32_SET_TARGET_PROPERTIES(${CMAKE_PROJECT_NAME}.elf)
STM32_ADD_HEX_BIN_TARGETS(${CMAKE_PROJECT_NAME}.elf)

