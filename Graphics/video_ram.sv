//This will include the playfield verticle scroll and the control register

module video_ram(
	input logic [17:0] MA, //from video memory
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
    input logic rst,
	//For playfield verticle scroll
	output bit [8:0] PP, //This is PP9-PP1
	output logic PP18, PFHFLIP,
	input logic VSCRLD_b, VBLANK_b, HSYNC, VBUS_b,
	output bit [5:0] PFV, //This is {PF256V, PF128V, PF64V, PF32V, PF16V, PF8V}

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
	assign VRAM_4F_out = ~VRAMWR;
	assign VRAM_14E_out = ~(VRAMWR & VRAC[2]);

	always_comb begin
        ADDR = MA[12:1]; //VRAC can suck it, it also needs the PFV and PFH part but fuck it
        /*
		case(VRAC[1:0]) //This is not supposed to be negated but I am doing it anyway
			2'b00: ADDR = {PFV[5:0], PFH[5:0]};
			2'b01: ADDR = {1'b0, MPBS[2:0], VRAM_4HDL, H01_b, MN[5:0]};
			2'b10: ADDR = {1'b1, SYSCLK_V[7:3], SYSCLK_H[7:2]};
			2'b11: ADDR = MA[12:1];
		endcase
        */
	end

    /*
	ls151 VR_4K(
		{4'b1111, MA[13], 2'b11, 1'b0},
		{1'b0, VRAC[1:0]},
		VRAM_4K_Y,
		VRAM_4K_Y_b,
        1'b0);
*/

    //VRAC SUCKS
    assign VRAM_4K_Y = MA[13];
    assign VRAM_4K_Y_b = ~MA[13];

	logic [3:0] VRD_9H, VRD_8H, VRD_7H, VRD_6H, VRD_9J, VRD_8J, VRD_7J, VRD_6J;
	//This is the tristate logic
	logic [15:0] VRD_mem_out, VRD_mem_outA, VRD_mem_outB, VRDM;
	
	ims1420 VRAM_9H(
		ADDR,
		VRD[3:0], //in
		VRD_9H,   //out
		VRAM_4F_out,
		VRAM_4K_Y,
		MCKR);

	ims1420 VRAM_8H(
		ADDR,
		VRD[3:0],
		VRD_8H,
		VRAM_4F_out,
		VRAM_4K_Y_b,
		MCKR);

	ims1420 VRAM_7H(
		ADDR,
		VRD[7:4],
		VRD_7H,
		VRAM_4F_out,
		VRAM_4K_Y,
		MCKR);

	ims1420 VRAM_6H(
		ADDR,
		VRD[7:4],
		VRD_6H,
		VRAM_4F_out,
		VRAM_4K_Y_b,
		MCKR);

	ims1420 VRAM_9J(
		ADDR,
		VRD[11:8],
		VRD_9J,
		VRAM_4F_out,
		VRAM_4K_Y,
		MCKR);

	ims1420 VRAM_8J(
		ADDR,
		VRD[11:8],
		VRD_8J,
		VRAM_4F_out,
		VRAM_4K_Y_b,
		MCKR);

	ims1420 VRAM_7J(
		ADDR,
		VRD[15:12],
		VRD_7J,
		VRAM_4F_out,
		VRAM_4K_Y,
		MCKR);

	ims1420 VRAM_6J(
		ADDR,
		VRD[15:12],
		VRD_6J,
		VRAM_4F_out,
		VRAM_4K_Y_b,
		MCKR);

    logic [7:0] VRAM_11K_Q, VRAM_11H_Q;
    logic [15:0] VBDA, VBDB, VRDC, VBDC;


    always_comb begin
        if(~VRAMRD_b) VBD = VRD;
        else if(~VBUS_b & ~BR_W_b) VBD = D_in;
        else VBD = VBD_in;

        if(VRAMWR) VRD = VBD;
        else VRD = (VRAM_4K_Y_b) ? VRD_mem_outA : VRD_mem_outB;
        
    end
    //assign VBDA[15:0] = (VRAMRD_b) ? VBD_in : VBDB;

    //assign VRD = (rst) ? VRDC : 16'd0;




	assign VRD_mem_outA[3:0] = VRD_9H;
	assign VRD_mem_outB[3:0] = VRD_8H;
	assign VRD_mem_outA[7:4] = VRD_7H;
	assign VRD_mem_outB[7:4] = VRD_6H;
	assign VRD_mem_outA[11:8] = VRD_9J;
	assign VRD_mem_outB[11:8] = VRD_8J;
	assign VRD_mem_outA[15:12] = VRD_7J;
	assign VRD_mem_outB[15:12] = VRD_6J;

/*
    always_latch begin
    	if(~VRAC[2]) VBDB <= VRD;
    end
*/
    //These are the LS244 chips
 //   assign VRDC = (~VRAM_14E_out) ? VBD : VRDM;
    
    //These are the LS245 chips
     assign D_out = VBD;

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
