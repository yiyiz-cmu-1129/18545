module video_mem(
	output logic [15:0] data_out,
	input logic [15:0] data_in,
	input logic [22:0] address_in, //ALL OF THE ADDRESS SIGNALS ARE DECREMENTED BY 1
	//Example A12 = address_in[11]
	input logic AS_b,
	input logic RAM0_b, RAM1_b,
	input logic WH_b, WL_b, BW_R_b,
	input logic ROM0_b,
	output logic [17:0] MA_out, //This was 16 bits but I am going to get rid of things and just use the mem
	output logic [15:0] MD_out,
	input logic [15:0] MD_in,
    input logic SLAP_b,
    //The clk signal will need to be generated by us
    input logic MCKR);


	logic [7:0] MD10L_out, MD11L_out, MD14L_out, MD15L_out, MD13L_out, MD12L_out;
    logic [15:0] MD_from_CPU;
    tri   [15:0] MD;
	logic G, RAM0, RAM1, BR_W_b;
	always_comb begin
        BR_W_b = ~BW_R_b;
        //These handle the connections of the databus
		RAM0 = ~RAM0_b;
        RAM1 = ~RAM1_b;
		G = address_in[22] | AS_b; //This is the ls32
        //These are the LS244s
		MA_out = {address_in[16:0], 1'b0};
	end
    assign data_out = MD; //I handle the other stuff in graphics with a mux so we dont need
    assign MD_from_CPU = (~G & BW_R_b) ? data_in : 16'bzzzz_zzzz_zzzz_zzzz;

    assign MD[15:8] = MD14L_out;
    assign MD[15:8] = MD15L_out;
    assign MD[7:0] = MD10L_out;
    assign MD[7:0] = MD11L_out;

    assign MD_out = MD;


    comb_6116 VRAM_14L(
        MD_from_CPU[15:8],
        MD14L_out,
        address_in[10:0],
        RAM0_b, //cs_b ////////////////FIXME, I think that the rop line got cutoff, IE I made this RAM0_b instead of RAM0 This seems to have fixed MD breaking
        WH_b, //WE_b
        BW_R_b, //OE_b
        MCKR);
        
    comb_6116 VRAM_15L(
        MD_from_CPU[15:8],
        MD15L_out,
        address_in[10:0],
        RAM1_b, //cs_b
        WH_b, //WE_b
        BW_R_b, //OE_b
        MCKR);

    comb_6116 VRAM_10L(
        MD_from_CPU[7:0],
        MD10L_out,
        address_in[10:0],
        RAM0_b, //cs_b
        WL_b, //WE_b
        BW_R_b, //OE_b
        MCKR);

    comb_6116 VRAM_11L(
        MD_from_CPU[7:0],
        MD11L_out,
        address_in[10:0],
        RAM1_b, //cs_b
        WL_b, //WE_b
        BW_R_b, //OE_b
        MCKR);

/*    NOT NEEDED these are just 00xx0x** addr15-0
    control_23128 VRAM_13L(
        MD13L_out,
        address_in[13:0],
        ROM0_b,
        1'b0,
        clk);

    control_23128 VRAM_12L(
        MD12L_out,
        address_in[13:0],
        ROM0_b,
        1'b0,
        clk);
*/
endmodule
