module playfield_horizontal(
	output logic [5:0] PFH, //renamed the pf8h, pf16h... to match this
	output logic [7:0] PFX, 
	input logic [8:0] VBD,
	input logic HSCRLD_b,
	input logic MCKR,
	input logic PFHST_b, 
	input logic [7:0] PFSR,
	input logic PR1, PR97, clk_4H
	);

	logic [7:0] VBD_from_10f;

	ls273 PHS_10f(VBD[7:0], HSCRLD_b, 1'b1, VBD_from_10f);

	logic [3:0] PHS_6D_out;
	logic PHS_6D_rip, PHS_6D_ld, PHS_8E_rip;
	logic ls74_q_out;
	assign PHS_6D_ld = ~(~PFHST_b | PHS_6D_rip);

	//This is the ls74 implementation
	always_ff @(posedge HSCRLD_b) begin
		ls74_q_out <= VBD[8];
	end

	ls163a PHS_6D(
		PHS_6D_out,
		PHS_6D_rip,
		{1'b1, VBD_from_10f[2:0]},
		1'b1,
		PHS_6D_ld,
		1'b1,
		1'b1, 
		MCKR
		);

	ls163a PHS_8E(
		PFH[3:0],
		PHS_8E_rip,
		VBD_from_10f[6:3],
		1'b1,
		PFHST_b,
		1'b1,
		1'b1, 
		clk_4H
		);
	logic [1:0] no_one_cares;

	ls163a PHS_9B(
		{no_one_cares, PFH[5:4]},
		,
		{2'b11, ls74_q_out, VBD_from_10f[7]},
		1'b1,
		PFHST_b,
		PHS_8E_rip,
		PHS_8E_rip, 
		clk_4H
		);

    //Still need 5189 and 5273 from devon
    //


endmodule
