# sevrux
A Kernel built by Sevrus for fun.

## Current Progress and Updates
* Changed the architecture support to 32-bit.
* Added VGA Minimal Drivers, just enough to print with different colors.

## Project Structure
```bash
sevrux/
├── boot
│   └── grub
│       └── grub.cfg
├── docs
├── kernel
│   ├── boot.asm
│   ├── core
│   ├── drivers
│   │   └── vga.cpp
│   ├── include
│   │   ├── core
│   │   ├── drivers
│   │   │   └── vga.hpp
│   │   └── utils
│   ├── kernel.cpp
│   └── utils
├── LICENSE
├── linker.ld
├── Makefile
└── README.md
```

## Docs
* Docs will be found [Here](docs/index.md)
