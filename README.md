# Wrapper RTL

This repository contains a small memory-mapped hardware wrapper built from an OBI-to-Wishbone bridge, a Wishbone interconnect, SRAM/boot ROM blocks, and simple UART, GPIO, timer, SPI, and I2C peripherals.

## Source layout

- `rtl/wrapper_top.sv` is the integrated top-level wrapper.
- `rtl/bus/` contains the OBI-to-Wishbone bridge and Wishbone interconnect.
- `rtl/memory/` contains the boot ROM and SRAM controller.
- `rtl/peripherals/` contains UART, GPIO, timer, SPI, and I2C peripherals.
- `rtl/prim/` contains the lowRISC primitive subset used by the local RTL.
- `vendor/lowrisc/prim/` is kept as an upstream/vendor mirror. Do not compile it together with `rtl/prim`, because both trees define the same primitive module names.

## Build filelist

`filelist.f` uses repository-relative paths and include directories. Invoke your simulator from the repository root, for example:

```sh
<simulator> -f filelist.f
```

The current execution environment used for this cleanup did not include Verilator, Icarus Verilog, Yosys, Slang, Surelog, or svlint, so the included checks are static repository checks rather than HDL compilation.

## Top-level integration

`wrapper_top` exposes an OBI-style request interface and routes transactions through Wishbone to the implemented blocks. It includes small adapters for the boot ROM and for currently unsupported XIP/SPI-control address regions so valid accesses do not hang.

The boot ROM defaults to `boot.mem`, which contains a small RISC-V NOP sled placeholder. Replace it with a generated firmware image for a real system.

## Address map

| Region | Base | Size / Mask | Implementation |
| --- | ---: | ---: | --- |
| Boot ROM | `0x0010_0000` | 4 KiB | `boot_rom` |
| SRAM | `0x0010_2000` | 8 KiB | `sram_controller` + local memory in `wrapper_top` |
| XIP | `0x2000_0000` | high nibble decode | unsupported responder returns zero |
| UART | `0x4000_0000` | 256 B | `uart` |
| GPIO | `0x4000_0100` | 256 B | `gpio` |
| Timer | `0x4000_0200` | 256 B window from interconnect | `timer` |
| SPI control | `0x4000_0300` | 256 B | unsupported responder returns zero |
| I2C | `0x4000_0400` | 256 B | `i2c_wb_wrapper` |
| SPI host | `0x4000_0500` | 256 B | `spi_top` |

## Verification status

The repository includes lightweight static checks in `scripts/check_repo.py` that validate the filelist, boot image presence, top-level presence, and common duplicate-module hazards. A simulator smoke test is provided at `tb/wrapper_smoke_tb.sv`; run it with an HDL simulator together with `filelist.f` when a SystemVerilog toolchain is available.
