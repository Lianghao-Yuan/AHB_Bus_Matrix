//
//  Module: AHB bus matrix
//  (defined by ARM Design Kit Technical Reference Manual--AHB component)
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/13/2015
//  Description:
//  The Bus Matrix is a component that enables multiple AHB masters to be
//  connected to multiple AHB slaves.
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
`ifndef AHB_BUS_MATRIX_V
`define AHB_BUS_MATRIX_V

`include "ahb_defines.v"

module ahb_bus_matrix
(
  // X signals from masters
  // We support 3 master and 1 dummy master
  input HBUSREQx0;
  input HBUSREQx1;
  input HBUSREQx2;
  input HBUSREQx3;

  input HLOCKx0;
  input HLOCKx1;
  input HLOCKx2;
  input HLOCKx3;

  input [1:0] HTRANSx0;
  input [1:0] HTRANSx1;
  input [1:0] HTRANSx2;
  input [1:0] HTRANSx3;

  input [31:0] HADDRx0;
  input [31:0] HADDRx1;
  input [31:0] HADDRx2;
  input [31:0] HADDRx3;

  input HWRITEx0;
  input HWRITEx1;
  input HWRITEx2;
  input HWRITEx3;

  input [2:0] HSIZEx0;
  input [2:0] HSIZEx1;
  input [2:0] HSIZEx2;
  input [2:0] HSIZEx3;

  input [3:0] HBURSTx0;
  input [3:0] HBURSTx1;
  input [3:0] HBURSTx2;
  input [3:0] HBURSTx3;

  input [31:0] HWDATAx0;
  input [31:0] HWDATAx1;
  input [31:0] HWDATAx2;
  input [31:0] HWDATAx3;

  // X signals from slaves
  // We support 6 slaves and 1 default slave
  input HREADYx0;
  input HREADYx1;
  input HREADYx2;
  input HREADYx3;
  input HREADYx4;
  input HREADYx5;
  input HREADYx6;

  input [1:0] HRESPx0;
  input [1:0] HRESPx1;
  input [1:0] HRESPx2;
  input [1:0] HRESPx3;
  input [1:0] HRESPx4;
  input [1:0] HRESPx5;
  input [1:0] HRESPx6;

  input [31:0] HRDATAx0;
  input [31:0] HRDATAx1;
  input [31:0] HRDATAx2;
  input [31:0] HRDATAx3;
  input [31:0] HRDATAx4;
  input [31:0] HRDATAx5;
  input [31:0] HRDATAx6; 

  input [3:0] HSPLITx0;
  input [3:0] HSPLITx1;
  input [3:0] HSPLITx2;
  input [3:0] HSPLITx3;
  input [3:0] HSPLITx4;
  input [3:0] HSPLITx5;
  input [3:0] HSPLITx6;

  // X signals from arbiter
  output HGRANTx0;
  output HGRANTx1;
  output HGRANTx2;
  output HGRANTx3;

  // X signals from decoder
  output HSELx0;
  output HSELx1;
  output HSElx2;
  output HSELx3;
  output HSELx4;
  output HSELx5;
  output HSELx6;

  // AMBA AHB main signals
  // Reset
  input HRESETn;
  // Clock
  input HCLK;
  // Master-to-slave
  output [1:0] HTRANS;
  output [31:0] HADDR;
  output HWRITE;
  output [2:0] HSIZE;
  output [3:0] HBURST;
  output [31:0] HWDATA;
  // Slave-to-master
  output HREADY;
  output [1:0] HRESP;
  output [31:0] HRDATA;

  // Signals for mux
  // MASTER: which signal owns the current address phase
  output [3:0] HMASTER;
  output HMASTLOCK;
);

wire [3:0] HMASTERD;
wire [3:0] HSPLIT;

// Arbiter
ahb_arbiter3 arbiter3
(
  .HBUSREQx0,
  .HLOCKx0,
  .HGRANTx0,
  .HBUSREQx1,
  .HLOCKx1,
  .HGRANTx1,
  .HBUSREQx2,
  .HLOCKx2,
  .HGRANTx2,
  .HBUSREQx3,
  .HLOCKx3,
  .HGRANTx3,

  .HADDR,
  .HSPLIT,
  .HTRANS,
  .HBURST,
  .HRESP,
  .HREADY,

  .HRESETn,
  .HCLK,
  
  .HMASTER,
  .HMASTERD,
  .HMASTLOCK
);

// Decoder
ahb_decoder decoder
(
  .HADDR,
  .HSELx0,
  .HSELx1,
  .HSELx2,
  .HSELx3,
  .HSELx4,
  .HSELx5,
  .HSELx6
);

// Master-to-slave mux
ahb_mux_m2s m2s_mux
(
  .HADDRx0,
  .HWRITEx0,
  .HTRANSx0,
  .HSIZEx0,
  .HBURSTx0,
  .HWDATAx0,

  .HADDRx1,
  .HWRITEx1,
  .HTRANSx1,
  .HSIZEx1,
  .HBURSTx1,
  .HWDATAx1,
  
  .HADDRx2,
  .HWRITEx2,
  .HTRANSx2,
  .HSIZEx2,
  .HBURSTx2,
  .HWDATAx2,

  .HADDRx3,
  .HWRITEx3,
  .HTRANSx3,
  .HSIZEx3,
  .HBURSTx3,
  .HWDATAx3,

  .HMASTER,
  .HMASTERD,
  .HADDR,
  .HWRITE,
  .HTRANS,
  .HSIZE,
  .HBURST,
  .HWDATA
);

// Slave-to-master mux
ahb_mux_s2m s2m_mux
(
  .HCLK,
  .HRESETn,
  .HRDATAx0,
  .HRDATAx1,
  .HRDATAx2,
  .HRDATAx3,
  .HRDATAx4,
  .HRDATAx5,
  .HRDATAx6,
  
  .HSELx0,
  .HSELx1,
  .HSELx2,
  .HSELx3,
  .HSELx4,
  .HSELx5,
  .HSELx6,

  .HREADYx0,
  .HREADYx1,
  .HREADYx2,
  .HREADYx3,
  .HREADYx4,
  .HREADYx5,
  .HREADYx6,

  .HRESPx0,
  .HRESPx1,
  .HRESPx2,
  .HRESPx3,
  .HRESPx4,
  .HRESPx5,
  .HRESPx6,

  .HREADY,
  .HRESP,
  .HRDATA
);

// SPLIT signal AND gate
assign HSPLIT = (HSPLITx0 |
                 HSPLITx1 |
                 HSPLITx2 |
                 HSPLITx3 |
                 HSPLITx4 |
                 HSPLITx5 |
                 HSPLITx6);

endmodule

`endif // AHB_BUS_MATRIX_V
