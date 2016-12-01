//`include "../lib/LS374.sv"
//`include "../lib/LS378.sv"
//`include "../lib/LS299.sv"
//`include "../lib/AM27529.sv"
//`include "../lib/23256.sv"


module cart(
    input logic SLAP_b, BR_W_b,
    input logic [3:0] ROMOUT_b,
    input logic MATCH_b, MA18_b, P2, MGHF,
    input logic MO_v_PF_b, GLD_b,
    output logic [6:0] MOSR,
    input logic [17:0] MGRA, // GA17-0 which 0 does not exist
    input logic [1:0] MGRI,
    output logic [7:0] PFSR,
    input logic [15:0] MA_from_VMEM, MD_from_VMEM,
    input logic reset, sysclk);

    //////////////PLAYFIELD GRAPHIC DATA MULTIPLEX
	logic [18:0] GRA; //This is GA19-1
	logic [7:0] cart_3b_Q;
	logic [6:0] cart_2a_q;
	logic [5:0] cart_2b_q, cart_1b_y; 
	logic [5:0] MOFD, MOSD, PFFD, PFSD;
	logic PFFLP, MOFLP, LDMO_b, LDPF_b;
	bit [7:0] PFP_b, MOP_b, CPAL_b, NOROM_b, MHOLD_b, PFHOLD_b;

	assign GRA = {MGRI, MGRA[17:1]};
	//These are the ls374 3b and 3a
	always_ff @(posedge sysclk) begin
		PFSR <= cart_3b_Q;
		cart_3b_Q <= {PFP_b[7:6], cart_1b_y};
		MOSR <= cart_2a_q;
		cart_2a_q <= {MOP_b[6], cart_2b_q};
		if(~LDMO_b) 
			{MOP_b[7:6], MHOLD_b[5:4], MOFLP} <= {CPAL_b[7:6], NOROM_b[5:4], MGHF};
		//else 
		//	{MOP_b[7:6], MHOLD_b[5:4], MOFLP} <= {MOP_b[7:6], MHOLD_b[5:4], MOFLP};

		if(~LDPF_b) 
			{PFP_b[7:6], PFHOLD_b[5:4], PFFLP} <= {CPAL_b[7:6], NOROM_b[5:4], MGHF};
		//else 
		//	{PFP_b[7:6], PFHOLD_b[5:4], PFFLP} <= {PFP_b[7:6], PFHOLD_b[5:4], PFFLP};

	end
	//these are the LS157s 1b and 4b THE ORDER OF THE TWO INPUTS COULD BE BACKWARD
	//IE A should be active when B is and visa versa
	assign cart_1b_y = (~PFFLP) ? PFSD[5:0] : PFFD[5:0];
	assign cart_2b_q = (~MOFLP) ? MOSD[5:0] : MOFD[5:0];
	assign LDPF_b = GLD_b | MO_v_PF_b;
	assign LDMO_b = GLD_b | ~MO_v_PF_b;

////////////////SHIFTERS
	//////////This seems odd as they have it never able to shift

	logic [47:0] romData, romData1, romData2;
	logic [14:0] GBA;
	logic [3:0] GCS_b;

	logic MOS0, MOS1, PFS0, PFS1;
	assign MOS1 = ~(LDMO_b & ~MOFLP);
	assign MOS0 = ~(LDMO_b & MOFLP);
	assign PFS0 = ~(LDPF_b & PFFLP);
	assign PFS1 = ~(LDPF_b & ~PFFLP);
	
