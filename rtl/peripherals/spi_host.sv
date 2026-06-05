// Copyright lowRISC contributors.

// Licensed under the Apache License, Version 2.0

// SPDX-License-Identifier: Apache-2.0
 
module spi_host #(

  parameter int unsigned ClockFrequency = 50_000_000,

  parameter int unsigned BaudRate       = 12_500_000,

  parameter bit CPOL                    = 0,

  parameter bit CPHA                    = 0

)(
 
    input  logic clk_i,

    input  logic rst_ni,
 
    input  logic spi_rx_i,

    output logic spi_tx_o,

    output logic sck_o,
 
    input  logic       start_i,

    input  logic [7:0] byte_data_i,
 
    output logic [7:0] byte_data_o,

    output logic       next_tx_byte_o
 
);
 
  // ============================================================

  // CLOCK GENERATION

  // ============================================================
 
  localparam int unsigned ClocksPerBaud =

                              ClockFrequency / BaudRate;
 
  localparam int unsigned ToggleCount =

                              ClocksPerBaud / 2;
 
  localparam int unsigned CountWidth =

                              $clog2(ToggleCount);
 
  logic [CountWidth-1:0] count;

  logic [CountWidth-1:0] limit;
 
  logic sck;
 
  logic count_at_limit;
 
  logic sck_pos;

  logic sck_neg;
 
  assign limit = CountWidth'(ToggleCount - 1);
 
  assign count_at_limit = (count >= limit);
 
  // ============================================================

  // SPI FSM

  // ============================================================
 
  typedef enum logic [1:0] {
 
    IDLE,

    START,

    SEND,

    STOP
 
  } spi_state_t;
 
  spi_state_t state_q;
 
  // ============================================================

  // INTERNAL REGISTERS

  // ============================================================
 
  logic [2:0] bit_counter_q;
 
  logic [7:0] current_byte_q;

  logic [7:0] recieved_byte_q;
 
  // ============================================================

  // SCK ENABLE

  // ============================================================
 
  logic sck_en;
 
  assign sck_en = (state_q == SEND);
 
  // ============================================================

  // SCK GENERATION

  // ============================================================
 
  always_ff @(posedge clk_i or negedge rst_ni) begin
 
    if (!rst_ni) begin
 
      count <= '0;

      sck   <= CPOL;
 
    end
 
    else if (!(sck_en || start_i)) begin
 
      count <= '0;

      sck   <= CPOL;
 
    end
 
    else if (count_at_limit) begin
 
      count <= '0;

      sck   <= ~sck;
 
    end
 
    else begin
 
      count <= count + 1'b1;
 
    end
 
  end
 
  // ============================================================

  // SCK OUTPUT

  // ============================================================
 
  assign sck_o = sck_en ? sck : CPOL;
 
  // ============================================================

  // SCK EDGE DETECTION

  // ============================================================
 
  assign sck_pos = count_at_limit && !sck;
 
  assign sck_neg = count_at_limit &&  sck;
 
  // ============================================================

  // MOSI OUTPUT

  // ============================================================
 
  assign spi_tx_o =

          (state_q == SEND) ?

           current_byte_q[7] :

           1'b1;
 
  // ============================================================

  // BYTE DONE

  // ============================================================
 
  assign next_tx_byte_o =

          (state_q == STOP);
 
  // ============================================================

  // RX BYTE OUTPUT

  // ============================================================
 
  assign byte_data_o = recieved_byte_q;
 
  // ============================================================

  // SPI MODE-0

  // CPOL = 0

  // CPHA = 0

  //

  // SAMPLE on rising edge

  // SHIFT  on falling edge

  // ============================================================
 
  generate
 
    if (CPHA == 0) begin : gen_mode0
 
      always_ff @(posedge clk_i or negedge rst_ni) begin
 
        if (!rst_ni) begin
 
          state_q         <= IDLE;

          current_byte_q  <= '0;

          recieved_byte_q <= '0;

          bit_counter_q   <= '0;
 
        end
 
        // ------------------------------------------------------

        // SAMPLE MISO ON RISING EDGE

        // ------------------------------------------------------
 
        else if (sck_pos) begin
 
          if (state_q == SEND) begin
 
            recieved_byte_q <=

            {recieved_byte_q[6:0], spi_rx_i};
 
          end
 
        end
 
        // ------------------------------------------------------

        // SHIFT MOSI ON FALLING EDGE

        // ------------------------------------------------------
 
        else if (sck_neg) begin
 
          case (state_q)
 
            // --------------------------------------------------

            // IDLE

            // --------------------------------------------------
 
            IDLE: begin
 
              if (start_i)
 
                state_q <= START;
 
            end
 
            // --------------------------------------------------

            // LOAD BYTE

            // --------------------------------------------------
 
            START: begin
 
              current_byte_q <= byte_data_i;
 
              bit_counter_q  <= 3'd7;
 
              state_q        <= SEND;
 
            end
 
            // --------------------------------------------------

            // SEND BITS

            // --------------------------------------------------
 
            SEND: begin
 
              current_byte_q <=

              {current_byte_q[6:0], 1'b0};
 
              if (bit_counter_q == 3'd0)
 
                state_q <= STOP;
 
              else
 
                bit_counter_q <=

                bit_counter_q - 1'b1;
 
            end
 
            // --------------------------------------------------

            // STOP

            // --------------------------------------------------
 
            STOP: begin
 
              state_q <= IDLE;
 
            end
 
          endcase
 
        end
 
      end
 
    end
 
    // ==========================================================

    // CPHA = 1

    // SAMPLE on falling edge

    // SHIFT  on rising edge

    // ==========================================================
 
    else begin : gen_mode1
 
      always_ff @(posedge clk_i or negedge rst_ni) begin
 
        if (!rst_ni) begin
 
          state_q         <= IDLE;

          current_byte_q  <= '0;

          recieved_byte_q <= '0;

          bit_counter_q   <= '0;
 
        end
 
        // ------------------------------------------------------

        // SHIFT MOSI ON RISING EDGE

        // ------------------------------------------------------
 
        else if (sck_pos) begin
 
          case (state_q)
 
            IDLE: begin
 
              if (start_i)
 
                state_q <= START;
 
            end
 
            START: begin
 
              current_byte_q <= byte_data_i;
 
              bit_counter_q  <= 3'd7;
 
              state_q        <= SEND;
 
            end
 
            SEND: begin
 
              current_byte_q <=

              {current_byte_q[6:0], 1'b0};
 
              if (bit_counter_q == 3'd0)
 
                state_q <= STOP;
 
              else
 
                bit_counter_q <=

                bit_counter_q - 1'b1;
 
            end
 
            STOP: begin
 
              state_q <= IDLE;
 
            end
 
          endcase
 
        end
 
        // ------------------------------------------------------

        // SAMPLE MISO ON FALLING EDGE

        // ------------------------------------------------------
 
        else if (sck_neg) begin
 
          if (state_q == SEND) begin
 
            recieved_byte_q <=

            {recieved_byte_q[6:0], spi_rx_i};
 
          end
 
        end
 
      end
 
    end
 
  endgenerate
 
endmodule
 
