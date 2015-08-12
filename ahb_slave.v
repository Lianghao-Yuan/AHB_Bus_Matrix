//
//  Module: AHB slave interface
//  (defined by ARM Design Kit Technical Reference Manual--AHB component)
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/13/2015
//  Description:
//  The slave interface receives external control signals to decide its
//  responses to transfers. We use those external control signal to control
//  slave behavior. This slave interface implementation suppports all responses
//  (OKAY, ERROR, SPLIT, RETRY).
//
//  Copyright (C) 2015 Lianghao Yuan

//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.

//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin St
`ifndef AHB_SLAVE_V
`define AHB_SLAVE_V

`include "ahb_defines.v"

module ahb_slave
(
  // --------------------------
  // Input pins: AHB signals //
  // --------------------------
  // Select
  input HSEL,
  // Address and control
  input [31:0] HADDR,
  input HWRITE,
  input [1:0] HTRANS,
  input [2:0] HSIZE,
  input [2:0] HBURST,
  // Data in
  input [31:0] HWDATA,
  // Reset and clock
  input HRESETn,
  input HCLK,
  // Split-capable signals
  input [3:0] HMASTER,
  // This signal has no use here since we process every transaction
  // immediately and thus slave behavior is same whether or not it's locked.
  input HMASTLOCK,
  // ---------------------------------
  // External input control signals //
  // ---------------------------------
  // Type of responses
  input [1:0] HRESP_i,
  // Number of wait cycles (we use 3 bits so max wait cycle is 7)
  input [2:0] wait_cycle_i,
  // deassert_split: deassert (claim ready for) all split
  input deassert_split;
  // --------------
  // Output pins //
  // --------------
  // Transfer responses
  output reg HREADY,
  output reg [1:0] HRESP,
  // Data out
  output reg [31:0] HRDATA,
  // Split-capable signal (4 masters supported)
  output [3:0] HSPLIT
  // --------------------------
  // External output signal //
  // --------------------------
  output HMASTLOCK_o;
);
// ---------------------
// Internal registers //
// ---------------------
// wait_cycle_counter: how many remaining wait cycles left including the
// current cycle.
reg [2:0] wait_cycle_counter;
// current_state
reg [2:0] current_state;
// next_state
reg [2:0] next_state;
// pending_split
reg [3:0] pending_split;
// ready_split
reg [3:0] ready_split;

// -------------------
// Local parameters //
// -------------------
// Transfer states [2:0]:
// OKAY, DELAYED, SPLIT1, SPLIT2, RETRY1, RETRY2, ERROR1, ERROR2
// Those signals who are XX1 and XX2 is because those are two cycle responses.
localparam OKAY    = 3'b000;
localparam DELAYED = 3'b001;
localparam SPLIT1  = 3'b010;
localparam SPLIT2  = 3'b011;
localparam RETRY1  = 3'b100;
localparam RETRY2  = 3'b101;
localparam ERROR1  = 3'b110;
localparam ERROR2  = 3'b111;

// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
// Module logics
// -----------------------------------------------------------------------
// -----------------------------------------------------------------------

// External output assignment
assign HMASTLOCK_o = HMASTLOCK;

// -----------------------
// Transfer state logic //
// -----------------------
// State update logic
always @ (posedge HCLK or negedge HRESETn) begin
  if(!HRESETn) begin
    current_state <= OKAY;
  end
  else begin
    current_state <= next_state;
  end
end // State update logic

// Next state generate logic
always @ (*) begin
  // If not selected, next state is OKAY
  if(!HSEL) begin
    next_state = OKAY;
  end
  // If OKAY or ERROR2 or SPLIT2 or RETRY2, meaning it's moving to next
  // transfer
  else if(current_state == OKAY || 
          current_state == ERROR2 || 
          current_state == SPLIT2 || 
          current_state == RETRY2) begin
    case(HRESP_i)
      `HRESP_OKAY: begin
        if(wait_cycle_i == 3'b0) begin
          next_state = OKAY;
        end
        else begin
          next_state = DELAYED;
        end
      end
      `HRESP_ERROR: next_state = ERROR1;
      `HRESP_SPLIT: next_state = SPLIT1;
      `HRESP_RETRY: next_state = RETRY1;
    endcase
  end // current_state == OKAY
  // If current_state is not OKAY
  else begin
    case(current_state) begin
      DELAYED: begin
        if(wait_cycle_counter == 3'b1 || wait_cycle_counter == 3'b0) begin
          next_state = OKAY;
        end
        else begin
          next_state = DELAYED;
        end
      end
      ERROR1: next_state = ERROR2;
      SPLIT1: next_state = SPLIT2;
      RETRY1: next_state = RETRY2;
    end
  end
end // Next state generate logic

// ------------------
// Counter related //
// ------------------
// Wait cycle counter
always @ (posedge HCLK or negedge HRESETn) begin
  if(!HRESETn) begin
    wait_cycle_counter <= 3'b0;
  end
  else begin
    // If next cycle is for new transfer
    if (current_state == OKAY ||
        current_state == ERROR2 ||
        current_state == SPLIT2 ||
        current_state == RETRY2) begin
      wait_cycle_counter <= wait_cycle_i;
    end
    // If current transfer is in DELAYED state and next cycle is not for new transfer
    else if(current_state == DELAYED) begin
      wait_cycle_counter <= wait_cycle_counter - 1;
    end
  end
end

// ----------------
// Split signals //
// ----------------
always @ (posedge HCLK or negedge HRESETn) begin
  if(!HRESETn) begin
    pending_split <= 4'b0;
    ready_split <= 4'b0;
  end
  else if(current_state == SPLIT1) begin
    case(HMASTER)
      4'h1: pending_split <= pending_split | 4'b0010;
      4'h2: pending_split <= pending_split | 4'b0100;
      4'h3: pending_split <= pending_split | 4'b1000;
      default: pending_split <= pending_split | 4'b0001;
    endcase
  end
  else begin
    // Deassert all split
    if(deassert_split) begin
      ready_split <= pending_split | ready_split;
      pending_split <= 4'b0;
    end
    // Check if current transfer is a resuming split transfer
    else begin
      if(HSEL) begin
        case(HMASTER)
          4'h1: begin
            if(ready_split[1]) begin
              ready_split <= ready_split & 4'b1101;
            end
          end
          4'h2: begin
            if(ready_split[2]) begin
              ready_split <= ready_split & 4'b1011;
            end
          end
          4'h3: begin
            if(ready_split[3]) begin
              ready_split <= ready_split & 4'b0111;
            end
          end
          default: begin
            if(ready_split[0]) begin
              ready_split <= ready_split & 4'b1110;
            end
          end
        endcase // case(HMASTER)
      end // if(HSEL)
    end
  end
end

assign HSPLIT = ready_split;

// --------------------
// Output generation //
// --------------------
// Normal output signals generation (not including split-related signals)
always @ (*) begin
  // We don't care about HRDATA
  HRDATA = 32'b0;
  case(current_state) 
    OKAY: begin
      HRESP = `HRESP_OKAY;
      HREADY = 1'b1;
    end
    DELAYED: begin
      HRESP = `HRESP_OKAY;
      HREADY = 1'b0;
    end
    SPLIT1: begin
      HRESP = `HRESP_SPLIT;
      HREADY = 1'b0;
    end
    SPLIT2: begin
      HRESP = `HRESP_SPLIT;
      HREADY = 1'b1;
    end
    RETRY1: begin
      HRESP = `HRESP_RETRY;
      HREADY = 1'b0;
    end
    RETRY2: begin
      HRESP = `HRESP_RETRY;
      HREADY = 1'b1;
    end
    ERROR1: begin
      HRESP = `HRESP_ERROR;
      HREADY = 1'b0;
    end
    ERROR2: begin
      HRESP = `HRESP_ERROR;
      HREADY = 1'b1;
    end
  endcase
end

endmodule

`endif // AHB_SLAVE_V
