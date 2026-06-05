`timescale 1ns/1ps

module wrapper_smoke_tb;
  logic clk;
  logic rst_n;

  logic        obi_req;
  logic        obi_gnt;
  logic [31:0] obi_addr;
  logic        obi_we;
  logic [3:0]  obi_be;
  logic [31:0] obi_wdata;
  logic        obi_rvalid;
  logic [31:0] obi_rdata;

  logic uart_tx;
  logic uart_irq;
  logic [7:0] gp_i;
  logic [15:0] gp_o;
  logic timer_intr;
  logic spi_tx;
  logic spi_sck;
  logic [7:0] spi_byte_data;
  logic i2c_scl_o;
  logic i2c_scl_oe;
  logic i2c_sda_o;
  logic i2c_sda_oe;
  logic i2c_irq;

  wrapper_top dut (
    .clk_i(clk),
    .rst_ni(rst_n),
    .obi_req_i(obi_req),
    .obi_gnt_o(obi_gnt),
    .obi_addr_i(obi_addr),
    .obi_we_i(obi_we),
    .obi_be_i(obi_be),
    .obi_wdata_i(obi_wdata),
    .obi_rvalid_o(obi_rvalid),
    .obi_rdata_o(obi_rdata),
    .uart_rx_i(1'b1),
    .uart_tx_o(uart_tx),
    .uart_irq_o(uart_irq),
    .gp_i(gp_i),
    .gp_o(gp_o),
    .timer_intr_o(timer_intr),
    .spi_rx_i(1'b1),
    .spi_tx_o(spi_tx),
    .spi_sck_o(spi_sck),
    .spi_byte_data_o(spi_byte_data),
    .i2c_scl_i(1'b1),
    .i2c_scl_o(i2c_scl_o),
    .i2c_scl_oe_o(i2c_scl_oe),
    .i2c_sda_i(1'b1),
    .i2c_sda_o(i2c_sda_o),
    .i2c_sda_oe_o(i2c_sda_oe),
    .i2c_irq_o(i2c_irq)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  task automatic obi_access(
    input  logic        we,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    output logic [31:0] rdata
  );
    begin
      @(posedge clk);
      obi_req   <= 1'b1;
      obi_we    <= we;
      obi_addr  <= addr;
      obi_be    <= 4'hf;
      obi_wdata <= wdata;

      do begin
        @(posedge clk);
      end while (!obi_gnt);

      obi_req <= 1'b0;
      obi_we  <= 1'b0;

      do begin
        @(posedge clk);
      end while (!obi_rvalid);

      rdata = obi_rdata;
    end
  endtask

  task automatic expect_eq(input logic [31:0] actual, input logic [31:0] expected, input string what);
    begin
      if (actual !== expected) begin
        $fatal(1, "%s: expected 0x%08x, got 0x%08x", what, expected, actual);
      end
    end
  endtask

  initial begin
    logic [31:0] rdata;

    rst_n     = 1'b0;
    obi_req   = 1'b0;
    obi_addr  = '0;
    obi_we    = 1'b0;
    obi_be    = '0;
    obi_wdata = '0;
    gp_i      = 8'ha5;

    repeat (5) @(posedge clk);
    rst_n = 1'b1;
    repeat (2) @(posedge clk);

    obi_access(1'b1, 32'h0010_2000, 32'hcafe_beef, rdata);
    obi_access(1'b0, 32'h0010_2000, 32'h0000_0000, rdata);
    expect_eq(rdata, 32'hcafe_beef, "SRAM readback");

    obi_access(1'b1, 32'h4000_0100, 32'h0000_55aa, rdata);
    obi_access(1'b0, 32'h4000_0100, 32'h0000_0000, rdata);
    expect_eq(rdata, 32'h0000_55aa, "GPIO output readback");

    obi_access(1'b0, 32'h2000_0000, 32'h0000_0000, rdata);
    expect_eq(rdata, 32'h0000_0000, "Reserved XIP responder");

    $display("wrapper_smoke_tb passed");
    $finish;
  end
endmodule
