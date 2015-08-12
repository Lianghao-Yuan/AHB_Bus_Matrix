//
//  Module: AHB bus arbiter(up to 3 bus master plus a dummy master)
//  (defined by ARM Design Kit Technical Reference Manual--AHB component)
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/06/2015
//  Description:
//  The AMBA bus specification is a multi-master bus standard. As a result,
//  a bus arbitor is required to ensure that only one bus master has access to
//  the bus at any particular time. This arbitor can support up to three bus
//  masters.
//
//  Priority scheme: 
//  Master 3 has highest priority.
//  Master 0 has second to highest priority, always connected to a dummy
//  master. 
//  Master 2 has middle priority.
//  Master 1 has lowest priority and is the default master(always granted the
//  bus when no other's using it and the dummy master request condition below
//  is not satisfied.)
//
//  Dummy master description: 
//  The dummy master is always reserved for bus master 0. It never performs
//  real transfers. This master is granted in the following conditions:
//  1. when the previously granted master is performing a locked transfer that
//  has received a SPLIT response.
//  2. when the default master receives a SPLIT response and no other master
//  is requesting the bus.
//  3. when all masters have received SPLIT responses.
//

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
`ifndef AHB_ARBITER3_V
`define AHB_ARBITER3_V

`include "ahb_defines.v"
module ahb_arbiter3
(
  // Dummy master:
  // Dummy master doesn't need to actively request the
  // bus, so we commented out the HBUSREQx0 signal.
  // The HBUSREQx0 and HLOCKx0 is never useful.
  input HBUSREQx0,
  input HLOCKx0,
  output reg HGRANTx0,

  input HBUSREQx1,
  input HLOCKx1,
  output reg HGRANTx1,

  input HBUSREQx2,
  input HLOCKx2,
  output reg HGRANTx2,

  input HBUSREQx3,
  input HLOCKx3,
  output reg HGRANTx3,

  // Address and control
  input [31:0] HADDR,
  input [3:0] HSPLIT,
  input [1:0] HTRANS,
  input [2:0] HBURST,
  input [1:0] HRESP,
  input HREADY,

  // Reset
  input HRESETn,
  // Clock
  input HCLK,

  // Signal for slaves
  // MASTER: which signal owns the current address phase
  output [3:0] HMASTER,
  // MASTERD: which signal owns the current data phase
  output [3:0] HMASTERD,
  output HMASTLOCK
);
// ------------------
// Local Registers //
// ------------------

// Output local registers
reg [3:0] HMASTER_l;
reg [3:0] HMASTERD_l;
reg HMASTLOCK_l;

// ------------------
// Control signals //
// ------------------
// grant: who earns the grant right now
reg [1:0] grant;
// next_grant: who earns the grant next cycle
reg [1:0] next_grant;

// is_degrant: will the next cycle be the final cycle of previous transfer and
// the bus is safe to degrant.
reg is_degrant;
// is_locked: is current transfer being locked
wire is_locked;
// is_fixed_length: is current transfer fixed length. If so we don't
// re-arbitrate until it completes.
reg is_fixed_length;
// is_split: whether the next response is SPLIT and should degrant bus in
// next cycle.
reg is_split;
// is_retry: whether the next response is RETRY and should degrant bus in next
// cycle.
reg is_retry;
// count: number of transactions left to transfer
// Notice, this is not number of transfers left to complete.
// Since the largest transaction is 16-beat, which takes 5 bits to store.
// We add extra bit (MSB) to indicate INCR.
reg [6:0] count;
// next_count: number of transactions left to transfer in next cycle.
reg [6:0] next_count;

// req_mask: to mask request from master who's in a SPLIT
// If the bit is 1, then it's not masked. If it's 0, then it's masked and
// needed to wait for slave HSPLIT to free it.
reg [3:0] req_mask;
// next_req_mask: next-cycle reg_mask value
reg [3:0] next_req_mask;

// ----------------
// Output logics //
// ----------------
// HMASTLOCK signal generation:
// Only assert HMASTLOCK when current granted bus has its HLOCKx signal raised.
always @ (*) begin
  if((HGRANTx0 && HLOCKx0) ||
     (HGRANTx1 && HLOCKx1) || 
     (HGRANTx2 && HLOCKx2) ||
     (HGRANTx3 && HLOCKx3)) begin
    HMASTLOCK_l = 1'b1;
  end
  else begin
    HMASTLOCK_l = 1'b0;
  end
end
assign HMASTLOCK = HMASTLOCK_l;

// HGRANTx output:
// We base on the priority scheme described at the beginning of this file.
always @ (posedge HCLK or negedge HRESETn) begin
  if(!HRESETn) begin
    grant <= 2'b01; // Default master
  end
  else begin
    // Dummy master grant
    if((is_locked && (HRESP == `HRESP_SPLIT)) ||
       (HGRANTx1 && HRESP == `HRESP_SPLIT && !HBUSREQx2 && !HBUSREQx3) ||
       (req_mask == 4'b0)) begin
      grant <= 2'b00;
    end
    else if(is_degrant) begin
      grant <= next_grant;
    end
  end
end

always @ (*) begin
  if(HBUSREQx3 && req_mask[3]) begin
    next_grant = 4'h3;
  end
  else if(HBUSREQx2 && req_mask[2]) begin
    next_grant = 4'h2;
  end
  // Default AHB master
  else begin
    next_grant = 4'h1;
  end
end

always @ (*) begin
  // Clear the grant value for assignment
  HGRANTx0 = 1'b0;
  HGRANTx1 = 1'b0;
  HGRANTx2 = 1'b0;
  HGRANTx3 = 1'b0;
  // Output HGRANTx
  case(grant) 
    4'h3: HGRANTx3 = 1'b1;
    4'h2: HGRANTx2 = 1'b1;
    4'h1: HGRANTx1 = 1'b1;
    4'h0: HGRANTx0 = 1'b1;
  endcase
end

// HMASTER signal generation:
// Only update HMASTER upon HREADY is HIGH. On switching grant, this indicate 
// that the final transfer is cached in by slave and the address & control bus 
// now belong to new master.
always @ (posedge HCLK or negedge HRESETn) begin
  if(!HRESETn) begin
    HMASTER_l <= 2'b01; // Default master
  end
  else if(HREADY) begin
    HMASTER_l <= grant;
  end
end
assign HMASTER = HMASTER_l;

// HMASTERD signal generation:
// Only update HMASTERD upon HREADY is HIGH. This indicates the flow of
// pipeline.
always @ (posedge HCLK or negedge HRESETn) begin
  if(!HRESETn) begin
    HMASTERD_l <= 0;
  end
  else begin
    if(HREADY) begin
      HMASTERD_l <= HMASTER_l;
    end
    else begin
      HMASTERD_l <= HMASTERD_l;
    end
  end
end
assign HMASTERD = HMASTERD_l;

// -------------------------------
// is_degrant calculation logic //
// -------------------------------

always @ (*) begin
  if((HGRANTx0 && !HBUSREQx0) || 
     (HGRANTx1 && !HBUSREQx1) ||
     (HGRANTx2 && !HBUSREQx2) ||
     (HGRANTx3 && !HBUSREQx3)) begin
    is_degrant = 1'b1; 
  end
  // If current transfer is IDLE, then it's safe to de-grant
  else if(HTRANS == `HTRANS_IDLE) begin
    is_degrant = 1'b1;
  end
  // Normal de-grant:
  // If current transaction is fixed-length and in the next cycle will be the
  // final transfer(for SINGLE transaction that finishes in one cycle, the
  // next cycle would be end.)
  else if(is_fixed_length && 
         (!is_locked) && 
         (next_count == 1'b0 || next_count == 1'b1)) begin
    is_degrant = 1'b1;
  end
  // Abnormal degrant:
  // When observing the SPLIT
  else if(is_split) begin
    is_degrant = 1'b1;
  end
  else if(is_retry) begin
    is_degrant = 1'b1;
  end
  else begin
    is_degrant = 1'b0;
  end
