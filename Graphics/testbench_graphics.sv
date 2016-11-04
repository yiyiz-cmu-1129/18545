`include "../integration/system_clock.sv"
`include "graphics.sv"

module testbench();

//Varialbes for clock generator
logic MCKF, MCKR, HSYNC, VSYNC;
logic VBLANK_b, VRESET_b, NXL_b;
logic HBLANK_b, CLK_1H, CLK_2H;
logic CLK_2HDL, CLK_4H, CLK_4H_b;
logic CLK_4HDL, CLK_4HDL_b, CLK_4HDD;
logic [2:0] VRAC;
logic [8:0] CLKV, CLKH;
logic BUFCLR_b, CLK_4HD3_b, PFHST_b;
logic LMPD_b, VBKINT_b;
logic clk, reset, reset3;

logic [15:0] VIDOUT;
logic [15:0] MD;
logic [15:0] MA;
logic BR_W_b;
logic [22:0] addr;
logic PR1;
//This loads rom
reg [15:0] mem[8388608:0];
logic first;
always_ff @(posedge clk, posedge first) begin
    if(first) $readmemh("../roms/68kmem.hex", mem);
    else if(~BR_W_b & PR1) mem[addr] <= MD;
end

graphics GR(
//The following are a bunch of clocks all from the system clock and sync generator
.MCKF(MCKF), 
.MCKR(MCKR),
.HSYNC(HSYNC), 
.VSYNC(VSYNC), 
.VBLANK_b(VBLANK_b), 
.VRESET_b(VRESET_b),
.NXL_b(NXL_b), 
.HBLANK_b(HBLANK_b), 
.CLK_1H(CLK_1H),
.CLK_2H(CLK_2H), 
.CLK_2HDL(CLK_2HDL), 
.CLK_4H(CLK_4H), 
.CLK_4H_b(CLK_4H_b), 
.CLK_4HDL(CLK_4HDL),
.CLK_4HDL_b(CLK_4HDL_b), 
.CLK_4HDD(CLK_4HDD),
.VRAC(VRAC),
.CLKV(CLKV[7:0]), 
.CLKH(CLKH[7:0]),
.BUFCLR_b(BUFCLR_b), 
.CLK_4HD3_b(CLK_4HD3_b), 
.PFHST_b(PFHST_b),
.LMPD_b(LMPD_b),
.VBKINT_b(VBKINT_b),


//Interface with cartarage
.SLAP_b(), 
.BR_W_b(BR_W_b),
.ROMOUT_b(),
.MATCH_b(), 
.MA18_b(), 
.P2(),
.MOSR(7'h3F),
.MGRA(),
.MGRI(),
.PFSR(8'h55),
.MA_from_VMEM(MA), 
.MD_from_VMEM(MD),
.MD_to_VMEM(mem[addr]),
.reset(reset),

//to sound stuff
.SNDRST_b(), 
.UNLOCK_b(), 
.SYSRES_b(), 
.WL_b(),
.E2PROM_b(), 
.SNDRD_b(), 
.SNDWR_b(),
.SNDINT_b(1'b1),

//to joystick
.AJSINT_b(1'b1),

//Video out
.VIDOUT(VIDOUT),

//Clk
.clk(clk),
.PR1(PR1),
//these are testing signals
.addr(addr),
.first(first),
.reset3(reset3)

);
logic rst;
system_clock that_feel(
	.clk100(clk), 
	.rst_b(rst),
	.SC_1H(CLKH[0]),
	.SC_2H(CLKH[1]),
	.SC_4H(CLKH[2]),
	.SC_8H(CLKH[3]),
    .SC_16H(CLKH[4]),
    .SC_32H(CLKH[5]),
    .SC_64H(CLKH[6]),
    .SC_128H(CLKH[7]), 
    .SC_256H(CLKH[8]));

initial forever #5 clk = ~clk; //this is going to be the base clk

always @(posedge CLK_1H) begin
    //$display("%t, ADR: %x Data:%x, Dout %x, Din %x, DTACK %b, reset %b, VID: %x, WH_b %b, WL_b %b, UDSn %b", 
   // 	$time, addr, GR.DATA, MD, mem[addr], GR.VM_68.DTACKn, GR.reset, VIDOUT, GR.WH_b, GR.WL_b, GR.VM_68.UDSn);
    //$display("Data_from_VRAM: %x, Data_from_VMEM: %x, Data_from_68k: %x", GR.Data_from_VRAM, GR.Data_from_VMEM, GR.Data_from_68k);

    //for debugging vram
    //$display("VBD: %x, VBUS_b: %b, VBDA: %x, BR_W_b: %b, VBD_in: %x, VRAM11k: %x, VRAMRD_b: %b", GR.Grap_VR.VBD, GR.Grap_VR.VBUS_b, GR.Grap_VR.VBDA, GR.Grap_VR.BR_W_b, GR.Grap_VR.VBD_in, GR.Grap_VR.VRAM_11K_Q, GR.Grap_VR.VRAMRD_b);
    //$display("VBD: %x, VBUS:%b, VRAMRD %b, VRAMWR %b, VRAM %b", GR.VBD, GR.VBUS_b, GR.VRAMRD_b, GR.VRAMWR, GR.VM_68.VRAM_b);
    $display("ADR_OUT: %x, DATA: %x, VID: %x", GR.VM_68.ADR_OUT, GR.DATA, GR.VIDOUT);
    $display("VBD %x, VBD: %x, AD:%b, CRAS %b", 
        GR.VBD, GR.VBD_From_VRAM, GR.Grap_sad.A_2149, GR.CRAS);
    //$display("MA:%x, CRAM %b, CRAS %b, CR_9d_Q: %x",
    //    GR.Grap_sad.MA, GR.Grap_sad.CRAM, GR.Grap_sad.CRAS, GR.Grap_sad.CR_9d_Q);
    //$display("GPC_3E_Y: %b, Ti: %b, ls74reg:%b, VRD:%x", 
    //    GR.Grap_MP.GPC_3E_Y, GR.Grap_MP.TI, GR.Grap_MP.ls74reg, GR.Grap_MP.VRD);



////////////////VRD VRD VRD VRD VRD VRD VRD VRD THIS IS THE ROOT OF ALL EVIL!!!!/////////////

///////////////////ALL OF THE ISSUES ARE A RESULT OF IT

    $display("MPX %b, CRAM_b: %b, BR_W_b: %b", 
        GR.Grap_MP.MPX, GR.MOSR, GR.BR_W_b);
    $display("VRD: %x, PVS_6B_out: %b, VSCRLD_b: %b, PFV: %x", 
        GR.VRD, GR.Grap_VR.PVS_6B_out, GR.Grap_VR.VSCRLD_b, GR.Grap_VR.PFV);

//For debuging vmem
    //$display("MD: %x, MD_in: %x, MD12L_out: %x, MD_from_CPU: %x, data_out: %x, G: %b",
     //GR.Grap_VM.MD, GR.Grap_VM.MD_in, GR.Grap_VM.MD15L_out, GR.Grap_VM.MD_from_CPU, GR.Grap_VM.data_out, GR.Grap_VM.G);
end 


//clock generation
logic temp;
always_ff @(posedge MCKR) begin
    CLK_2HDL <= CLK_2H;
    CLK_4HDL_b <= ~CLK_4H;
    CLK_4HDL <= CLK_4H;
    CLK_4HDD <= ~CLK_4HDL_b;
    CLK_4HD3_b <= ~CLK_4HDD;
end

initial begin
	clk = 1'b0;
    reset = 1'b0;
    reset3 = 1'b0;
    first = 1'b1;
    rst = 1'b0;
    PR1 = 1'b0;
    #10 rst = 1'b1;
    first = 0;
    #15000 reset = 1'b1;
    #1000 PR1 = 1'b1;
    #6000;
    reset3 = 1'b1;
    #1000000 $stop;
    
end

always_comb begin
	CLK_1H = CLKH[0];
	CLK_2H = CLKH[1];
	CLK_4H = CLKH[2];
	CLKV = CLKH;
	CLK_4H_b = ~CLK_4H;
	MCKR = CLK_1H;
	MCKF = ~CLK_1H;
	

	//These are the signals we have no idea   FIX ME
	VSYNC = CLKH[3];
	HSYNC = CLKH[4];
	VBKINT_b = CLKH[3];
	VBLANK_b = CLKH[2];
	HBLANK_b = CLKH[0];
	BUFCLR_b = CLKH[5];
	PFHST_b = 1'b1;
	LMPD_b = CLKH[2];
    NXL_b = CLKH[1];
	VRAC = {CLKH[3], CLKH[2], CLKH[1]};	
end

endmodule

