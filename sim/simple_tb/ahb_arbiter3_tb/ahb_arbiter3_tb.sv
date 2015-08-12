//
//  Module: AHB bus arbiter testbench
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/08/2015
//  Description:
//  Performing simple verification for arbiter functionality
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
`ifndef AHB_ARBITER3_TB_SV
`define AHB_ARBITER3_TB_SV

`include "ahb_defines.v"
module ahb_arbiter3_tb();
// Dummy master
// Dummy master doesn't need to actively request the
// bus, so we commented out the HBUSREQx0 signal.
logic HBUSREQx0;
logic HLOCKx0;
logic HGRANTx0;

logic HBUSREQx1;
logic HLOCKx1;
logic HGRANTx1;

logic HBUSREQx2;
logic HLOCKx2;
logic HGRANTx2;

logic HBUSREQx3;
logic HLOCKx3;
logic HGRANTx3;

// Address and control
logic [31:0] HADDR;
logic [15:0] HSPLIT;
logic [1:0] HTRANS;
logic [2:0] HBURST;
logic [1:0] HRESP;
logic HREADY;

// Reset
logic HRESETn;
// Clock
logic HCLK;

// Signal for slaves
// MASTER: which signal owns the current address phase
logic [3:0] HMASTER;
// MASTERD: which signal owns the current data phase
logic [3:0] HMASTERD;
logic HMASTLOCK;

// ----------------
// Instantiation //
// ----------------

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
  HBUSREQx0 <= 1'b0;
  HBUSREQx1 <= 1'b0;
  HBUSREQx2 <= 1'b0;
  HBUSREQx3 <= 1'b0;
  HLOCKx0 <= 1'b0;
  HLOCKx1 <= 1'b0;
  HLOCKx2 <= 1'b0;
  HLOCKx3 <= 1'b0;
  HADDR <= 32'b0;
  HSPLIT <= 16'b0;
  HTRANS <= 2'b0;
  HBURST <= 3'b0;
  HRESP <= 2'b0;
  HREADY <= 1'b0;

  // Initialization
  wait(HRESETn == 0);
  wait(HRESETn == 1);
  @(posedge HCLK);
  @(posedge HCLK);
  $display("@%t Testing initialization finished.", $time);

  HBUSREQx3 <= 1'b1;
  HREADY <= 1'b1;
  HRESP <= `HRESP_OKAY;
  @(posedge HCLK);
  HTRANS <= `HTRANS_NONSEQ;
  HBURST <= `HBURST_SINGLE;
  @(posedge HCLK);
  @(posedge HCLK);
  $display("@%t Testing on Master3 request finished.", $time);

  HBUSREQx3 <= 1'b0;
  HBUSREQx2 <= 1'b1;
  @(posedge HCLK);
  @(posedge HCLK);
  HTRANS <= `HTRANS_NONSEQ;
  HBURST <= `HBURST_INCR4;
  @(posedge HCLK);
  HTRANS <= `HTRANS_SEQ;
  HBUSREQx3 <= 1'b1;
  @(posedge HCLK);
  @(posedge HCLK);
  @(posedge HCLK);
  HBURST <= `HBURST_SINGLE;
  HTRANS <= `HTRANS_IDLE;
  HBUSREQx2 <= 1'b0;

  $display("@%t Testing on Master2 and Master3 fighting for request finished.", $time);

  $finish;
end


endmodule

`endif