end

// ------------------------------
// is_locked calculation logic //
// ------------------------------

assign is_locked = (HGRANTx0 && HLOCKx0) ||
                   (HGRANTx1 && HLOCKx1) ||
                   (HGRANTx2 && HLOCKx2) ||
                   (HGRANTx3 && HLOCKx3);

// ------------------------------------
// is_fixed_length calculation logic //
// ------------------------------------

always @ (posedge HCLK or negedge HRESETn) begin
  if(!HRESETn) begin
    is_fixed_length <= 1'b0;
  end
  else begin
    case(HBURST) 
      `HBURST_SINGLE: is_fixed_length <= 1'b0;
      `HBURST_INCR:   is_fixed_length <= 1'b0;
      `HBURST_WRAP4:  is_fixed_length <= 1'b1;
      `HBURST_INCR4:  is_fixed_length <= 1'b1;
      `HBURST_WRAP8:  is_fixed_length <= 1'b1;
      `HBURST_INCR8:  is_fixed_length <= 1'b1;
      `HBURST_WRAP16: is_fixed_length <= 1'b1;
      `HBURST_INCR16: is_fixed_length <= 1'b1;
    endcase
  end
end

// -----------------------------
// is_split calculation logic //
// -----------------------------

always @ (posedge HCLK or negedge HRESETn) begin
  if (!HRESETn) begin
    is_split <= 1'b0;
  end
  else begin
    if(HRESP == `HRESP_SPLIT) begin
      is_split <= 1'b1;
    end
    else begin
      is_split <= 1'b0;
    end
  end
end
// -----------------------------
// is_retry calculation logic //
// -----------------------------

always @ (posedge HCLK or negedge HRESETn) begin
  if (!HRESETn) begin
    is_retry <= 1'b0;
  end
  else begin
    if(HRESP == `HRESP_RETRY) begin
      is_retry <= 1'b1;
    end
    else begin
      is_retry <= 1'b0;
    end
  end

