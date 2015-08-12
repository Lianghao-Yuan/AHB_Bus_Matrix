//
//  Module: AHB reset controller
//  (defined by ARM Design Kit Technical Reference Manual--AHB component)
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/03/2015
//  Description:
//  The reset controller generates the system reset signal from an external
//  reset input. This module is based on a state machine that is used to
//  detect the external reset being asserted, and is used to generate the
//  system reset output. 
//  
//  The HRESETn is asynchronously asserted(LOW) and always deasserted on
//  posedge HCLK.
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
`ifndef AHB_RESET_CTRL_V
`define AHB_RESET_CTRL_V

module ahb_reset_ctrl(
  // ----------------
  // Input signals //
  // ----------------
  //
  // HPB clock
  input HCLK,
  // Power-on reset: Power-on reset input. This active lOW signal causes a 
  // cold reset when LOW. Can be asserted asynchronously to HCLK. The source
  // of the nPOReset signal is implementation-dependent.
  input nPOReset,
  // The watchdog clock domain reset input. (Ignored in our implementation)
  // input WDOGRES, 

  // -----------------
  // Output signals //
  // -----------------
  //
  // The watchdog clock domain reset output. In this implementation we treat
  // WDOGRESn as the same with HRESETn. (Ignored in our implementation)
  // output WDOGRESn,
  // The system reset output
  output reg HRESETn
);

// Treat WDOGRESn the same as HRESETn
// assign WDOGRESn = HRESETn;

// Reset signal generation
// We assert the HRESETn asynchronously and deassert it synchronously 
always @ (posedge HCLK or negedge nPOReset) begin
  if(!nPOReset) begin
    HRESETn <= 0;
  end
  else begin
    HRESETn <= 1;
  end
end

endmodule



`endif
