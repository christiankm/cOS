ASM=nasm
CC=gcc

SRC_DIR=.
TOOLS_DIR=tools
BUILD_DIR=build

.PHONY: all floppy_image kernel bootloader clean always tools_fat

all: floppy_image tools_fat

# Floppy image
floppy_image: $(BUILD_DIR)/floppy.img

$(BUILD_DIR)/floppy.img: bootloader kernel
	dd if=/dev/zero of=$(BUILD_DIR)/floppy.img bs=512 count=2880
	# if linux
	#mkfs.fat -F 12 -n "boot" $(BUILD_DIR)/floppy.img
	# if macOS
	newfs_msdos -F 12 -f 2880 $(BUILD_DIR)/floppy.img
	dd if=$(BUILD_DIR)/bootloader.bin of=$(BUILD_DIR)/floppy.img conv=notrunc
	mcopy -i $(BUILD_DIR)/floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"
	mcopy -i $(BUILD_DIR)/floppy.img test.txt "::test.txt"
	# older code, see git commits
	# i know it's bad to keep old code, but this is just for example
	#cp $(BUILD_DIR)/main.bin $(BUILD_DIR)/floppy.img
	#truncate -s 1440k $(BUILD_DIR)/floppy.img

# Bootloader
bootloader: $(BUILD_DIR)/bootloader.bin

$(BUILD_DIR)/bootloader.bin: always
	$(ASM) $(SRC_DIR)/bootloader/boot.asm -f bin -o $(BUILD_DIR)/bootloader.bin

# Kernel
kernel: $(BUILD_DIR)/kernel.bin

$(BUILD_DIR)/kernel.bin: always
	$(ASM) $(SRC_DIR)/kernel/main.asm -f bin -o $(BUILD_DIR)/kernel.bin

# Tools
tools_fat: $(BUILD_DIR)/tools/fat
$(BUILD_DIR)/tools/fat: always $(TOOLS_DIR)/fat/fat.c
	mkdir -p $(BUILD_DIR)/tools
	$(CC) -g -o $(BUILD_DIR)/tools/fat $(TOOLS_DIR)/fat/fat.c

# Always
always:
	mkdir -p $(BUILD_DIR)

# Clean
clean:
	rm -rf $(BUILD_DIR)
