//This will include the playfield verticle scroll and the control register

module video_ram(
	input logic [15:0] MA, //from video memory
	output logic [15:0] VRD_out,
	input logic [15:0] VBD_in,
	output logic [15:0] VBD_out,
	input logic [15:0] D_in, //This is from the 68k
	output logic [15:0] D_out, //This is to the 68k
	input logic VRAMRD_b, VRAMWR, BR_W_b, //From address decoder
	input logic VRAM_4H_b, MCKR, NXL_b, VRAM_4HDL_b, //Comes from the clock gen
	input logic [2:0] VRAC, //Comes from the clock gen
	input logic [5:0] PFH, //This is {PF256H, PF128H, PF64H, PF32H, PF16H, PF8H}
	input logic VRAM_4HDL, //Comes from the clock gen
	input logic [7:0] SYSCLK_V, //This comes from clock gen and is {128V, 64V, 32V, 16V, 8V, 4V, 2V, 1V}
	input logic [7:0] SYSCLK_H, //This comes from clock gen and is {128H, 64H, 32H, 16H, 8H, 4H, 2H, 1H}
	input logic H01_b,
	output logic [5:0] MN_out,

	//For playfield verticle scroll
	output logic [8:0] PP, //This is PP9-PP1
	output logic PP18, PFHFLIP,
	input logic VSCRLD_b, VBLANK_b, HSYNC, VBUS_b,
	output logic [5:0] PFV, //This is {PF256V, PF128V, PF64V, PF32V, PF16V, PF8V}

    //For control register
    output logic SNDRST_b, TBTEST, PP19, TBRES_b, ALBNK,
    input logic SYSRES_b, MISC_b, clk
);

	logic [11:0] ADDR;
	logic [5:0] MN;
	logic [15:0] D, VBD, VRD;
	logic VRAM_14E_out, VRAM_4F_out, VRAM_4K_Y, VRAM_4K_Y_b;
    logic [2:0] MPBS;

	//This handles the tristate logic
	assign MN_out = MN;
	assign VRD_out = VRD;
	assign VBD_out = VBD;
	

	//This is the 14E and the 4F
	assign VRAM_4F_out = (MCKR | VRAM_14E_out);
	assign VRAM_14E_out = ~(VRAMWR & VRAC[2]);

	ls153 VR_8F(
		ADDR[11], ADDR[10],
		{MA[12], 1'b1, 1'b0, PFV[5]},
		{MA[11], SYSCLK_V[7], MPBS[2], PFV[4]},
		1'b0, 1'b0,
        VRAC[1:0]);

	ls153 VR_5J(
		ADDR[9], ADDR[8],
		{MA[10], SYSCLK_V[6], MPBS[1], PFV[3]},
		{MA[9], SYSCLK_V[5], MPBS[0], PFV[2]},
		1'b0, 1'b0,
        VRAC[1:0]);

	ls153 VR_1E(
		ADDR[7], ADDR[6],
		{MA[8], SYSCLK_V[4], VRAM_4HDL, PFV[1]},
		{MA[7], SYSCLK_V[3], H01_b, PFV[0]},
		1'b0, 1'b0,
        VRAC[1:0]);

	ls153 VR_2E(
		ADDR[5], ADDR[4],
		{MA[6], SYSCLK_H[7], MN[5], PFH[5]},
		{MA[5], SYSCLK_H[6], MN[4], PFH[4]},
		1'b0, 1'b0,
        VRAC[1:0]);

	ls153 VR_4H(
		ADDR[3], ADDR[2],
		{MA[4], SYSCLK_H[5], MN[3], PFH[3]},
		{MA[3], SYSCLK_H[4], MN[2], PFH[2]},
		1'b0, 1'b0,
        VRAC[1:0]);

	ls153 VR_10H(
		ADDR[1], ADDR[0],
		{MA[2], SYSCLK_H[3], MN[1], PFH[1]},
		{MA[1], SYSCLK_H[2], MN[0], PFH[0]},
		1'b0, 1'b0,
        VRAC[1:0]);

	ls151 VR_4K(
		{4'b1111, MA[13], 2'b11, 1'b0},
		{1'b0, VRAC[1:0]},
		VRAM_4K_Y,
		VRAM_4K_Y_b,
        1'b0);


	logic [3:0] VRD_9H, VRD_8H, VRD_7H, VRD_6H, VRD_9J, VRD_8J, VRD_7J, VRD_6J;
	//This is the tristate logic
	logic [15:0] VRD_mem_out, VRD_mem_outA, VRD_mem_outB, VRDM;
	assign VRD_mem_out = (VRAM_4K_Y_b) ? VRD_mem_outA : VRD_mem_outB;
	assign VRDM = (VRAM_4F_out) ? VRD_mem_out : 16'bzzzz_zzzz_zzzz_zzzz;
	assign VRD_mem_outA[3:0] = VRD_9H;
	assign VRD_mem_outB[3:0] = VRD_8H;
	assign VRD_mem_outA[7:4] = VRD_7H;
	assign VRD_mem_outB[7:4] = VRD_6H;
	assign VRD_mem_outA[11:8] = VRD_9J;
	assign VRD_mem_outB[11:8] = VRD_8J;
	assign VRD_mem_outA[15:12] = VRD_7J;
	assign VRD_mem_outB[15:12] = VRD_6J;

	ims1420 VRAM_9H(
		ADDR,
		VRD[3:0], //in
		VRD_9H,   //out
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
		VRD_6J,
		VRAM_4F_out,
		VRAM_4K_Y_b,
		clk);

    logic [7:0] VRAM_11K_Q, VRAM_11H_Q;
    logic [15:0] VBDA;
    assign VBDA[15:0] = (VRAMRD_b) ? VBD_in : {VRAM_11K_Q, VRAM_11H_Q};

    //This is very odd, as they use E_b instead of the clk
    //This could be using logic as the clk ////////////////////LOOK INTO//////////////////
    ls373 VRAM_11K(
        VRAM_11K_Q,
        VRD[15:8],
        VRAC[2], //This is labled as E_b but should be clk
        VRAMRD_b);

    ls373 VRAM_11H(
        VRAM_11H_Q,
        VRD[7:0],
        VRAC[2], //This is labled as E_b but should be clk
        VRAMRD_b);

    //These are the LS244 chips
    assign VRD = (~VRAM_14E_out) ? VBD : VRDM;
    
    //These are the LS245 chips
    assign VBD = (~VBUS_b & ~BR_W_b) ? D_in : VBDA;
    assign D_out = (~VBUS_b & BR_W_b) ? VBD : 16'bzzzz_zzzz_zzzz_zzzz;

    ls174 VRAM_5K(
        MN,
        VRD[5:0],
        NXL_b,
        VRAM_4H_b);
    
    /////////////////////////////////////////////////////Playfield Vertical Scroll//////////////////////////////////////////////
    
    logic PVS_6B_out;
    logic PVS_9F_RC, PVS_9E_RC;
    assign PVS_6B_out = VBLANK_b & HSYNC;
    ls273 PVS_7K(
        {VRD[15:14], VRD[5:0]},
        VRAM_4HDL_b,
        1'b1,
        {PFHFLIP, PP18, PP[8:3]});
    
    ls191 PVS_9F(
        1'b0,
        1'b0,
        PVS_6B_out,
        VSCRLD_b,
        VBD[0], VBD[1], VBD[2], VBD[3],
        , PVS_9F_RC,
        PP[0], PP[1], PP[2], PFV[0]); //PP1, PP2, PP3, PF8V

    ls191 PVS_9E(
        PVS_9F_RC,
        1'b0,
        PVS_6B_out,
        VSCRLD_b,
        VBD[4], VBD[5], VBD[6], VBD[7],
        , PVS_9E_RC,
        PFV[1], PFV[2], PFV[3], PFV[4]); //PF16V, PF32V, PF64V, PF128V

    ls191 PVS_7B(
        PVS_9E_RC,
        1'b0,
        PVS_6B_out,
        VSCRLD_b,
        VBD[8], 1'b1, 1'b1, 1'b1,
        , ,
        PFV[5], , , ); //PF256V

////////////////Control Register///////////////////////
    ls273 CR_10E(
        VBD[7:0],
        MISC_b,
        SYSRES_b,
        {SNDRST_b, TBTEST, MPBS[2:0], PP19, TBRES_b, ALBNK});

endmodule
