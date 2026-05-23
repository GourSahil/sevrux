# Printing using VGA

# VGA Text Mode Driver Documentation

**File:** `kernel/drivers/vga.cpp`
**Header:** `kernel/drivers/vga.hpp`
**Author:** Sahil Gour

---

## Overview

This driver provides direct access to the x86 VGA text mode framebuffer. It writes characters and colors straight to physical memory at `0xB8000` — no OS, no stdlib, no safety net. Bare metal as it gets.

The driver manages a virtual cursor (`row`, `col`), handles newlines, and wraps text when it hits the screen edge.

---

## Memory Layout

VGA text mode maps the screen to physical address `0xB8000`. Each character on screen occupies **2 bytes**:

```
[ color byte ][ ascii byte ]
   ^^ upper      ^^ lower
```

The full buffer is accessed as an array of `unsigned short`:

```
buffer[row * WIDTH + col] = entry;
```

| Address | Purpose |
|---------|---------|
| `0xB8000` | Start of VGA text buffer |
| `0xB8000 + 2` | Second character (col 1, row 0) |
| `0xB8000 + (WIDTH * 2)` | Start of row 1 |

---

## Screen Dimensions

| Constant | Expected Value |
|----------|---------------|
| `WIDTH`  | 80 columns     |
| `HEIGHT` | 25 rows        |

> Defined in `vga.hpp`. Standard VGA text mode resolution.

---

## Color Encoding

### Color Byte Structure

```
Bits [7:4] = Background color
Bits [3:0] = Foreground color
```

Packed using:

```cpp
unsigned char makeColor(Color fg, Color bg) {
    return (unsigned char)(fg | (bg << 4));
}
```

### VGA Entry Structure

Each cell on screen is a 16-bit entry:

```
[ color (8 bits) ][ ASCII char (8 bits) ]
```

Packed using:

```cpp
unsigned short makeEntry(char c, unsigned char color) {
    return (unsigned short)(((unsigned short)color << 8) | (unsigned char)c);
}
```

### Default Color

White text on black background — `0x0F` (set in constructor).

---

## Public API

### Constructor — `VGA()`

Initializes the driver:

- Points `buffer` to `0xB8000`
- Sets `row = 0`, `col = 0`
- Sets default color to `0x0F` (white on black)

```cpp
VGA vga;
```

---

### `setColor(Color fg, Color bg)`

Changes the active foreground and background color for all subsequent output.

```cpp
vga.setColor(Color::GREEN, Color::BLACK);
```

---

### `clear()`

Fills the entire screen with blank entries using the current color. Resets cursor to `(0, 0)`.

```cpp
vga.clear();
```

---

### `putchar(char c)`

Writes a single character at the current cursor position and advances the cursor.

- Handles `\n` by calling `newline()`
- Auto-wraps to next line when `col >= WIDTH`

```cpp
vga.putchar('A');
```

---

### `print(const char* str)`

Prints a null-terminated string by calling `putchar()` for each character.

```cpp
vga.print("Hello, Kernel!");
```

---

## Internal Methods

| Method | Description |
|--------|-------------|
| `makeColor(fg, bg)` | Packs fg + bg into a single color byte |
| `makeEntry(c, color)` | Packs char + color into a 16-bit VGA entry |
| `newline()` | Moves cursor to next row, clears screen if at bottom |

---

## Known Limitations

> These are current gaps — not bugs, just unimplemented features.

- **No scrolling** — when the cursor reaches `HEIGHT`, the screen clears entirely instead of scrolling up. Text history is lost.
- **No hardware cursor sync** — the blinking cursor in hardware is not moved to match the software cursor position.
- **No color validation** — passing invalid `Color` values is undefined behavior.
- **x86 only** — hardcoded to `0xB8000`, which is x86-specific VGA memory mapping.

---

## Example Usage

```cpp
VGA vga;

vga.clear();
vga.setColor(Color::CYAN, Color::BLACK);
vga.print("Booting kernel...\n");
vga.setColor(Color::WHITE, Color::BLACK);
vga.print("VGA driver initialized.\n");
```

---

## Architecture Notes

- Buffer is declared `volatile` to prevent compiler from optimizing away writes to memory-mapped I/O
- No dynamic allocation — everything is stack/static
- Not thread-safe (single-core kernel assumption)

## For myself
> Handwritten notes are [Here](images/printing_using_vga.png)
