//a testbench made by Yiyi Zhang
module jt51_test; 

  wire clk;  // main clock
  wire rst;  // reset 
  wire cs_n;	// chip select
	wire wr_n;	// write
	wire a0; 
	wire [7:0]	d_in; // data in
	wire [7:0]	d_out; // data out
	wire ct1;
	wire ct2;
	wire irq_n;	// I do not synchronize this signal
	reg p1;
	// Low resolution output (same as real chip)
	wire sample;	// marks new output sample
	wire	signed [15:0] left;
	wire	signed [15:0] right;
	// Full resolution output
	wire	signed [15:0] xleft;
	wire	signed [15:0] xright;
	// unsigned outputs for sigma delta converters, full resolution
	wire 	[15:0] dacleft;
	wire 	[15:0] dacright;

  wire signed [23:0] left_to_board;
  wire signed [23:0] right_to_board;

  jt51 YM2151_chip(
    .clk(clk),	// main clock
	  .rst(rst),	// reset
	  .cs_n(cs_n),	// chip select
	  .wr_n(wr_n),	// write
	  .a0(a0),
	  .d_in(d_in), // data in
	  .d_out(d_out), // data out
	  .ct1(ct1),
	  .ct2(ct2),
	  .irq_n(irq_n),	// I do not synchronize this signal
	  .p1(p1),
	  // Low resolution output (same as real chip)
	  .sample(sample),	// marks new output sample
	  .left(left),
	  .right(right),
	  // Full resolution output
	  .xleft(xleft),
	  .xright(xright),
	  // unsigned outputs for sigma delta converters, full resolution
	  .dacleft(dacleft),
	  .dacright(dacright)
  );

  convert_16_to_24 c16_24(
   .left(left), 
   .right(right),
   .left_to_board(left_to_board), 
   .right_to_board(right_to_board)
);


endmodule 

// mapping 
// -(2^15) -> -(2^15) * 2^8 
// -(2^15) -> [-(2^15)+1] * 2^8
// ...
// 0 -> 0 * 2^8
// ...
// 2^15 - 1 -> [2^15 -1] * 2^8 
module convert_16_to_24(
  input signed [15:0] left, 
  input signed [15:0] right,
  output signed [23:0] left_to_board, 
  output signed [23:0] right_to_board
);

  assign left_to_board = left << 8; //left * 2^8
  assign right_to_board = right << 8; // right * 2^8

endmodule 
