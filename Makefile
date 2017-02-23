######################################
# Makefile by CubeMX2Makefile.py
######################################

######################################
# target
######################################
TARGET = embUnitTest

######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -O0

#######################################
# pathes
#######################################
# Build path
BUILD_DIR = build

######################################
# source
######################################
C_SOURCES = \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio_ex.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_tim.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_tim_ex.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_uart.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pcd.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pcd_ex.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_usb.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_rcc_ex.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_gpio.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_dma.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_cortex.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_pwr.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash.c \
  Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_hal_flash_ex.c \

ASM_SOURCES = \
  startup/startup_stm32f103xb.s

C_SOURCES += \
  Src/AllTests.c \
  Src/assertTest.c \
  Src/_main.c \
  Src/main.c \
  Src/MockTestCase.c \
  Src/RepeatedTestTest.c \
  Src/stdImplTest.c \
  Src/stm32f1xx_hal_msp.c \
  Src/stm32f1xx_hal_timebase_TIM.c \
  Src/stm32f1xx_it.c \
  Src/system_stm32f1xx.c \
  Src/TestCallerTest.c \
  Src/TestCaseTest.c \
  Src/TestResultTest.c \
  
#######################################
# binaries
#######################################
CC = arm-none-eabi-gcc
AS = arm-none-eabi-gcc -x assembler-with-cpp
CP = arm-none-eabi-objcopy
AR = arm-none-eabi-ar
SZ = arm-none-eabi-size
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# macros for gcc
AS_DEFS =
C_DEFS = -D__weak="__attribute__((weak))" -D__packed="__attribute__((__packed__))" -DUSE_HAL_DRIVER -DSTM32F103xB
# includes for gcc
AS_INCLUDES =
C_INCLUDES = -IInc -I../local/include
C_INCLUDES += -IDrivers/STM32F1xx_HAL_Driver/Inc
C_INCLUDES += -IDrivers/STM32F1xx_HAL_Driver/Inc/Legacy
C_INCLUDES += -IDrivers/CMSIS/Device/ST/STM32F1xx/Include
C_INCLUDES += -IDrivers/CMSIS/Include
# compile gcc flags
ASFLAGS = -mthumb -mcpu=cortex-m3 $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections
CFLAGS = -mthumb -mcpu=cortex-m3 $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections
ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif
# Generate dependency information
CFLAGS += -std=c99 -MD -MP -MF $(BUILD_DIR)/.dep/$(@F).d

#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = STM32F103C8Tx_FLASH.ld
# libraries
LIBS = -lc -lm -lnosys -L../local/lib -lembUnit
LIBDIR =
LDFLAGS = -mthumb -mcpu=cortex-m3 -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir -p $@/.dep

#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)
  
#######################################
# dependencies
#######################################
-include $(shell mkdir -p $(BUILD_DIR)/.dep 2>/dev/null) $(wildcard $(BUILD_DIR)/.dep/*)

.PHONY: clean all

# *** EOF ***
