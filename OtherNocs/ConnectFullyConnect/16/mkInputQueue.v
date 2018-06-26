/*
 * These source files contain a hardware description of a network
 * automatically generated by CONNECT (CONfigurable NEtwork Creation Tool).
 *
 * This product includes a hardware design developed by Carnegie Mellon
 * University.
 *
 * Copyright (c) 2012 by Michael K. Papamichael, Carnegie Mellon University
 *
 * For more information, see the CONNECT project website at:
 *   http://www.ece.cmu.edu/~mpapamic/connect
 *
 * This design is provided for internal, non-commercial research use only, 
 * cannot be used for, or in support of, goods or services, and is not for
 * redistribution, with or without modifications.
 * 
 * You may not use the name "Carnegie Mellon University" or derivations
 * thereof to endorse or promote products derived from this software.
 *
 * THE SOFTWARE IS PROVIDED "AS-IS" WITHOUT ANY WARRANTY OF ANY KIND, EITHER
 * EXPRESS, IMPLIED OR STATUTORY, INCLUDING BUT NOT LIMITED TO ANY WARRANTY
 * THAT THE SOFTWARE WILL CONFORM TO SPECIFICATIONS OR BE ERROR-FREE AND ANY
 * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
 * TITLE, OR NON-INFRINGEMENT.  IN NO EVENT SHALL CARNEGIE MELLON UNIVERSITY
 * BE LIABLE FOR ANY DAMAGES, INCLUDING BUT NOT LIMITED TO DIRECT, INDIRECT,
 * SPECIAL OR CONSEQUENTIAL DAMAGES, ARISING OUT OF, RESULTING FROM, OR IN
 * ANY WAY CONNECTED WITH THIS SOFTWARE (WHETHER OR NOT BASED UPON WARRANTY,
 * CONTRACT, TORT OR OTHERWISE).
 *
 */


//
// Generated by Bluespec Compiler, version 2012.01.A (build 26572, 2012-01-17)
//
// On Sun Jun 10 13:14:20 EDT 2018
//
// Method conflict info:
// Method: enq
// Conflict-free: deq, notEmpty, notFull
// Conflicts: enq
//
// Method: deq
// Conflict-free: enq, notEmpty, notFull
// Conflicts: deq
//
// Method: notEmpty
// Conflict-free: enq, deq, notEmpty, notFull
//
// Method: notFull
// Conflict-free: enq, deq, notEmpty, notFull
//
//
// Ports:
// Name                         I/O  size props
// deq                            O    38
// notEmpty                       O     1 reg
// notFull                        O     1 reg
// CLK                            I     1 clock
// RST_N                          I     1 reset
// enq_data_in                    I    38
// EN_enq                         I     1
// EN_deq                         I     1
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif

