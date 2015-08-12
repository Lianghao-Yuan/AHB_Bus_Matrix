//
//  Module: AHB master-to-slave multiplexer
//  (defined by ARM Design Kit Technical Reference Manual--AHB component)
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/10/2015
//  Description:
//  The master-to-slave multiplexer connects the output of each AHB master to
//  all of the AHB slaves on the bus segment. It uses the values of HMASTER
//  and HMASTERD to select the appropriate bus master outputs, and also
//  generates the default master outputs when no other masters are selected.
//  The default configuration is three masters plus one dummy master. Here
//  default master is master 1.
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
`ifndef AHB_MUX_M2S_V
`define AHB_MUX_M2S_V

`include "ahb_defines.v"

module ahb_mux_m2s
(
  // -------------
  // Input pins //
  // -------------
  // Master 0
  // Address and control
  input [31:0] HADDRx0,
  input HWRITEx0,
  input [1:0] HTRANSx0,
  input [2:0] HSIZEx0,
  input [2:0] HBURSTx0,
  // Write data
  input [31:0] HWDATAx0,

  // Master 1 (default master)
  // Address and control
  input [31:0] HADDRx1,
  input HWRITEx1,
  input [1:0] HTRANSx1,
  input [2:0] HSIZEx1,
  input [2:0] HBURSTx1,
  // Write data
  input [31:0] HWDATAx1,
  // Master 2
  // Address and control
  input [31:0] HADDRx2,
  input HWRITEx2,
  input [1:0] HTRANSx2,
  input [2:0] HSIZEx2,
  input [2:0] HBURSTx2,
  // Write data
  input [31:0] HWDATAx2,

  // Master 3
  // Address and control
  input [31:0] HADDRx3,
  input HWRITEx3,
  input [1:0] HTRANSx3,
  input [2:0] HSIZEx3,
  input [2:0] HBURSTx3,
  // Write data
  input [31:0] HWDATAx3,

  // Select signals
  input [3:0] HMASTER,
  input [3:0] HMASTERD, 
  // --------------
  // Output pins //
  // --------------
  output reg [31:0] HADDR,
  output reg HWRITE,
  output reg [1:0] HTRANS,
  output reg [2:0] HSIZE,
  output reg [2:0] HBURST,
  output reg [31:0] HWDATA
);

// --------------------------
// Address and control mux //
// --------------------------
// Master 1 is default master.
always @ (*) begin
  case(HMASTER)
    4'h0: begin
      HADDR = HADDRx0;
      HWRITE = HWRITEx0;
      HTRANS = HTRANSx0;
      HSIZE = HSIZEx0;
      HBURST = HBURSTx0;
    end
    4'h2: begin
      HADDR = HADDRx2;
      HWRITE = HWRITEx2;
      HTRANS = HTRANSx2;
      HSIZE = HSIZEx2;
      HBURST = HBURSTx2;
    end
    4'h3: begin
      HADDR = HADDRx3;
      HWRITE = HWRITEx3;
      HTRANS = HTRANSx3;
      HSIZE = HSIZEx3;
      HBURST = HBURSTx3;
    end
    default: begin
      HADDR = HADDRx1;
      HWRITE = HWRITEx1;
      HTRANS = HTRANSx1;
      HSIZE = HSIZEx1;
      HBURST = HBURSTx1;
    end
  endcase
end

// -----------------
// Write data mux //
// -----------------
always @ (*) begin
  case(HMASTERD) 
    4'h0: HWDATA = HWDATAx0;
    4'h2: HWDATA = HWDATAx2;
    4'h3: HWDATA = HWDATAx3;
    default: HWDATA = HWDATAx1;
  endcase
end

endmodule

`endif // AHB_MUX_M2S_V
