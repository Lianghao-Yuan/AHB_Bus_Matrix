//
//  Module: AHB default slave
//  (defined by ARM Design Kit Technical Reference Manual--AHB component)
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/10/2015
//  Description:
//  The default slave responds to transfers that are made to undefined regions
//  of memory, where no AHB system slaves are mapped. A zero wait OKAY
//  response is made to IDLE or BUSY transfers, with an error response being
//  generated if a NONSEQ or SEQ transfer is performed. 
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
`ifndef AHB_DEFAULT_SLAVE_V
`define AHB_DEFAULT_SLAVE_V

`include "ahb_defines.v"

module ahb_default_slave
(
  // Split-capable bits
  input [3:0] HMASTER,
  input HMASTLOCK,
  output reg [15:0] HSPLIT,
  // -------------
  // Input pins //
  // -------------
  // Select bit
  input HSEL,
  // Address and control
  input [31:0] HADDR,
  input HWRITE,
  input [1:0] HTRANS,
  input [2:0] HSIZE,
  input [2:0] HBURST,
  // Write data
  input [31:0] HWDATA,
  // Reset
  input HRESETn,
  // Clock
  input HCLK,
  // --------------
  // Output pins //
  // --------------
  output reg HREADY,
  output reg [1:0] HRESP,
  output reg [31:0] HRDATA
);

// Simple behavior description of default slave
always @ (posedge HCLK or negedge HRESETn) begin
  if(!HRESETn) begin
    HSPLIT <= 16'b0;
    HREADY <= 1'b0;
    HRESP <= 2'b0;
    HRDATA <= 32'h0;
  end
  else begin
    if((HTRANS == `HTRANS_IDLE) || (HTRANS == `HTRANS_BUSY)) begin
      HSPLIT <= 16'b0;
      HREADY <= 1'b1;
      HRESP <= `HRESP_OKAY;
    end
    // Else meaning HTRANS is SEQ or NONSEQ, output ERROR
    else begin
      HSPLIT <= 16'b0;
      HREADY <= 1'b1;
      HRESP <= `HRESP_ERROR;
    end
  end
end
endmodule

`endif // AHB_DEFAULT_SLAVE_V
