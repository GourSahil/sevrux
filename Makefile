CXX = g++
ASM = nasm

BUILD_DIR = build

CXXFLAGS = -ffreestanding -m64 -O2 -Wall -Wextra
LDFLAGS = -nostdlib

all: iso

# Assemble boot code
$(BUILD_DIR)/boot.o:
	$(ASM) -f elf64 kernel/boot.asm -o $(BUILD_DIR)/boot.o

# Compile kernel
$(BUILD_DIR)/kernel.o:
	$(CXX) $(CXXFLAGS) -c kernel/kernel.cpp -o $(BUILD_DIR)/kernel.o

# Link kernel ELF
$(BUILD_DIR)/kernel.elf: $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o
	ld -n -o $(BUILD_DIR)/kernel.elf -T linker.ld \
	$(BUILD_DIR)/boot.o \
	$(BUILD_DIR)/kernel.o

# Create bootable ISO
iso: $(BUILD_DIR)/kernel.elf
	mkdir -p $(BUILD_DIR)/iso/boot/grub

	cp $(BUILD_DIR)/kernel.elf \
	$(BUILD_DIR)/iso/boot/kernel.elf

	cp boot/grub/grub.cfg \
	$(BUILD_DIR)/iso/boot/grub/grub.cfg

	grub-mkrescue -o $(BUILD_DIR)/sevrux.iso \
	$(BUILD_DIR)/iso

# Run in QEMU
run: iso
	qemu-system-x86_64 -cdrom $(BUILD_DIR)/sevrux.iso

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)
