// kernel.cpp
// Author - Sahil Gour

// The main kernel code is put here.

#include <drivers/vga.hpp>

extern "C" void kernel_main() {
  VGA vga;
  vga.setColor(VGA::LIGHT_GREEN, VGA::BLACK);

  vga.clear();

  vga.print("Sevrux Booted!\n");
  vga.setColor(VGA::LIGHT_CYAN, VGA::WHITE);
  vga.print("Finally it got printed");

  while (true) {
    asm volatile("hlt");
  }
}
