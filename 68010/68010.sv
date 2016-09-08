//words are 16 bit longs are 32, quadwords are 64 

/*This is going to be a 5 stage pipe most likely
yay 447
The reason for this is because for any instructions that deal with imm
I need to look at the next 2 instructions to create the imm value


FETCH
DECODE
ALU
MEM
Write Back


*/

`include "68010Defines.vh"

module m68010_top(
	//Output signals
	fc0, fc1, fc2, address_bus, e, vma_b, reset_b, halt_b,
	as_b, rw_b, uds_b, lds_b, bg_b,
	//Input signals
	vcc, gnd, clk, vpa_b, berr_b, dtack_b, br_b, bgack_b,
	ipl0_b, ipl1_b, ipl2_b,
	//Inout Signals
	data_bus);

	input logic vcc, gnd, clk;
	//Processor status
	output logic fc0, fc1, fc2;

	inout logic [15:0] data_bus;

	output logic [22:0] address_bus;

	//M6800 perifpheral control
	output logic e, vma_b; 
	input logic vpa_b;

	//System control
	input logic berr_b;
	output logic reset_b, halt_b;

	//Async control
	output logic as_b, rw_b, uds_b, lds_b;
	input logic dtack_b;

	//Bus Arbitration control
	input logic br_b, bgack_b;
	output logic bg_b;

	//interupt control
	input logic ipl0_b, ipl1_b, ipl2_b;


	//Temp reset
	logic rst_b;
	assign rst_b = 1;

	logic br_true;
	assign br_true = 0;

	//Program Coutner
	logic [31:0] pc, pc_next, branch_target;
	register #(32, 0) programCounter(pc, pc_next, clk, 1'b1, rst_b);
	//Incrementing with branch
	assign branch_target = (size == WORD) ? pc + {16'd0, word_imm_data} + 32'd2 
										  : pc + {24'd0, byte_imm_data} + 32'd2;

	assign pc_next = (branch & br_true) : branch_target : pc + 32'd2;


	//Condition Code Register
	logic [7:0] ccr, ccr_next;
	register #(8, 0) conditionCode(ccr, ccr_next, clk, 1'b1, rst_b);


////////Pipeline stuff//////////
	logic [15:0] data_F, data_D_F, data_E_D_F;
	register #(16, 0) dataDecode(data_D_F, data_F, clk, 1'b1, rst_b);
	register #(16, 0) dataALU(data_E_D_F, data_D_F, clk, 1'b1, rst_b);


///////How imm values are treated//////
/////This is in ALU stage
	logic [31:0] long_imm_data;
	logic [15:0] word_imm_data;
	logic [7:0] byte_imm_data;

	assign long_imm_data = {data_F, data_D_F};
	assign word_imm_data = data_D_F;
	assign byte_imm_data = (branch) ? data_E_D_F : data_D_F[7:0];





	//Register declaration
	//Data Registers
	logic [31:0] D7_out, D6_out, D5_out, D4_out, D3_out, D2_out, D1_out, D0_out;
	logic [31:0] D7_in, D6_in, D5_in, D4_in, D3_in, D2_in, D1_in, D0_in;

	register #(32, 0) d0(D0_out, D0_in, clk, 1'b1, rst_b);
	register #(32, 0) d1(D1_out, D1_in, clk, 1'b1, rst_b);
	register #(32, 0) d2(D2_out, D2_in, clk, 1'b1, rst_b);
	register #(32, 0) d3(D3_out, D3_in, clk, 1'b1, rst_b);
	register #(32, 0) d4(D4_out, D4_in, clk, 1'b1, rst_b);
	register #(32, 0) d5(D5_out, D5_in, clk, 1'b1, rst_b);
	register #(32, 0) d6(D6_out, D6_in, clk, 1'b1, rst_b);
	register #(32, 0) d7(D7_out, D7_in, clk, 1'b1, rst_b);

	//Address Registers
	//A7 is the user stack pointer
	logic [31:0] A7_out, A6_out, A5_out, A4_out, A3_out, A2_out, A1_out, A0_out;
	logic [31:0] A7_in, A6_in, A5_in, A4_in, A3_in, A2_in, A1_in, A0_in;

	register #(32, 0) a0(A0_out, A0_in, clk, 1'b1, rst_b);
	register #(32, 0) a1(A1_out, A1_in, clk, 1'b1, rst_b);
	register #(32, 0) a2(A2_out, A2_in, clk, 1'b1, rst_b);
	register #(32, 0) a3(A3_out, A3_in, clk, 1'b1, rst_b);
	register #(32, 0) a4(A4_out, A4_in, clk, 1'b1, rst_b);
	register #(32, 0) a5(A5_out, A5_in, clk, 1'b1, rst_b);
	register #(32, 0) a6(A6_out, A6_in, clk, 1'b1, rst_b);
	register #(32, 0) a7(A7_out, A7_in, clk, 1'b1, rst_b);



	//This is the decoder area
	logic [15:0] inst;
	logic [3:0] reg1, reg2, reg_dest;
	logic [31:0] reg1_data, reg2_data, reg_dest_data;
	logic branch;

	//register decoder

	always_comb begin
		case(reg1)
			4'b0000: reg1_data = D0_out;
			4'b0001: reg1_data = D1_out;
			4'b0010: reg1_data = D2_out;
			4'b0011: reg1_data = D3_out;
			4'b0100: reg1_data = D4_out;
			4'b0101: reg1_data = D5_out;
			4'b0110: reg1_data = D6_out;
			4'b0111: reg1_data = D7_out;
			4'b1000: reg1_data = A0_out;
			4'b1001: reg1_data = A1_out;
			4'b1010: reg1_data = A2_out;
			4'b1011: reg1_data = A3_out;
			4'b1100: reg1_data = A4_out;
			4'b1101: reg1_data = A5_out;
			4'b1110: reg1_data = A6_out;
			4'b1111: reg1_data = A7_out;
		endcase
		case(reg2)
			4'b0000: reg2_data = D0_out;
			4'b0001: reg2_data = D1_out;
			4'b0010: reg2_data = D2_out;
			4'b0011: reg2_data = D3_out;
			4'b0100: reg2_data = D4_out;
			4'b0101: reg2_data = D5_out;
			4'b0110: reg2_data = D6_out;
			4'b0111: reg2_data = D7_out;
			4'b1000: reg2_data = A0_out;
			4'b1001: reg2_data = A1_out;
			4'b1010: reg2_data = A2_out;
			4'b1011: reg2_data = A3_out;
			4'b1100: reg2_data = A4_out;
			4'b1101: reg2_data = A5_out;
			4'b1110: reg2_data = A6_out;
			4'b1111: reg2_data = A7_out;
		endcase
		case(reg_dest)
			4'b0000: D0_in = reg_dest_data;
			4'b0001: D1_in = reg_dest_data;
			4'b0010: D2_in = reg_dest_data;
			4'b0011: D3_in = reg_dest_data;
			4'b0100: D4_in = reg_dest_data;
			4'b0101: D5_in = reg_dest_data;
			4'b0110: D6_in = reg_dest_data;
			4'b0111: D7_in = reg_dest_data;
			4'b1000: A0_in = reg_dest_data;
			4'b1001: A1_in = reg_dest_data;
			4'b1010: A2_in = reg_dest_data;
			4'b1011: A3_in = reg_dest_data;
			4'b1100: A4_in = reg_dest_data;
			4'b1101: A5_in = reg_dest_data;
			4'b1110: A6_in = reg_dest_data;
			4'b1111: A7_in = reg_dest_data;
		endcase		
	end





///////////////This is the ALU area/////////////////////




endmodule


module alu(data_out, condition_code_out, condition_code_in, opcode, opmode, mode, data_in_1, data_in_2);
	output logic [31:0] data_out;
	output logic [4:0] condition_code_out;
	input logic [4:0] condition_code_in;
	input logic [3:0] opcode;
	input logic [31:0] data_in_1, data_in_2;

	logic [31:0] data_out_addSub, data_out_and;
	logic [4:0] condition_code_addSub;
	logic [3:0] condition_code_and;
	logic add_v_sub;
	add_sub a1(data_out_addSub, condition_code_addSub, data_in_1, data_in_2, add_v_sub);
	ander a2(data_out_and, condition_code_and, data_in_1, data_in_2);

	always_comb begin
		add_v_sub = 0;
		case(opcode)
			ALU_ADD: begin
				data_out = data_out_addSub;
				condition_code_out = condition_code_addSub;
			end
			ALU_AND: begin
				data_out = data_out_and;
				condition_code_out = {condition_code_in[4], condition_code_and};
			end
		endcase
	end

endmodule

module ander(result, ccr, a, b);
	output logic [31:0] result;
	output logic [3:0] ccr;
	input logic [31:0] a, b;

	always_comb begin
		result = a & b;
		ccr[3] = result[31];
		ccr[2] = (result == 32'd0) ? 1 : 0;
		ccr[1] = 0;
		ccr[0] = 0;
	end

endmodule


module add_sub(result, ccr, a, b, a_v_s);
	output logic [31:0] result;
	output logic [4:0] ccr;
	input logic [31:0] a, b;
	input logic a_v_s;
    
    //This is basically doing ccr stuff in addition to an add
	always_comb begin
		ccr[3] = result[31];
		ccr[2] = (result == 32'd0) ? 1 : 0;
		if(a_v_s) ccr[1] = (result > a) ? 1 : 0;
		else ccr[1] = (result < a) ? 1 : 0;
		ccr[4] = ccr[1];
		{ccr[0] , result} = (a_v_s) ? a - b : a + b;
	end

endmodule


module shifter(result, ccr, a, shift, dir, arith_v_logic);
    output logic [31:0] result;
    output logic [4:0] ccr;
    input logic [31:0] a, shift;
    input logic dir, arith_v_logic;

    always_comb begin
        ccr[3] = result[31];
        ccr[1] = result[31] ^ a[31];
    
    end

endmodule


//// Got this from 447 lab
//// register: A register which may be reset to an arbirary value
////
//// q      (output) - Current value of register
//// d      (input)  - Next value of register
//// clk    (input)  - Clock (positive edge-sensitive)
//// enable (input)  - Load new value?
//// reset  (input)  - System reset
////
module register(q, d, clk, enable, rst_b);

	parameter
		 width = 32,
		 reset_value = 0;

	output [(width-1):0] q;
	reg [(width-1):0]    q;
	input [(width-1):0]  d;
	input                 clk, enable, rst_b;
	always @(posedge clk or negedge rst_b)
		if (~rst_b)
			q <= reset_value;
		else if (enable)
			q <= d;

endmodule // register

