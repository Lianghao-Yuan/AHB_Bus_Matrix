//
//  Module: AHB decoder
//  (defined by ARM Design Kit Technical Reference Manual--AHB component)
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/13/2015
//  Description:
//  The system decoder decodes the address bus and generates select lines to
//  each of the system bus slaves, indicating that a read or write access to
//  that slave is required. The default configuration is 7 slots. No REMAP
//  signal implemented. 
//
//  Memory map:
//  0x00000000 - 0x0FFFFFFF is for slave 1
//  0x10000000 - 0x1FFFFFFF is for slave 2
//  0x20000000 - 0x2FFFFFFF is for slave 3
//  0x30000000 - 0x3FFFFFFF is for slave 4
//  0x40000000 - 0x4FFFFFFF is for slave 5
//  0x50000000 - 0x5FFFFFFF is for slave 6
//  The rest of address space is unused and is mapped to default slave which
//  is slave 0.
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
`ifndef AHB_DECODER_V
`define AHB_DECODER_V

`include "ahb_defines.v"

module ahb_decoder
(
  // -------------
  // Input pins //
  // -------------
  input [31:0] HADDR,
  // --------------
  // Output pins //
  // --------------
  output reg HSELx0,
  output reg HSELx1,
  output reg HSELx2,
  output reg HSELx3,
  output reg HSELx4,
  output reg HSELx5,
  output reg HSELx6
);
always @ (*) begin
  // Assigning initial value first to avoid inferred latches
  HSELx0 = 1'b0;
  HSELx1 = 1'b0;
  HSELx2 = 1'b0;
  HSELx3 = 1'b0;
  HSELx4 = 1'b0;
  HSELx5 = 1'b0;
  HSELx6 = 1'b0;
  // Asserting HSELx signal according to memory map
  case(HADDR[31:28]) 
    4'h1: HSELx1 = 1'b1;
    4'h2: HSELx2 = 1'b1;
    4'h3: HSELx3 = 1'b1;
    4'h4: HSELx4 = 1'b1;
    4'h5: HSELx5 = 1'b1;
    4'h6: HSELx6 = 1'b1;
    // Default slave
    default: HSELx0 = 1'b1;
  endcase

end

endmodule

`endif // AHB_DECODER_V
