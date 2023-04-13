#
# Author: Ice.Marek
# 2023 IceNET Technology
#
TARGET 		= armlink
GCC  		= arm-none-eabi-gcc
OBJDUMP		= arm-none-eabi-objdump
NASM 		= nasm 

AFLAGS 		= -f elf64

DEVICE     = STM32F103xB
OPT       ?= -Og
CFLAGS     = -fdata-sections -ffunction-sections -g3 -Wall -mcpu=cortex-m3 -mlittle-endian -mthumb -I inc/ -D $(DEVICE) $(OPT)

LDSCRIPT    := linker/stm32f103c8tx.ld -Wl,--gc-sections --specs=nano.specs --specs=nosys.specs

ASM_SOURCES = src/startup_stm32f103xb.s
GCC_SOURCES = $(shell find . -name "*.c")

INCLUDES=\
	-Iinc \
	-Irtos/include \
	-Irtos/portable/GCC/ARM_CM3 \

GCC_OBJECTS = $(GCC_SOURCES:.c=.o)

all: $(TARGET)

$(TARGET): $(GCC_OBJECTS)
	$(GCC) $(CFLAGS) $(ASM_SOURCES) -T $(LDSCRIPT) $^ -o $@ 

%.o: %.c
	$(GCC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

clean:
	rm -f $(TARGET) $(GCC_OBJECTS)

.PHONY: all clean
