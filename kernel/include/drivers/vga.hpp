// kernel/include/drivers/vga.hpp
// Author - Sahil Gour

#pragma once

class VGA {
public:
  enum Color : unsigned char {
    BLACK = 0,
    BLUE = 1,
    GREEN = 2,
    CYAN = 3,
    RED = 4,
    MAGENTA = 5,
    BROWN = 6,
    LIGHT_GREY = 7,
    DARK_GREY = 8,
    LIGHT_BLUE = 9,
    LIGHT_GREEN = 10,
    LIGHT_CYAN = 11,
    LIGHT_RED = 12,
    LIGHT_MAGENTA = 13,
    YELLOW = 14,
    WHITE = 15
  };

  VGA();

  void clear();

  void putchar(char c);

  void print(const char *str);

  void setColor(Color fg, Color bg);

private:
  static constexpr unsigned short WIDTH = 80;
  static constexpr unsigned short HEIGHT = 25;

  volatile unsigned short *buffer;

  unsigned short row;
  unsigned short col;

  unsigned char color;

  static unsigned char makeColor(Color fg, Color bg);

  static unsigned short makeEntry(char c, unsigned char color);

  void newline();
};
