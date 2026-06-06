############################################
# Wrapper RTL file list
# Paths are relative to the repository root.
############################################

+incdir+rtl/prim
+incdir+rtl/peripherals

############################################
# LOWRISC PRIMITIVES USED BY LOCAL RTL
############################################
rtl/prim/prim_assert.sv
rtl/prim/prim_util_pkg.sv
rtl/prim/prim_count_pkg.sv
rtl/prim/prim_flop.sv
rtl/prim/prim_count.sv
rtl/prim/prim_fifo_sync_cnt.sv
rtl/prim/prim_fifo_sync.sv

############################################
# BUS LOGIC (OBI + WISHBONE)
############################################
rtl/bus/obi2wb.sv
rtl/bus/wb_interconnect.sv

############################################
# MEMORY SUBSYSTEM
############################################
rtl/memory/boot_rom.sv
rtl/memory/sram_controller.sv

############################################
# PERIPHERALS
############################################
rtl/peripherals/debounce.sv
rtl/peripherals/gpio.sv
rtl/peripherals/timer.sv
rtl/peripherals/uart.sv
rtl/peripherals/spi_host.sv
rtl/peripherals/spi_top.sv
rtl/peripherals/timescale.v
rtl/peripherals/i2c_master_defines.v
rtl/peripherals/i2c_master_bit_ctrl.v
rtl/peripherals/i2c_master_byte_ctrl.v
rtl/peripherals/i2c_master_top.v
rtl/peripherals/i2c_wb_wrapper.v

############################################
# INTEGRATED TOP
############################################
rtl/wrapper_top.sv
