############################################
# LOWRISC PRIMITIVES (MUST BE FIRST)
############################################
/home/arf/shivanee/wrapper/vendor/lowrisc/prim/prim_count_pkg.sv
/home/arf/shivanee/wrapper/vendor/lowrisc/prim/prim_util_pkg.sv
/home/arf/shivanee/wrapper/vendor/lowrisc/prim/prim_fifo_sync_cnt.sv
/home/arf/shivanee/wrapper/vendor/lowrisc/prim/prim_fifo_sync.sv
/home/arf/shivanee/wrapper/vendor/lowrisc/prim/prim_assert.sv


############################################
# BUS LOGIC (OBI + WISHBONE)
############################################
/home/arf/shivanee/wrapper/rtl/bus/obi2wb.sv
/home/arf/shivanee/wrapper/rtl/bus/wb_interconnect.sv


############################################
# MEMORY SUBSYSTEM
############################################
/home/arf/shivanee/wrapper/rtl/memory/sram_controller.sv
/home/arf/shivanee/wrapper/rtl/memory/boot_rom.sv


############################################
# PERIPHERALS
############################################

# UART
/home/arf/shivanee/wrapper/rtl/peripherals/uart/uart.sv

# TIMER
/home/arf/shivanee/wrapper/rtl/peripherals/timer/timer.sv

# I2C
/home/arf/shivanee/wrapper/rtl/peripherals/i2c/i2c_wb_wrapper.v
/home/arf/shivanee/wrapper/rtl/peripherals/i2c/i2c_master_bit_ctrl.v
/home/arf/shivanee/wrapper/rtl/peripherals/i2c/i2c_master_byte_ctrl.v
/home/arf/shivanee/wrapper/rtl/peripherals/i2c/i2c_master_defines.v
/home/arf/shivanee/wrapper/rtl/peripherals/i2c/i2c_master_top.v

# SPI
/home/arf/shivanee/wrapper/rtl/peripherals/spi/spi_host.sv
/home/arf/shivanee/wrapper/rtl/peripherals/spi/spi_top.sv

# GPIO
/home/arf/shivanee/wrapper/rtl/peripherals/gpio/debounce.sv
/home/arf/shivanee/wrapper/rtl/peripherals/gpio/gpio.sv
