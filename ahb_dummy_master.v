//
//  Module: AHB dummy master
//  (defined by ARM Design Kit Technical Reference Manual--AHB component)
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/05/2015
//  Description:
//  The dummy master is always reserved for bus master 0. It never performs
//  real transfers. This master is granted in the following conditions:
//  1. when the previously granted master is performing a locked transfer that
//  has received a SPLIT response.
//  2. when the default master receives a SPLIT response and no other master
//  is requesting the bus.
//  3. when all masters have received SPLIT responses.
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
`ifndef AHB_DUMMY_MASTER_V
`define AHB_DUMMY_MASTER_V

`include "ahb_defines.v"

module ahb_dummy_master
(
  // Arbiter grant
  input HGRANT,
  // Transfer responses
  input HREADY,
  input [1:0] HRESP,
  // Reset
  input HRESETn,
  // Clock
  input HCLK,
  // Data input
  input [31:0] HRDATA,

  // To arbiter: HLOCK always LOW
  // There's no need for dummy master to actively "request" the bus. So no
  // HBUSREQ pin needed.
  // output reg HBUSREQ,
  output HLOCK,
  // Transfer type: always IDLE
  output [1:0] HTRANS,
  // Address and controls
  output [31:0] HADDR,
  output HWRITE,
  output [2:0] HSIZE,
  output [2:0] HBURST,
  // Data output
  output [31:0] HWDATA
);

// The key operation of dummy master is to output HTRANS as IDLE, and HLOCK as
// LOW. And the rest of output signals valid. 
// We try to keep the logic simple.
assign HTRANS = `HTRANS_IDLE;
assign HLOCK = 1'b0;

assign HADDR = 32'b0;
assign HWRITE = 1'b0;
assign HSIZE = 3'b0;
assign HBURST = 3'b0;
assign HWDATA = 32'b0;

endmodule


`endif // AHB_DUMMY_MASTER_V
