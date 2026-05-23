CXX = g++
ASM = nasm
LD = ld

BUILD_DIR = build

CXXFLAGS = -ffreestanding -m32 -O0 \
-Wall -Wextra \
-fno-exceptions \
-fno-rtti \
-fno-pic \
-fno-pie \
-Ikernel/include

LDFLAGS = -m elf_i386 -nostdlib

all: iso

# Create build directories
dirs:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/iso/boot/grub

# Assemble boot code
$(BUILD_DIR)/boot.o: kernel/boot.asm | dirs
	$(ASM) -f elf32 kernel/boot.asm -o $(BUILD_DIR)/boot.o

# Compile kernel
$(BUILD_DIR)/kernel.o: kernel/kernel.cpp | dirs
	$(CXX) $(CXXFLAGS) -c kernel/kernel.cpp -o $(BUILD_DIR)/kernel.o

# Compile VGA driver
$(BUILD_DIR)/vga.o: kernel/drivers/vga.cpp | dirs
	$(CXX) $(CXXFLAGS) -c kernel/drivers/vga.cpp -o $(BUILD_DIR)/vga.o

# Link kernel ELF
$(BUILD_DIR)/kernel.elf: \
$(BUILD_DIR)/boot.o \
$(BUILD_DIR)/kernel.o \
$(BUILD_DIR)/vga.o

	$(LD) $(LDFLAGS) -n -T linker.ld \
	-o $(BUILD_DIR)/kernel.elf \
	$(BUILD_DIR)/boot.o \
	$(BUILD_DIR)/kernel.o \
	$(BUILD_DIR)/vga.o

# Create bootable ISO
iso: $(BUILD_DIR)/kernel.elf
	cp $(BUILD_DIR)/kernel.elf \
	$(BUILD_DIR)/iso/boot/kernel.elf

	cp boot/grub/grub.cfg \
	$(BUILD_DIR)/iso/boot/grub/grub.cfg

	grub-mkrescue -o $(BUILD_DIR)/sevrux.iso \
	$(BUILD_DIR)/iso

# Run kernel in QEMU
run: iso
	qemu-system-x86_64 -cdrom $(BUILD_DIR)/sevrux.iso

# Debug with serial output
debug: iso
	qemu-system-x86_64 \
	-cdrom $(BUILD_DIR)/sevrux.iso \
	-serial stdio

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all iso run clean debug dirs

# Cleans the then rebuilds and runs
fresh:
	make clean
	make
	make run