//////ROMS
	logic [7:0] cart_8a_d, cart_6a_d;

	//This is the logic that decides which bank to load
	always_comb begin
		if(GCS_b == 4'b1110) romData = romData1;
		else if(GCS_b == 4'b1101) romData = romData2;
		else romData = 48'hFFF_FFF;
	end

	am27s29 #("../roms/roms/colorAMD.hex") cart_8a(
		cart_8a_d,
		{MO_v_PF_b, GRA[18:11]},
		sysclk,
		reset);

	am27s29 #("../roms/roms/remapAMD.hex") cart_6a(
		cart_6a_d,
		{MO_v_PF_b, GRA[18:11]},
		sysclk,
		reset);

	control_23256 #("../roms/roms/bank1plane0.hex") cart_12E(
		.data(romData1[7:0]),
		.addr(GBA),
		.clk(sysclk), 
		.reset(reset));

	control_23256 #("../roms/roms/bank2plane0.hex") cart_11E(
		.data(romData2[7:0]),
		.addr(GBA),
		.clk(sysclk), 
		.reset(reset));

	control_23256 #("../roms/roms/bank1plane1.hex") cart_10E(
		.data(romData1[15:8]),
		.addr(GBA),
		.clk(sysclk), 
		.reset(reset));

	control_23256 #("../roms/roms/bank2plane1.hex") cart_9E(
		.data(romData2[15:8]),
		.addr(GBA),
		.clk(sysclk), 
		.reset(reset));
	
	control_23256 #("../roms/roms/bank1plane2.hex") cart_8E(
		.data(romData1[23:16]),
		.addr(GBA),
		.clk(sysclk), 
		.reset(reset));

	control_23256 #("../roms/roms/bank2plane2.hex") cart_7E(
		.data(romData2[23:16]),
		.addr(GBA),
		.clk(sysclk), 
		.reset(reset));
	
	control_23256 #("../roms/roms/bank1plane3.hex") cart_6E(
		.data(romData1[31:24]),
		.addr(GBA),
		.clk(sysclk), 
		.reset(reset));

	control_23256 cart_5E(
		.data(romData2[31:24]),
		.addr(GBA),
		.clk(sysclk), 
		.reset(reset));

	control_23256 #("../roms/roms/bank1plane4.hex") cart_4E(
		.data(romData1[39:32]),
		.addr(GBA),
		.clk(sysclk), 
		.reset(reset));

	control_23256 cart_3E(
		.data(romData2[39:32]),
		.addr(GBA),
		.clk(sysclk), 
		.reset(reset));

	control_23256 cart_2E(
		.data(romData1[47:40]),
		.addr(GBA),
		.clk(sysclk), 
		.reset(reset));

	control_23256 cart_1E(
		.data(romData2[47:40]),
		.addr(GBA),
		.clk(sysclk), 
		.reset(reset));


	assign {NOROM_b[5:4], CPAL_b[7:4]} = (MATCH_b) ? 6'b111_111 : cart_8a_d[5:0];
	assign  GCS_b = (MATCH_b) ? 4'b1111 : cart_6a_d[7:4];

	assign GBA = {cart_6a_d[3:0], GRA[10:0]};




	///////////PHASE 0 SHIFTERS

	ls299 cart_12C(
    	.Q(),
    	.QA(MOFD[0]),
    	.QH(MOSD[0]),
		.D(romData[7:0]), //This needs to be filled in
		.G_b(2'b11), //Set this to 00 to have it able to shift
		.S({MOS1, MOS0}),
    	.CLR_b(~reset), 
    	.SL(1'b0), //It looks like they dont use any of these 
    	.SR(1'b0), 
    	.CK(sysclk));	
	
	ls299 cart_11C(
    	.Q(),
    	.QA(PFFD[0]),
    	.QH(PFSD[0]),
		.D(romData[7:0]), //This needs to be filled in
		.G_b(2'b11), //Set this to 00 to have it able to shift
		.S({PFS1, PFS0}),
    	.CLR_b(~reset), 
    	.SL(1'b0), //It looks like they dont use any of these 
    	.SR(1'b0), 
    	.CK(sysclk));

	///////////PHASE 1 SHIFTERS

	ls299 cart_10C(
    	.Q(),
    	.QA(MOFD[1]),
    	.QH(MOSD[1]),
		.D(romData[15:8]), //This needs to be filled in
		.G_b(2'b11), //Set this to 00 to have it able to shift
		.S({MOS1, MOS0}),
    	.CLR_b(~reset), 
    	.SL(1'b0), //It looks like they dont use any of these 
    	.SR(1'b0), 
    	.CK(sysclk));	
	
	ls299 cart_9C(
    	.Q(),
    	.QA(PFFD[1]),
    	.QH(PFSD[1]),
		.D(romData[15:8]), //This needs to be filled in
		.G_b(2'b11), //Set this to 00 to have it able to shift
		.S({PFS1, PFS0}),
    	.CLR_b(~reset), 
    	.SL(1'b0), //It looks like they dont use any of these 
    	.SR(1'b0), 
    	.CK(sysclk));

	///////////PHASE 2 SHIFTERS

	ls299 cart_8C(
    	.Q(),
    	.QA(MOFD[2]),
    	.QH(MOSD[2]),
		.D(romData[23:16]), //This needs to be filled in
		.G_b(2'b11), //Set this to 00 to have it able to shift
		.S({MOS1, MOS0}),
    	.CLR_b(~reset), 
    	.SL(1'b0), //It looks like they dont use any of these 
    	.SR(1'b0), 
    	.CK(sysclk));	
	
	ls299 cart_7C(
    	.Q(),
    	.QA(PFFD[2]),
    	.QH(PFSD[2]),
		.D(romData[23:16]), //This needs to be filled in
		.G_b(2'b11), //Set this to 00 to have it able to shift
		.S({PFS1, PFS0}),
    	.CLR_b(~reset), 
    	.SL(1'b0), //It looks like they dont use any of these 
    	.SR(1'b0), 
    	.CK(sysclk));

	///////////PHASE 3 SHIFTERS

	ls299 cart_6C(
    	.Q(),
    	.QA(MOFD[3]),
    	.QH(MOSD[3]),
		.D(romData[31:24]), //This needs to be filled in
		.G_b(2'b11), //Set this to 00 to have it able to shift
		.S({MOS1, MOS0}),
    	.CLR_b(~reset), 
    	.SL(1'b0), //It looks like they dont use any of these 
    	.SR(1'b0), 
    	.CK(sysclk));	
	
	ls299 cart_5C(
    	.Q(),
    	.QA(PFFD[3]),
    	.QH(PFSD[3]),
		.D(romData[31:24]), //This needs to be filled in
		.G_b(2'b11), //Set this to 00 to have it able to shift
		.S({PFS1, PFS0}),
    	.CLR_b(~reset), 
    	.SL(1'b0), //It looks like they dont use any of these 
    	.SR(1'b0), 
    	.CK(sysclk));




	//This gets more complex
	///////////PHASE 4-5 SHIFTERS
	logic [7:0] cart_4c_d, cart_2c_d;
	logic [1:0] cart_4c_s, cart_3c_s, cart_2c_s, cart_1c_s;

	assign cart_4c_s[1] = ~(LDMO_b & ~(MHOLD_b[4] & MOFLP));
	assign cart_4c_s[0] = ~(LDMO_b & ~(MHOLD_b[4] & ~MOFLP));
	
	assign cart_3c_s[1] = ~(LDPF_b & ~(PFHOLD_b[4] & PFFLP));
	assign cart_3c_s[0] = ~(LDPF_b & ~(PFHOLD_b[4] & ~PFFLP));

	assign cart_1c_s[1] = ~(LDMO_b & ~(MHOLD_b[5] & MOFLP));
	assign cart_1c_s[0] = ~(LDMO_b & ~(MHOLD_b[5] & ~MOFLP));
	
	assign cart_2c_s[1] = ~(LDPF_b & ~(PFHOLD_b[5] & PFFLP));
	assign cart_2c_s[0] = ~(LDPF_b & ~(PFHOLD_b[5] & ~PFFLP));

	////////////////////
	//The following is what I think is correct but I am unsure about if it is true of the direction
	//or if the values assigned are true
	assign cart_4c_d = (NOROM_b[4]) ? romData[39:32] : {CPAL_b[4], 6'b111_111, CPAL_b[4]};
	assign cart_2c_d = (NOROM_b[5]) ? romData[47:40] : {CPAL_b[5], 6'b111_111, CPAL_b[5]};

	ls299 cart_4C(
    	.Q(),
    	.QA(MOFD[4]),
    	.QH(MOSD[4]),
		.D(cart_4c_d), //This needs to be filled in
		.G_b(2'b11), //Set this to 00 to have it able to shift
		.S(cart_4c_s),
    	.CLR_b(~reset), 
    	.SL(1'b0), //It looks like they dont use any of these 
    	.SR(1'b0), 
    	.CK(sysclk));	
	
	ls299 cart_3C(
    	.Q(),
    	.QA(PFFD[4]),
    	.QH(PFSD[4]),
		.D(cart_4c_d), //This needs to be filled in
		.G_b(2'b11), //Set this to 00 to have it able to shift
		.S(cart_3c_s),
    	.CLR_b(~reset), 
    	.SL(1'b0), //It looks like they dont use any of these 
    	.SR(1'b0), 
    	.CK(sysclk));

	ls299 cart_1C(
    	.Q(),
    	.QA(MOFD[5]),
    	.QH(MOSD[5]),
		.D(cart_2c_d), //This needs to be filled in
		.G_b(2'b11), //Set this to 00 to have it able to shift
		.S(cart_1c_s),
    	.CLR_b(~reset), 
    	.SL(1'b0), //It looks like they dont use any of these 
    	.SR(1'b0), 
    	.CK(sysclk));	
	
	ls299 cart_2C(
    	.Q(),
    	.QA(PFFD[5]),
    	.QH(PFSD[5]),
		.D(cart_2c_d), //This needs to be filled in
		.G_b(2'b11), //Set this to 00 to have it able to shift
		.S(cart_2c_s),
    	.CLR_b(~reset), 
    	.SL(1'b0), //It looks like they dont use any of these 
    	.SR(1'b0), 
    	.CK(sysclk));

endmodule