module mkInputQueue(CLK,
		    RST_N,

		    enq_data_in,
		    EN_enq,

		    EN_deq,
		    deq,

		    notEmpty,

		    notFull);
  input  CLK;
  input  RST_N;

  // action method enq
  input  [37 : 0] enq_data_in;
  input  EN_enq;

  // actionvalue method deq
  input  EN_deq;
  output [37 : 0] deq;

  // value method notEmpty
  output notEmpty;

  // value method notFull
  output notFull;

  // signals for module outputs
  wire [37 : 0] deq;
  wire notEmpty, notFull;

  // inlined wires
  wire [2 : 0] inputQueue_ifc_mf_ifc_new_head$wget,
	       inputQueue_ifc_mf_ifc_new_tail$wget;

  // register inputQueue_ifc_mf_ifc_heads
  reg [2 : 0] inputQueue_ifc_mf_ifc_heads;
  wire [2 : 0] inputQueue_ifc_mf_ifc_heads$D_IN;
  wire inputQueue_ifc_mf_ifc_heads$EN;

  // register inputQueue_ifc_mf_ifc_not_empty
  reg inputQueue_ifc_mf_ifc_not_empty;
  wire inputQueue_ifc_mf_ifc_not_empty$D_IN,
       inputQueue_ifc_mf_ifc_not_empty$EN;

  // register inputQueue_ifc_mf_ifc_not_full
  reg inputQueue_ifc_mf_ifc_not_full;
  wire inputQueue_ifc_mf_ifc_not_full$D_IN, inputQueue_ifc_mf_ifc_not_full$EN;

  // register inputQueue_ifc_mf_ifc_tails
  reg [2 : 0] inputQueue_ifc_mf_ifc_tails;
  wire [2 : 0] inputQueue_ifc_mf_ifc_tails$D_IN;
  wire inputQueue_ifc_mf_ifc_tails$EN;

  // ports of submodule inputQueue_ifc_mf_ifc_fifoMem
  wire [37 : 0] inputQueue_ifc_mf_ifc_fifoMem$D_IN,
		inputQueue_ifc_mf_ifc_fifoMem$D_OUT;
  wire [2 : 0] inputQueue_ifc_mf_ifc_fifoMem$ADDR_IN,
	       inputQueue_ifc_mf_ifc_fifoMem$ADDR_OUT;
  wire inputQueue_ifc_mf_ifc_fifoMem$WE;

  // remaining internal signals
  wire [2 : 0] x__h1895, x__h2274;
  wire inputQueue_ifc_mf_ifc_rdFIFO_whas_AND_inputQue_ETC___d28,
       inputQueue_ifc_mf_ifc_wrFIFO_whas_AND_inputQue_ETC___d20;

  // actionvalue method deq
  assign deq = inputQueue_ifc_mf_ifc_fifoMem$D_OUT ;

  // value method notEmpty
  assign notEmpty = inputQueue_ifc_mf_ifc_not_empty ;

  // value method notFull
  assign notFull = inputQueue_ifc_mf_ifc_not_full ;

  // submodule inputQueue_ifc_mf_ifc_fifoMem
  RegFile_1port #( /*data_width*/ 32'd38,
		   /*addr_width*/ 32'd3) inputQueue_ifc_mf_ifc_fifoMem(.CLK(CLK),
								       .rst_n(RST_N),
								       .ADDR_IN(inputQueue_ifc_mf_ifc_fifoMem$ADDR_IN),
								       .ADDR_OUT(inputQueue_ifc_mf_ifc_fifoMem$ADDR_OUT),
								       .D_IN(inputQueue_ifc_mf_ifc_fifoMem$D_IN),
								       .WE(inputQueue_ifc_mf_ifc_fifoMem$WE),
								       .D_OUT(inputQueue_ifc_mf_ifc_fifoMem$D_OUT));

  // inlined wires
  assign inputQueue_ifc_mf_ifc_new_tail$wget =
	     inputQueue_ifc_mf_ifc_tails + 3'd1 ;
  assign inputQueue_ifc_mf_ifc_new_head$wget =
	     inputQueue_ifc_mf_ifc_heads + 3'd1 ;

  // register inputQueue_ifc_mf_ifc_heads
  assign inputQueue_ifc_mf_ifc_heads$D_IN = x__h2274 ;
  assign inputQueue_ifc_mf_ifc_heads$EN = EN_deq ;

  // register inputQueue_ifc_mf_ifc_not_empty
  assign inputQueue_ifc_mf_ifc_not_empty$D_IN = EN_enq && !EN_deq ;
  assign inputQueue_ifc_mf_ifc_not_empty$EN =
	     EN_enq && !EN_deq ||
	     inputQueue_ifc_mf_ifc_rdFIFO_whas_AND_inputQue_ETC___d28 ;

  // register inputQueue_ifc_mf_ifc_not_full
  assign inputQueue_ifc_mf_ifc_not_full$D_IN =
	     !inputQueue_ifc_mf_ifc_wrFIFO_whas_AND_inputQue_ETC___d20 ;
  assign inputQueue_ifc_mf_ifc_not_full$EN =
	     inputQueue_ifc_mf_ifc_wrFIFO_whas_AND_inputQue_ETC___d20 ||
	     EN_deq && !EN_enq ;

  // register inputQueue_ifc_mf_ifc_tails
  assign inputQueue_ifc_mf_ifc_tails$D_IN = x__h1895 ;
  assign inputQueue_ifc_mf_ifc_tails$EN = EN_enq ;

  // submodule inputQueue_ifc_mf_ifc_fifoMem
  assign inputQueue_ifc_mf_ifc_fifoMem$ADDR_IN = inputQueue_ifc_mf_ifc_tails ;
  assign inputQueue_ifc_mf_ifc_fifoMem$ADDR_OUT =
	     inputQueue_ifc_mf_ifc_heads ;
  assign inputQueue_ifc_mf_ifc_fifoMem$D_IN = enq_data_in ;
  assign inputQueue_ifc_mf_ifc_fifoMem$WE = EN_enq ;

  // remaining internal signals
  assign inputQueue_ifc_mf_ifc_rdFIFO_whas_AND_inputQue_ETC___d28 =
	     EN_deq && !EN_enq && x__h2274 == inputQueue_ifc_mf_ifc_tails ;
  assign inputQueue_ifc_mf_ifc_wrFIFO_whas_AND_inputQue_ETC___d20 =
	     EN_enq && !EN_deq && x__h1895 == inputQueue_ifc_mf_ifc_heads ;
  assign x__h1895 = EN_enq ? inputQueue_ifc_mf_ifc_new_tail$wget : 3'd0 ;
  assign x__h2274 = EN_deq ? inputQueue_ifc_mf_ifc_new_head$wget : 3'd0 ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (!RST_N)
      begin
        inputQueue_ifc_mf_ifc_heads <= `BSV_ASSIGNMENT_DELAY 3'd0;
	inputQueue_ifc_mf_ifc_not_empty <= `BSV_ASSIGNMENT_DELAY 1'd0;
	inputQueue_ifc_mf_ifc_not_full <= `BSV_ASSIGNMENT_DELAY 1'd1;
	inputQueue_ifc_mf_ifc_tails <= `BSV_ASSIGNMENT_DELAY 3'd0;
      end
    else
      begin
        if (inputQueue_ifc_mf_ifc_heads$EN)
	  inputQueue_ifc_mf_ifc_heads <= `BSV_ASSIGNMENT_DELAY
	      inputQueue_ifc_mf_ifc_heads$D_IN;
	if (inputQueue_ifc_mf_ifc_not_empty$EN)
	  inputQueue_ifc_mf_ifc_not_empty <= `BSV_ASSIGNMENT_DELAY
	      inputQueue_ifc_mf_ifc_not_empty$D_IN;
	if (inputQueue_ifc_mf_ifc_not_full$EN)
	  inputQueue_ifc_mf_ifc_not_full <= `BSV_ASSIGNMENT_DELAY
	      inputQueue_ifc_mf_ifc_not_full$D_IN;
	if (inputQueue_ifc_mf_ifc_tails$EN)
	  inputQueue_ifc_mf_ifc_tails <= `BSV_ASSIGNMENT_DELAY
	      inputQueue_ifc_mf_ifc_tails$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    inputQueue_ifc_mf_ifc_heads = 3'h2;
    inputQueue_ifc_mf_ifc_not_empty = 1'h0;
    inputQueue_ifc_mf_ifc_not_full = 1'h0;
    inputQueue_ifc_mf_ifc_tails = 3'h2;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N) if (EN_enq && !inputQueue_ifc_mf_ifc_not_full) $write("");
    if (RST_N) if (EN_enq && !inputQueue_ifc_mf_ifc_not_full) $write("");
    if (RST_N)
      if (EN_enq && !inputQueue_ifc_mf_ifc_not_full)
	$display("Dynamic assertion failed: \"MultiFIFOMem.bsv\", line 156, column 38\nEnqueing to full FIFO in MultiFIFOMem!");
    if (RST_N) if (EN_enq && !inputQueue_ifc_mf_ifc_not_full) $finish(32'd0);
    if (RST_N) if (EN_enq) $write("");
    if (RST_N)
      if (EN_deq && !inputQueue_ifc_mf_ifc_not_empty)
	$display("Dynamic assertion failed: \"MultiFIFOMem.bsv\", line 190, column 40\nDequeing from empty FIFO in MultiFIFOMem!");
    if (RST_N) if (EN_deq && !inputQueue_ifc_mf_ifc_not_empty) $finish(32'd0);
    if (RST_N) if (EN_deq) $write("");
    if (RST_N)
      if (inputQueue_ifc_mf_ifc_wrFIFO_whas_AND_inputQue_ETC___d20)
	$write("");
    if (RST_N)
      if (inputQueue_ifc_mf_ifc_rdFIFO_whas_AND_inputQue_ETC___d28)
	$write("");
  end
  // synopsys translate_on
endmodule  // mkInputQueue

