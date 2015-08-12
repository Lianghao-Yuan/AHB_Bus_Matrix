//
//  Module: AHB defines
//  (defined by ARM Design Kit Technical Reference Manual--AHB component)
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/03/2015
//  Description:
//  Collection of `define macros
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
`ifndef AHB_DEFINES_V
`define AHB_DEFINES_V
// Implementation defines

// ***********************
// To be added
// ***********************

// Transfer type: HTRANS[1:0]

`define HTRANS_IDLE   2'b00
`define HTRANS_BUSY   2'b01
`define HTRANS_NONSEQ 2'b10
`define HTRANS_SEQ    2'b11

// Bus operation: HBURST[2:0]
// Note: Bursts must not cross a 1kB address boundary

`define HBURST_SINGLE 3'b000
`define HBURST_INCR   3'b001
`define HBURST_WRAP4  3'b010
`define HBURST_INCR4  3'b011
`define HBURST_WRAP8  3'b100
`define HBURST_INCR8  3'b101
`define HBURST_WRAP16 3'b110
`define HBURST_INCR16 3'b111

// Write signal: HWRITE

`define HWRITE_READ  1'b0
`define HWRITE_WRITE 1'b1

// Transfer size: HSIZE[2:0]

`define HSIZE_8    3'b000
`define HSIZE_16   3'b001
`define HSIZE_32   3'b010
`define HSIZE_64   3'b011
`define HSIZE_128  3'b100
`define HSIZE_256  3'b101
`define HSIZE_512  3'b110
`define HSIZE_1024 3'b111

// Protection control: HPROT[3:0]
// For modules that intend to implement some level of protection
// We are just building generic AHB components, and thus not implementing
// any protection into our modules. 
// It is recommended by ARM Corp. that slaves DO NOT use the HPROT signals
// unless strictly necessary.

// Transfer response: HRESP[1:0]

`define HRESP_OKAY  2'b00
`define HRESP_ERROR 2'b01
`define HRESP_RETRY 2'b10
`define HRESP_SPLIT 2'b11

`endif // AHB_DEFINES_V
