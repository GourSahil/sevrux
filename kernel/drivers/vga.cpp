// kernel/drivers/vga.cpp
// Author - Sahil Gour

#include <drivers/vga.hpp>

unsigned char VGA::makeColor(Color fg, Color bg) {
  return (unsigned char)(fg | (bg << 4));
}

unsigned short VGA::makeEntry(char c, unsigned char color) {
  return (unsigned short)(((unsigned short)color << 8) | (unsigned char)c);
}

VGA::VGA() {
  buffer = (volatile unsigned short *)0xB8000;

  row = 0;
  col = 0;

  // White text on black background
  color = 0x0F;
}

void VGA::setColor(Color fg, Color bg) { color = makeColor(fg, bg); }

void VGA::clear() {
  unsigned short blank = makeEntry(' ', color);

  for (unsigned short y = 0; y < HEIGHT; y++) {
    for (unsigned short x = 0; x < WIDTH; x++) {
      buffer[y * WIDTH + x] = blank;
    }
  }

  row = 0;
  col = 0;
}

void VGA::newline() {
  col = 0;
  row++;

  // temporary until scrolling exists
  if (row >= HEIGHT) {
    clear();
  }
}

void VGA::putchar(char c) {
  if (c == '\n') {
    newline();
    return;
  }

  buffer[row * WIDTH + col] = makeEntry(c, color);

  col++;

  if (col >= WIDTH) {
    newline();
  }
}

void VGA::print(const char *str) {
  for (unsigned long long i = 0; str[i] != '\0'; i++) {
    putchar(str[i]);
  }
}
