module jt51_top(output logic [23:0] left_to_board, 
                output logic [23:0] right_to_board,
                output logic sample,
                input logic clk, rst, SW1, SW0);

// Inputs
	//reg clk;
	//reg rst;
	reg cs_n;
	reg wr_n;
	reg a0;
	reg [7:0] d_in;

	// Outputs
	wire [7:0] d_out;
	wire ct1;
	wire ct2;
	wire irq_n;
	wire p1;
	wire signed [15:0] left, right, xleft, xright, dacleft, dacright;
  //wire sample;



jt51 uut (
		.clk(clk),
		.rst(rst),
		.cs_n(cs_n),
		.wr_n(wr_n),
		.a0(a0),
		.d_in(d_in),
		.d_out(d_out),
		.ct1(ct1),
		.ct2(ct2),
		.irq_n(irq_n),
		.p1(p1),
		.left	( left		),
		.right	( right		),
    .xleft	( xleft		),
    .xright	( xright	),
    .dacleft( dacleft	),
    .dacright(dacright  ),
    .sample	( sample	)
	);


  convert_16_to_24 c(.left(left),.right(right), 
                     .left_to_board(left_to_board), 
                     .right_to_board(right_to_board));


  reg [8:0] data_cnt;
	reg [3:0] state, next;
	reg prog_done;
	parameter WAIT_FREE=0, WR_ADDR=1, WR_VAL=2, DONE=3, WRITE=4, BLANK=5;
  parameter rom = "~/Private/MM545/YM2151/trunk/jt51_synth/input.hex";
  
    logic [7:0] sound_data, sound_addr;
    
	reg [15:0] cfg[0:185];
  initial $readmemh(rom, cfg);
  
    reg sync;
    
always @(posedge clk or posedge rst) begin
		if( rst ) begin
			data_cnt <= 0;
			prog_done<= 0;
			next <= WR_ADDR;
			state<= WAIT_FREE;
			sync <= 0;
		end
		else begin
			case( state )
				BLANK:	state <= WAIT_FREE;
				WAIT_FREE: begin
					// a0 <= 1'b0;
					{ cs_n, wr_n } = 2'b01;
					if( next == WR_ADDR & prog_done == 1) sync <= 1;
					if( !d_out[7] ) begin
						case( cfg[data_cnt][15:8] )
							8'h0: begin 
							prog_done <= 1'b1; //added this
							state <= next; //changed from state DONE
							end
							// Wait for timer flag:
							8'h3: if( d_out[1:0]&cfg[data_cnt][1:0] ) state<=next;
							8'h3: if( d_out[1:0]&cfg[data_cnt][1:0] ) state<=next;
							default: state <= next;
						endcase
					end
				end
				WRITE: begin
					{ cs_n, wr_n } = 2'b00;
					state<= BLANK;
				end
				WR_ADDR: begin
					a0   <= 1'b0;
					d_in <= (prog_done) ? sound_addr : cfg[data_cnt][15:8];
					next <= WR_VAL;
					state<= WRITE;
					sync <= 0;
				end
				WR_VAL: begin
					a0   <= 1'b1;
					d_in <= (prog_done) ? sound_data : cfg[data_cnt][7:0];
					state<= WRITE;
					if( data_cnt == 9'd511 ) begin
						next      <= WR_ADDR; //changed this drom stat DONE
					end
					else begin
						data_cnt <= (prog_done) ? 9'd65 : data_cnt + 1'b1; //Changed this from 
						next <= WR_ADDR;
					end
				end
				DONE: prog_done <= 1'b1;
				 
			endcase
		end
	end
    

always_comb begin
    case({SW1, SW0})
        2'b00: begin
               sound_addr = 8'h28;
               sound_data = 8'h49;
        end
        2'b01: begin
               sound_addr = 8'h28;
               sound_data = 8'h69;
        end
        2'b10: begin
               sound_addr = 8'h28;
               sound_data = 8'h89;
        end
        2'b11: begin
               sound_addr = 8'h80;
               sound_data = 8'h1f;
        end
    endcase
end
        

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
