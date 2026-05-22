// kernel.cpp
// Author - Sahil Gour

// The main kernel code is put here.

extern "C" void kernel_main() {
  volatile char *vga = (volatile char *)0xB8000;

  const char *msg = "Hello from kernel!";

  for (int i = 0; msg[i] != '\0'; i++) {
    vga[i * 2] = msg[i];
    vga[i * 2 + 1] = 0x0F;
  }

  while (true) {
    asm volatile("hlt");
  }
}