end

// ------------------------------------------------
// next_count calculation and count update logic //
// ------------------------------------------------

always @ (*) begin
  // If HTRANS is NONSEQ, reset counter
  if(HTRANS == `HTRANS_NONSEQ) begin
    // If HREADY is HIGH, then current transaction will be transfered in next
    // cycle. The count is reset and then minus 1.
    if(HREADY) begin
      case(HBURST)
        `HBURST_SINGLE: next_count = 6'h0;
        `HBURST_INCR:   next_count = 6'h20; // Using the 6th bit to indicate INCR
        `HBURST_WRAP4:  next_count = 6'h3;
        `HBURST_INCR4:  next_count = 6'h3;
        `HBURST_WRAP8:  next_count = 6'h7;
        `HBURST_INCR8:  next_count = 6'h7;
        `HBURST_WRAP16: next_count = 6'hf;
        `HBURST_WRAP16: next_count = 6'hf;
      endcase
    end // :if(READY)
    // Else, reset the count
    else begin
      case(HBURST)
        `HBURST_SINGLE: next_count = 6'h1;
        `HBURST_INCR:   next_count = 6'h20; // Using the 6th bit to indicate INCR
        `HBURST_WRAP4:  next_count = 6'h4;
        `HBURST_INCR4:  next_count = 6'h4;
        `HBURST_WRAP8:  next_count = 6'h8;
        `HBURST_INCR8:  next_count = 6'h8;
        `HBURST_WRAP16: next_count = 6'h10;
        `HBURST_WRAP16: next_count = 6'h10;
      endcase
    end // :if(READY) else
  end // :if(HTRANS == HTRANS_NONSEQ)
  else if(HTRANS == `HTRANS_BUSY)begin
    next_count = count;
  end
  else if(HTRANS == `HTRANS_IDLE)begin
    next_count = 6'h0;
  end
  // If HTRANS is not NONSEQ or IDLE, then calculate count_next based on previous count
  else begin
    // If HREADY is HIGH, then the current count should minus one in most
    // cases.
    if(HREADY) begin
      if(count[5] == 1) begin // Indicating this is unspecified length INCR
        next_count = count; // Remain the same count
      end
      else begin
        next_count = count - 1;
      end
    end
    else begin
      next_count = count;
    end
  end
end

always @ (posedge HCLK or negedge HRESETn) begin
  if (!HRESETn) begin
    count <= 6'b0;
  end
  else begin
    count <= next_count;
  end
end

// ------------------------------------------------------
// next_req_mask calculation and req_mask update logic //
// ------------------------------------------------------

always @ (*) begin
  // Free HBUSREQ mask based on HSPLIT
  next_req_mask = req_mask | HSPLIT;
  // Mask bits if is_split
  if(is_split) begin
    case(HMASTER)
      2'b00: next_req_mask[0] = 1'b0;
      2'b01: next_req_mask[1] = 1'b0;
      2'b10: next_req_mask[2] = 1'b0;
      2'b11: next_req_mask[3] = 1'b0;
    endcase
  end
end

always @ (posedge HCLK or negedge HRESETn) begin
  if(!HRESETn) begin
    req_mask <= 4'b1111;
  end
  else begin
    req_mask <= next_req_mask;
  end
end


endmodule

`endif
