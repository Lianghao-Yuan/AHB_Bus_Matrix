//
//  Module: AHB slave-to-master multiplexer
//  (defined by ARM Design Kit Technical Reference Manual--AHB component)
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/13/2015
//  Description:
//  The slave-to-master multiplexor connects the read data and response
//  signals of the system bus slaves to the bus master. It uses the current
//  decoder HSELx outputs to select the bus slave outputs to use. The default
//  configuration is for 7 slaves (including default slave which is slave 0).
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
//
`ifndef AHB_MUX_S2M_V
`define AHB_MUX_S2M_V

`include "ahb_defines.v"

module ahb_mux_s2m
(
  // -------------
  // Input pins //
  // -------------
  // Clock and reset
  input HCLK,
  input HRESETn,
  // Slave datas
  input [31:0] HRDATAx0,
  input [31:0] HRDATAx1,
  input [31:0] HRDATAx2,
  input [31:0] HRDATAx3,
  input [31:0] HRDATAx4,
  input [31:0] HRDATAx5,
  input [31:0] HRDATAx6,
  // Control signals
  input HSELx0,
  input HSELx1,
  input HSELx2,
  input HSELx3,
  input HSELx4,
  input HSELx5,
  input HSELx6,
  // Slave responses
  input HREADYx0,
  input HREADYx1,
  input HREADYx2,
  input HREADYx3,
  input HREADYx4,
  input HREADYx5,
  input HREADYx6,

  input [1:0] HRESPx0,
  input [1:0] HRESPx1,
  input [1:0] HRESPx2,
  input [1:0] HRESPx3,
  input [1:0] HRESPx4,
  input [1:0] HRESPx5,
  input [1:0] HRESPx6,
  // --------------
  // Output pins //
  // --------------
  output reg HREADY,
  output reg [1:0] HRESP,
  output reg [31:0] HRDATA
);
// Slave select register
reg [3:0] slave_select;
// Slave select register update
always @ (posedge HCLK or negedge HRESETn) begin
  if(!HRESETn) begin
    slave_select <= 16'b0;
  end
  else begin
    // If HREADY is high, update slave_select
    if(HREADY) begin
      case({HSELx6, HSELx5, HSELx4, HSELx3, HSELx2, HSELx1, HSELx0})
        7'b10: slave_select <= 4'h1;
        7'b100: slave_select <= 4'h2;
        7'b1000: slave_select <= 4'h3;
        7'b10000: slave_select <= 4'h4;
        7'b100000: slave_select <= 4'h5;
        7'b1000000: slave_select <= 4'h6;
        // Default is for default slave
        default: slave_select <= 4'h0;
      endcase
    end
  end
end

// Read data multiplexor
always @ (*) begin
  case(slave_select)
    4'h1: HRDATA = HRDATAx1;
    4'h2: HRDATA = HRDATAx2;
    4'h3: HRDATA = HRDATAx3;
    4'h4: HRDATA = HRDATAx4;
    4'h5: HRDATA = HRDATAx5;
    4'h6: HRDATA = HRDATAx6;
    default: HRDATA = HRDATAx0;
  endcase
end

// Response multiplexor
always @ (*) begin
  case(slave_select)
    4'h1: begin
      HRESP = HRESPx1;
      HREADY = HREADYx1;
    end
    4'h2: begin
      HRESP = HRESPx2;
      HREADY = HREADYx2;
    end
    4'h3: begin
      HRESP = HRESPx3;
      HREADY = HREADYx3;
    end
    4'h4: begin
      HRESP = HRESPx4;
      HREADY = HREADYx4;
    end
    4'h5: begin
      HRESP = HRESPx5;
      HREADY = HREADYx5;
    end
    4'h6: begin
      HRESP = HRESPx6;
      HREADY = HREADYx6;
    end
    default: begin
      HRESP = HRESPx0;
      HREADY = HREADYx0;
    end
  endcase
end

endmodule

`endif // AHB_MUX_S2M_V
