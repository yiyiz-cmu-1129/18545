module counter
  #(parameter WIDTH = 8)
  (input logic clear, reset, en, clock,
   output logic [WIDTH-1:0] count);

   always_ff @(posedge clock, posedge reset) begin
      if (reset)
	count <= 0;
      else if (clear)
	count <= 0;
      else if (en)
	count <= count + 1;
   end
endmodule // counter

module range_check
  #(parameter WIDTH = 8)
  (input logic [WIDTH-1:0] val, low, high,
   output logic is_between);

   assign is_between = (val >= low) && (val <= high);

endmodule: range_check

module offset_check
  #(parameter WIDTH = 8)
   (input logic [WIDTH-1:0] val, low, delta,
    output logic is_between);

   range_check #4 rc(val, low, low+delta, is_between);

endmodule: offset_check

module register
  #(parameter WIDTH = 8)
  (input logic en, clear, reset, clock,
   input logic [WIDTH-1:0] D,
   output logic [WIDTH-1:0] Q);

   always_ff @(posedge clock, posedge reset) begin
      if (reset)
	Q <= 0;
      else if (en)
	Q <= D;
      else if (clear)
	Q <= 'b0;
   end
endmodule: register

module defaultValRegister
  #(parameter WIDTH = 8)
  (input logic en, clear, reset, clock,
   input logic [WIDTH-1:0] D, startPos,
   output logic [WIDTH-1:0] Q);

   always_ff @(posedge clock, posedge reset) begin
      if (reset)
	Q <= startPos;
      else if (en)
	Q <= D;
      else if (clear)
	Q <= startPos;
   end
endmodule: defaultValRegister

module vga
  (input logic CLOCK_50, reset,
   output logic HS, VS, blank,
   output logic [8:0] row,
   output logic [9:0] col);

   logic 	      counterClear, counterEn, counterBClear, counterSClear;
   logic          counterBEn, counterSEn;
   logic [19:0]       Bcount;
   logic [10:0]       Scount;
   logic [9:0] 	      HScount;
   
   counter #(20) counterB(counterBClear, reset, counterBEn, CLOCK_50, Bcount);
   counter #(11) counterS(counterSClear, reset, counterSEn, CLOCK_50, Scount);
   
   assign counterBEn = 1;
   assign counterSEn = 1;
   assign counterBClear = (Bcount == 833599);
   assign counterSClear = (Scount == 1599);
   
   always_ff @(posedge CLOCK_50) begin
      if (reset == 1)
	HScount <= 0;
      else if (Bcount == 833599)
	HScount <= 0;
      else if (Scount == 1599)
	HScount <= HScount + 1;
   end

   logic 	      HS_l, VS_l;
   
   range_check #(11) HScheck(Scount, 11'd0, 11'd191, HS_l);
   range_check #(20) VScheck(Bcount, 20'd0, 20'd3199, VS_l);
   assign HS = ~HS_l;
   assign VS = ~VS_l;

   assign col = (Scount - 288) / 2;
   assign row = (HScount - 31);
   
   logic 	      HSFrontBlank, HSBackBlank, VSFrontBlank, VSBackBlank;

   range_check #(11) HSFrontBCheck(Scount, 11'd0, 11'd287, HSFrontBlank);
   range_check #(11) HSBackBCheck(Scount, 11'd1568, 11'd1599, HSBackBlank);
   range_check #(20) VSFrontBCheck(Bcount, 20'd0, 20'd49599, VSFrontBlank);
   range_check #(20) VSBackBCheck(Bcount, 20'd817600, 20'd833599, VSBackBlank);

   assign blank = HSFrontBlank || HSBackBlank || VSFrontBlank || VSBackBlank;
endmodule // vga
/*
module vga_test;
   logic CLOCK_50, reset;
   logic HS, VS, blank;
   logic [8:0] row;
   logic [9:0] col;

   logic [20:0] i;

   vga DUT(.*);

   initial begin
      CLOCK_50 = 0;
      forever #5 CLOCK_50 = ~CLOCK_50;
   end

   initial begin
      reset = 1;
      # 10 reset = 0;
      for (i = 0; i < 2**21 -1; i ++)
	@(posedge CLOCK_50);
      $finish;
   end
endmodule // vga_test
*/
