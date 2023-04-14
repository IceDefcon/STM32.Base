#
# Author: Ice.Marek
# 2023 IceNET Technology
#
TARGET 		= ice
GCC  		= arm-none-eabi-gcc
OBJCOPY    	= arm-none-eabi-objcopy
OBJDUMP		= arm-none-eabi-objdump

CFLAGS 		= -mcpu=cortex-m3 --specs=nosys.specs -Wl,-Map="ice.map" \
-Wl,--gc-sections -static --specs=nano.specs -mfloat-abi=soft -mthumb \
-Wl,--start-group -lc -lm -Wl,--end-group -D STM32F103xB

LDSCRIPT    = Linker/STM32F103C8TX_FLASH.ld

ASM_SOURCES = $(shell find . -name "*.s")
GCC_SOURCES = $(shell find . -name "*.c")

INCLUDES=\
	-ICore/Inc\
	-IDrivers/CMSIS/Include\
	-IDrivers/STM32F1xx_HAL_Driver/Inc\
	-IDrivers/STM32F1xx_HAL_Driver/Inc/Legacy\

GCC_OBJECTS = $(GCC_SOURCES:.c=.o)

all: elf hex bin size

elf: $(TARGET)

$(TARGET): $(GCC_OBJECTS)
	$(GCC) $(CFLAGS) -T $(LDSCRIPT) $(ASM_SOURCES) $^ -o $@ 

%.o: %.c
	$(GCC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

hex: $(TARGET)
	$(OBJCOPY) $(TARGET) -O ihex $(TARGET).hex

bin: $(TARGET)
	$(OBJCOPY) $(TARGET) -O binary $(TARGET).bin

size:
	arm-none-eabi-size $(TARGET)

clean:
	rm -f $(GCC_OBJECTS) $(TARGET) $(TARGET).hex $(TARGET).bin $(TARGET).map

.PHONY: all elf hex bin size clean
