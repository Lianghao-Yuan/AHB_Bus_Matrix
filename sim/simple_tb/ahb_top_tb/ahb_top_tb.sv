//
//  Module: AHB top testbench
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/13/2015
//  Description:
//  Performing simple verification for overall functionality
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
`ifndef AHB_TOP_TB_SV
`define AHB_TOP_TB_SV

`include "ahb_defines.v"
module ahb_arbiter3_tb();
// X signals from masters
// We support 3 master and 1 dummy master
logic HBUSREQx0;
logic HBUSREQx1;
logic HBUSREQx2;
logic HBUSREQx3;

logic HLOCKx0;
logic HLOCKx1;
logic HLOCKx2;
logic HLOCKx3;

logic [1:0] HTRANSx0;
logic [1:0] HTRANSx1;
logic [1:0] HTRANSx2;
logic [1:0] HTRANSx3;

logic [31:0] HADDRx0;
logic [31:0] HADDRx1;
logic [31:0] HADDRx2;
logic [31:0] HADDRx3;

logic HWRITEx0;
logic HWRITEx1;
logic HWRITEx2;
logic HWRITEx3;

logic [2:0] HSIZEx0;
logic [2:0] HSIZEx1;
logic [2:0] HSIZEx2;
logic [2:0] HSIZEx3;

logic [3:0] HBURSTx0;
logic [3:0] HBURSTx1;
logic [3:0] HBURSTx2;
logic [3:0] HBURSTx3;

logic [31:0] HWDATAx0;
logic [31:0] HWDATAx1;
logic [31:0] HWDATAx2;
logic [31:0] HWDATAx3;

// X signals from slaves
// We support 6 slaves and 1 default slave
logic HREADYx0;
logic HREADYx1;
logic HREADYx2;
logic HREADYx3;
logic HREADYx4;
logic HREADYx5;
logic HREADYx6;

logic [1:0] HRESPx0;
logic [1:0] HRESPx1;
logic [1:0] HRESPx2;
logic [1:0] HRESPx3;
logic [1:0] HRESPx4;
logic [1:0] HRESPx5;
logic [1:0] HRESPx6;

logic [31:0] HRDATAx0;
logic [31:0] HRDATAx1;
logic [31:0] HRDATAx2;
logic [31:0] HRDATAx3;
logic [31:0] HRDATAx4;
logic [31:0] HRDATAx5;
logic [31:0] HRDATAx6; 

logic [3:0] HSPLITx0;
logic [3:0] HSPLITx1;
logic [3:0] HSPLITx2;
logic [3:0] HSPLITx3;
logic [3:0] HSPLITx4;
logic [3:0] HSPLITx5;
logic [3:0] HSPLITx6;

// X signals from arbiter
logic HGRANTx0;
logic HGRANTx1;
logic HGRANTx2;
logic HGRANTx3;

// X signals from decoder
logic HSELx0;
logic HSELx1;
logic HSElx2;
logic HSELx3;
logic HSELx4;
logic HSELx5;
logic HSELx6;

// AMBA AHB main signals
// Reset
logic HRESETn;
// Clock
logic HCLK;
// Master-to-slave
logic [1:0] HTRANS;
logic [31:0] HADDR;
logic HWRITE;
logic [2:0] HSIZE;
logic [3:0] HBURST;
logic [31:0] HWDATA;
// Slave-to-master
logic HREADY;
logic [1:0] HRESP;
logic [31:0] HRDATA;

// Signals for mux
// MASTER: which signal owns the current address phase
logic [3:0] HMASTER;
logic HMASTLOCK;

// ---------------------------
// External control signals //
// ---------------------------
logic [1:0] HRESPx1_i;
logic [1:0] HRESPx2_i;
logic [1:0] HRESPx3_i;
logic [1:0] HRESPx4_i;
logic [1:0] HRESPx5_i;
logic [1:0] HRESPx6_i;

logic [2:0] wait_cyclex1_i;
logic [2:0] wait_cyclex2_i;
logic [2:0] wait_cyclex3_i;
logic [2:0] wait_cyclex4_i;
logic [2:0] wait_cyclex5_i;
logic [2:0] wait_cyclex6_i;

logic deassert_splitx1;
logic deassert_splitx2;
logic deassert_splitx3;
logic deassert_splitx4;
logic deassert_splitx5;
logic deassert_splitx6;

// output
logic HMASTLOCKx1_o;
logic HMASTLOCKx2_o;
logic HMASTLOCKx3_o;
logic HMASTLOCKx4_o;
logic HMASTLOCKx5_o;
logic HMASTLOCKx6_o;


// ----------------
// Instantiation //
// ----------------

ahb_bus_matrix bus_matrix
(
  .HBUSREQx0,
  .HBUSREQx1,
  .HBUSREQx2,
  .HBUSREQx3,

  .HLOCKx0,
  .HLOCKx1,
  .HLOCKx2,
  .HLOCKx3,

  .HTRANSx0,
  .HTRANSx1,
  .HTRANSx2,
  .HTRANSx3,

  .HADDRx0,
  .HADDRx1,
  .HADDRx2,
  .HADDRx3,

  .HWRITEx0,
  .HWRITEx1,
  .HWRITEx2,
  .HWRITEx3,

  .HSIZEx0,
  .HSIZEx1,
  .HSIZEx2,
  .HSIZEx3,

  .HBURSTx0,
  .HBURSTx1,
  .HBURSTx2,
  .HBURSTx3,

  .HWDATAx0,
  .HWDATAx1,
  .HWDATAx2,
  .HWDATAx3,

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

  .HRDATAx0,
  .HRDATAx1,
  .HRDATAx2,
  .HRDATAx3,
  .HRDATAx4,
  .HRDATAx5,
  .HRDATAx6,

  .HSPLITx0,
  .HSPLITx1,
  .HSPLITx2,
  .HSPLITx3,
  .HSPLITx4,
  .HSPLITx5,
  .HSPLITx6,

  .HGRANTx0,
  .HGRANTx1,
  .HGRANTx2,
  .HGRANTx3,

  .HSELx0,
  .HSELx1,
  .HSELx2,
  .HSELx3,
  .HSELx4,
  .HSELx5,
  .HSELx6,

  .HRESETn,
  .HCLK,
  .HTRANS,
  .HADDR,
  .HWRITE,
  .HSIZE,
  .HBURST,
  .HWDATA,
  .HREADY,
  .HRESP,
  .HRDATA,
  .HMASTER,
  .HMASTLOCK
);

// Slave 0 (default slave)
ahb_default_slave default_slave_0
(
  .HMASTER,
  .HMASTLOCK,
  .HSPLIT(HSPLITx0),
  .HSEL(HSELx0),
  .HADDR,
  .HWRITE,
  .HTRANS,
  .HSIZE,
  .HBURST,
  .HWDATA,
  .HRESETn,
  .HCLK,
  .HREADY(HREADYx0),
  .HRESP(HRESPx0),
  .HRDATA(HRDATAx0)
);

// Slave 1
ahb_slave slave_1
(
  .HSEL(HSELx1),
  .HADDR,
  .HWRITE,
  .HTRANS,
  .HSIZE,
  .HBURST,
  .HWDATA,
  .HRESETn,
  .HCLK,
  .HMASTER,
  .HMASTLOCK,
  .HRESP_i(HRESPx1_i),
  .wait_cycle_i(wait_cyclex1_i),
  .deassert_split(deassert_splitx1),
  .HREADY(HREADYx1),
  .HRESP(HRESPx1),
  .HRDATA(HRDATAx1),
  .HSPLIT(HSPLITx1),
  .HMASTLOCK_o(HMASTLOCKx1_o)
);

// Slave 2
ahb_slave slave_2
(
  .HSEL(HSELx2),
  .HADDR,
  .HWRITE,
  .HTRANS,
  .HSIZE,
  .HBURST,
  .HWDATA,
  .HRESETn,
  .HCLK,
  .HMASTER,
  .HMASTLOCK,
  .HRESP_i(HRESPx2_i),
  .wait_cycle_i(wait_cyclex2_i),
  .deassert_split(deassert_splitx2),
  .HREADY(HREADYx2),
  .HRESP(HRESPx2),
  .HRDATA(HRDATAx2),
  .HSPLIT(HSPLITx2),
  .HMASTLOCK_o(HMASTLOCKx2_o)
);

// Slave 3
ahb_slave slave_3
(
  .HSEL(HSELx3),
  .HADDR,
  .HWRITE,
  .HTRANS,
  .HSIZE,
  .HBURST,
  .HWDATA,
  .HRESETn,
  .HCLK,
  .HMASTER,
  .HMASTLOCK,
  .HRESP_i(HRESPx3_i),
  .wait_cycle_i(wait_cyclex3_i),
  .deassert_split(deassert_splitx3),
  .HREADY(HREADYx3),
  .HRESP(HRESPx3),
  .HRDATA(HRDATAx3),
  .HSPLIT(HSPLITx3),
  .HMASTLOCK_o(HMASTLOCKx3_o)
);

// Slave 4
ahb_slave slave_4
(
  .HSEL(HSELx4),
  .HADDR,
  .HWRITE,
  .HTRANS,
  .HSIZE,
  .HBURST,
  .HWDATA,
  .HRESETn,
  .HCLK,
  .HMASTER,
  .HMASTLOCK,
  .HRESP_i(HRESPx4_i),
  .wait_cycle_i(wait_cyclex4_i),
  .deassert_split(deassert_splitx4),
  .HREADY(HREADYx4),
  .HRESP(HRESPx4),
  .HRDATA(HRDATAx4),
  .HSPLIT(HSPLITx4),
  .HMASTLOCK_o(HMASTLOCKx4_o)
);

// Slave 5
ahb_slave slave_5
(
  .HSEL(HSELx5),
  .HADDR,
  .HWRITE,
  .HTRANS,
  .HSIZE,
  .HBURST,
  .HWDATA,
  .HRESETn,
  .HCLK,
  .HMASTER,
  .HMASTLOCK,
  .HRESP_i(HRESPx5_i),
  .wait_cycle_i(wait_cyclex5_i),
  .deassert_split(deassert_splitx5),
  .HREADY(HREADYx5),
  .HRESP(HRESPx5),
  .HRDATA(HRDATAx5),
  .HSPLIT(HSPLITx5),
  .HMASTLOCK_o(HMASTLOCKx5_o)
);

// Slave 6
ahb_slave slave_6
(
  .HSEL(HSELx6),
  .HADDR,
  .HWRITE,
  .HTRANS,
  .HSIZE,
  .HBURST,
  .HWDATA,
  .HRESETn,
  .HCLK,
  .HMASTER,
  .HMASTLOCK,
  .HRESP_i(HRESPx6_i),
  .wait_cycle_i(wait_cyclex6_i),
  .deassert_split(deassert_splitx6),
  .HREADY(HREADYx6),
  .HRESP(HRESPx6),
  .HRDATA(HRDATAx6),
  .HSPLIT(HSPLITx6),
  .HMASTLOCK_o(HMASTLOCKx6_o)
);

// Dummy master
ahb_dummy_master dummy_master_0
(
  .HGRANT(HGRANTx0),
  .HREADY,
  .HRESP,
  .HRESETn,
  .HCLK,
  .HRDATA,
  .HLOCK(HLOCKx0),
  .HTRANS(HTRANSx0),
  .HADDR(HADDRx0),
  .HWRITE(HWRITEx0),
  .HSIZE(HSIZEx0),
  .HBURST(HBURSTx0),
  .HWDATA(HWDATAx0)
);

// --------------------------------------
// Initialization and Clock generation
// --------------------------------------

initial begin
  HRESETn <= 1;
  HCLK <= 0;
  # 1 HRESETn <= 0;
  # 9 HRESETn <= 1;
  forever begin
    # 10 HCLK <= ~HCLK;
  end
end

// -------------
// Dump files //
// -------------

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0, ahb_arbiter3_tb);
end

// ------------
// Testbench //
// ------------

initial begin
  // We only test using master 1 (default master)
  // Reset all other signals
  // Master 2
  HBUSREQx2 <= 1'b0;
  HLOCKx2 <= 1'b0;
  HTRNSx2 <= 2'b0;
  HADDRx2 <= 32'b0;
  HWRITEx2 <= 1'b0;
  HSIZEx2 <= 3'b0;
  HBURSTx2 <= 3'b0;
  HWDATAx2 <= 32'b0;

  // Master 3
  HBUSREQx3 <= 1'b0;
  HLOCKx3 <= 1'b0;
  HTRNSx3 <= 2'b0;
  HADDRx3 <= 32'b0;
  HWRITEx3 <= 1'b0;
  HSIZEx3 <= 3'b0;
  HBURSTx3 <= 3'b0;
  HWDATAx3 <= 32'b0;

  // Slave response configuration (all responding with OKAY with no delay)
  HRESPx1_i <= `HRESP_OKAY;
  wait_cyclex1_i <= 3'b0;
  deassert_splitx1 <= 1'b0;

  HRESPx2_i <= `HRESP_OKAY;
  wait_cyclex2_i <= 3'b0;
  deassert_splitx2 <= 1'b0;

  HRESPx3_i <= `HRESP_OKAY;
  wait_cyclex3_i <= 3'b0;
  deassert_splitx3 <= 1'b0;

  HRESPx4_i <= `HRESP_OKAY;
  wait_cyclex4_i <= 3'b0;
  deassert_splitx4 <= 1'b0;

  HRESPx5_i <= `HRESP_OKAY;
  wait_cyclex5_i <= 3'b0;
  deassert_splitx5 <= 1'b0;

  HRESPx6_i <= `HRESP_OKAY;
  wait_cyclex6_i <= 3'b0;
  deassert_splitx6 <= 1'b0;

  // Configure Master 1
  HBUSREQx1 <= 1'b0;
  HLOCKx1 <= 1'b0;
  HTRNSx1 <= 2'b0;
  HADDRx1 <= 32'b0;
  HWRITEx1 <= 1'b0;
  HSIZEx1 <= 3'b0;
  HBURSTx1 <= 3'b0;
  HWDATAx1 <= 32'b0;

  // Master 1 starting transaction
  @(posedge HCLK);
  @(posedge HCLK);
  HBUSREQx1 <= 1'b1;
  HTRANSx1 <= `HTRANS_NONSEQ;
  HSIZEx1 <= `HSIZE_32;
  HBURSTx1 <= `HBURST_SINGLE;
  @(posedge HCLK);
  @(posedge HCLK);
  $finish;
end

endmodule // AHB_TOP_TB_SV

`endif
