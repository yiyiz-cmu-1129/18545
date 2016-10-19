//This will include the playfield verticle scroll
module video_ram(
	input logic [15:0] MA, //from video memory
	input logic [15:0] VRD_in,
	output logic [15:0] VRD_out,
	input logic [15:0] VBD_in,
	output logic [15:0] VBD_out,
	input logic [15:0] D_in, //This is from the 68k
	output logic [15:0] D_out, //This is to the 68k
	input logic VRAMRD_b, VRAMWR, BR_W_b, //From address decoder
	input logic VRAM_4H_b, MCKR, NXL_b, //Comes from the clock gen
	input logic [2:0] VRAC, //Comes from the clock gen
	input logic [5:0] PFH, //This is {PF256H, PF128H, PF64H, PF32H, PF16H, PF8H}
	input logic VRAM_4HDL, //Comes from the clock gen
	input logic [7:0] SYSCLK_V, //This comes from clock gen and is {128V, 64V, 32V, 16V, 8V, 4V, 2V, 1V}
	input logic [7:0] SYSCLK_H, //This comes from clock gen and is {128H, 64H, 32H, 16H, 8H, 4H, 2H, 1H}
	input logic H01_b,
	output logic [5:0] MN_out,
	input logic [2:0] MPBS, //this comes from the control register

	//For playfield verticle scroll
	output logic [8:0] PP, //This is PP9-PP1
	output logic PP18, PFHFLIP
	input logic VSCRLD_b, VBLANK_b, HSYNC,
	output logic [5:0] PFV //This is {PF256V, PF128V, PF64V, PF32V, PF16V, PF8V}
);
	logic [11:0] ADDR;
	logic [5:0] MN;
	logic [15:0] D, VBD, VRD;
	logic VRAM_14E_out, VRAM_4F_out, VRAM_4K_Y, VRAM_4K_Y_b;

	//This handles the tristate logic
	assign MN_out = MN;
	assign VRD_out = VRD;
	assign VRD = VRD_in;
	assign VBD_out = VBD;
	assign VBD = VBD_in;
	assign D_out = D;
	assign D = D_in;

	//This is the 14E and the 4F
	assign VRAM_4F_out = (MCKR | VRAM_14E_out);
	assign VRAM_14E_out = ~(VRAMWR & VRAC[2]);

	ls153 VR_8F(
		ADDR[11], ADDR[10],
		{MA[12], 1'b1, 1'b0, PFV[5]},
		{MA[11], SYSCLK_V[7], MPBS[2], PFV[4]},
		VRAC[1:0],
		1'b0, 1'b0);

	ls153 VR_5J(
		ADDR[9], ADDR[8],
		{MA[10], SYSCLK_V[6], MPBS[1], PFV[3]},
		{MA[9], SYSCLK_V[5], MPBS[0], PFV[2]},
		VRAC[1:0],
		1'b0, 1'b0);

	ls153 VR_1E(
		ADDR[7], ADDR[6],
		{MA[8], SYSCLK_V[4], VRAM_4HDL, PFV[1]},
		{MA[7], SYSCLK_V[3], H01_b, PFV[0]},
		VRAC[1:0],
		1'b0, 1'b0);

	ls153 VR_2E(
		ADDR[5], ADDR[4],
		{MA[6], SYSCLK_H[7], MN[5], PFH[5]},
		{MA[5], SYSCLK_H[6], MN[4], PFH[4]},
		VRAC[1:0],
		1'b0, 1'b0);

	ls153 VR_4H(
		ADDR[3], ADDR[2],
		{MA[4], SYSCLK_H[5], MN[3], PFH[3]},
		{MA[3], SYSCLK_H[4], MN[2], PFH[2]},
		VRAC[1:0],
		1'b0, 1'b0);

	ls153 VR_10H(
		ADDR[1], ADDR[0],
		{MA[2], SYSCLK_H[3], MN[1], PFH[1]},
		{MA[1], SYSCLK_H[2], MN[0], PFH[0]},
		VRAC[1:0],
		1'b0, 1'b0);

	ls151 VR_4K(
		{1'b0, VRAC[1:0]},
		{4'b1111, MA[13], 2'b11, 1'b0},
		1'b0,
		VRAM_4K_Y,
		VRAM_4K_Y_b);


	logic clk; //THis NEEDS to be generated somewhere
	logic [3:0] VRD_9H, VRD_8H, VRD_7H, VRD_6H, VRD_9J, VRD_8J, VRD_7J, VRD_6J;
	//This is the tristate logic
	assign VRD[3:0] = VRD_9H;
	assign VRD[3:0] = VRD_8H;
	assign VRD[7:4] = VRD_7H;
	assign VRD[7:4] = VRD_6H;
	assign VRD[11:8] = VRD_9J;
	assign VRD[11:8] = VRD_8J;
	assign VRD[15:12] = VRD_7J;
	assign VRD[15:12] = VRD_6J;

	ims1420 VRAM_9H(
		ADDR,
		VRD[3:0],
		VRD_9H,
		VRAM_4F_out,
		VRAM_4K_Y,
		clk);

	ims1420 VRAM_8H(
		ADDR,
		VRD[3:0],
		VRD_8H,
		VRAM_4F_out,
		VRAM_4K_Y_b,
		clk);

	ims1420 VRAM_7H(
		ADDR,
		VRD[7:4],
		VRD_7H,
		VRAM_4F_out,
		VRAM_4K_Y,
		clk);

	ims1420 VRAM_6H(
		ADDR,
		VRD[7:4],
		VRD_6H,
		VRAM_4F_out,
		VRAM_4K_Y_b,
		clk);

	ims1420 VRAM_9J(
		ADDR,
		VRD[11:8],
		VRD_9J,
		VRAM_4F_out,
		VRAM_4K_Y,
		clk);

	ims1420 VRAM_8J(
		ADDR,
		VRD[11:8],
		VRD_8J,
		VRAM_4F_out,
		VRAM_4K_Y_b,
		clk);

	ims1420 VRAM_7J(
		ADDR,
		VRD[15:12],
		VRD_7J,
		VRAM_4F_out,
		VRAM_4K_Y,
		clk);

	ims1420 VRAM_6J(
		ADDR,
		VRD[15:12],
		VRD_7J,
		VRAM_4F_out,
		VRAM_4K_Y_b,
		clk);



endmodule
