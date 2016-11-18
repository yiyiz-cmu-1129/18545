`include "../integration/system_clock.sv"
`include "graphics.sv"
`include "cart.sv"
`include "../lib/clockFPLA.sv"

module testbench();

//Varialbes for clock generator
logic MCKF, MCKR, HSYNC, VSYNC;
logic VBLANK_b, VRESET_b, NXL_b;
logic HBLANK_b, CLK_1H, CLK_2H;
logic CLK_2HDL, CLK_4H, CLK_4H_b;
logic CLK_4HDL, CLK_4HDL_b, CLK_4HDD;
logic [2:0] VRAC;
logic [8:0] CLKH;
logic [7:0] CLKV;
logic BUFCLR_b, CLK_4HD3_b, PFHST_b;
logic LMPD_b, VBKINT_b;
logic clk, reset, reset3;

logic [15:0] VIDOUT;
logic [15:0] MD;
logic [17:0] MA;
logic BR_W_b;
logic [22:0] addr;
logic PR1;

logic SLAP_b, MATCH_b, MA18_b, MGHF, P2, GLD_b, PFSC_v_MO, VBKACK_b;
logic [3:0] ROMOUT_b;
logic [6:0] MOSR;
logic [7:0] PFSR;
logic [1:0] MGRI;
logic [17:0] MGRA;


//This loads rom
reg [15:0] mem[8388608:0];
logic first;
always_ff @(posedge MCKR, posedge first) begin
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
.VBKACK_b(VBKACK_b),

//Interface with cartarage
.SLAP_b(SLAP_b), 
.BR_W_b(BR_W_b),
.ROMOUT_b(ROMOUT_b),
.MATCH_b(MATCH_b), 
.MA18_b(MA18_b), 
.P2(P2),
.MGHF(MGHF),
.PFSC_V_MO(PFSC_v_MO), 
.GLD_b(GLD_b),
.MOSR(MOSR),
.MGRA(MGRA),
.MGRI(MGRI),
.PFSR(PFSR),
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
        .VBKACK_b(VBKACK_b),
        .MCKR(MCKR),
        .SC_1H(CLKH[0]),
        .SC_2H(CLKH[1]),
        .SC_4H(CLKH[2]), 
        .SC_8H(CLKH[3]),
        .SC_16H(CLKH[4]),
        .SC_32H(CLKH[5]),
        .SC_64H(CLKH[6]),
        .SC_128H(CLKH[7]), 
        .SC_256H(CLKH[8]),
        .PFHST_b(PFHST_b),
        .BUFCLR_b(BUFCLR_b),
        .NXL_b(),
        .LMPD_b(LMPD_b),
        .HBLANK_b(HBLANK_b),
        .HSYNC(HSYNC),
        .NXL_b_star(NXL_b),
        .VRAC(VRAC),
        .SC_1V(CLKV[0]),
        .SC_2V(CLKV[1]),
        .SC_4V(CLKV[2]),
        .SC_8V(CLKV[3]), 
        .SC_16V(CLKV[4]),
        .SC_32V(CLKV[5]),
        .SC_64V(CLKV[6]), 
        .SC_128V(CLKV[7]),
        .VBLANK_b(VBLANK_b),
        .VBKINT_b(VBKINT_b),
        .VSYNC(VSYNC)
        );

cart last_hope(
    .SLAP_b(SLAP_b), 
    .BR_W_b(BR_W_b),
    .ROMOUT_b(ROMOUT_b),
    .MATCH_b(MATCH_b), 
    .MA18_b(MA18_b), 
    .P2(P2), 
    .MGHF(MGHF),
    .MO_v_PF_b(PFSC_v_MO),
    .GLD_b(GLD_b),
    .MOSR(MOSR),
    .MGRA(MGRA), // GA19-1 I think a typo was found
    .MGRI(MGRI), //this is not really needed
    .PFSR(PFSR),
    .MA_from_VMEM(MA[15:0]), /////These are not used 
    .MD_from_VMEM(), /////These are not used 
    .reset(~reset), 
    .sysclk(MCKR));

initial forever #5 clk = ~clk; //this is going to be the base clk

always @(/*posedge MCKR*/ VID) begin
    //$display("%t, ADR: %x Data:%x, Dout %x, Din %x, DTACK %b, reset %b, VID: %x, WH_b %b, WL_b %b, UDSn %b", 
   // 	$time, addr, GR.DATA, MD, mem[addr], GR.VM_68.DTACKn, GR.reset, VIDOUT, GR.WH_b, GR.WL_b, GR.VM_68.UDSn);
    //$display("Data_from_VRAM: %x, Data_from_VMEM: %x, Data_from_68k: %x", GR.Data_from_VRAM, GR.Data_from_VMEM, GR.Data_from_68k);

    //for debugging vram
    //$display("VBD: %x, VBUS_b: %b, VBDA: %x, BR_W_b: %b, VBD_in: %x, VRAMRD_b: %b", GR.Grap_VR.VBD, GR.Grap_VR.VBUS_b, GR.Grap_VR.VBDA, GR.Grap_VR.BR_W_b, GR.Grap_VR.VBD_in, GR.Grap_VR.VRAMRD_b);
    //$display("VBD: %x, VBUS:%b, VRAMRD %b, VRAMWR %b, VRAM %b", GR.VBD, GR.VBUS_b, GR.VRAMRD_b, GR.VRAMWR, GR.VM_68.VRAM_b);
    $display("ADR_OUT: %x, DATA: %x, VID: %x, VBD: %b, A_2149: %b, CRAMWR_b: %b, GBA: %x GPCout:%04b GPCin:%08b", 
        GR.VM_68.ADR_OUT, GR.DATA, GR.VIDOUT, GR.VBD, GR.Grap_sad.A_2149, GR.CRAMWR_b, last_hope.GBA, GR.Grap_MP.GPC_3E_Y, {GR.Grap_MP.A_3F_Q[5], GR.Grap_MP.APIX[1:0], GR.Grap_MP.GPC_8c_out, GR.Grap_MP.PFSC, GR.Grap_MP.GPC_1c_out, GR.Grap_MP.MPX[7], GR.Grap_MP.MPX[0]});
    //$display("VBD %x, VRD: %x, AD:%b, CRAS %b",
    //    GR.VBD, GR.Grap_MP.VRD, GR.Grap_sad.A_2149, GR.CRAS);
    //$display("MA:%x, Din %x, CRAMWR_b %b, VBD_in: %x, Dout: %x",
    //    GR.Grap_sad.MA, GR.Grap_sad.Din, GR.Grap_sad.CRAMWR_b, GR.Grap_sad.VBD_in, GR.Grap_sad.Dout);
    



    //$display("PHS_4D_in: %b, PFSR: %b, ADR:%b, VRD:%x", 
    //    GR.Grap_PH.PHS_4D_in, GR.Grap_PH.PFSR, GR.Grap_PH.PHS_6D_out, GR.Grap_MP.VRD);




    $display("MPX %b, MOSR: %b, BR_W_b: %b, LDSn %b, UDSn %b CRAM_b %01b", 
        GR.Grap_MP.MPX, GR.MOSR, GR.BR_W_b, GR.VM_68.LDSn, GR.VM_68.UDSn, GR.VM_68.CRAM_b);
/*
    $display("MOP_8m_pin9_out: %b, GPC_3E_Y: %b, PFX: %b, MPX: %b", 
        GR.Grap_MP.MOP_8m_pin9_out, GR.Grap_MP.GPC_3E_Y, GR.Grap_MP.PFX, GR.Grap_MP.MPX);
    $display("A_5F_D: %b, H03_b: %b, MOP_2H: %b, MOP_1H: %b, A_3F_Q: %b", 
        GR.Grap_MP.A_5F_D, GR.Grap_MP.H03_b, GR.Grap_MP.MOP_2H, GR.Grap_MP.MOP_1H, GR.Grap_MP.A_3F_Q);
//For debuging vmem
    //$display("MD: %x, MD_in: %x, MD12L_out: %x, MD_from_CPU: %x, data_out: %x, G: %b",
     //GR.Grap_VM.MD, GR.Grap_VM.MD_in, GR.Grap_VM.MD15L_out, GR.Grap_VM.MD_from_CPU, GR.Grap_VM.data_out, GR.Grap_VM.G);
*/
end 


//clock generation
logic temp;
always_ff @(posedge CLK_1H) begin
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
    #30000 reset = 1'b1;
    #1000 PR1 = 1'b1;
    #6000;
    reset3 = 1'b1;
    #2000000000; 
    $display("Buffer %x", GR.Grap_hope.buffer);
    #1000;
    $stop;
    
end

always_comb begin
	CLK_1H = CLKH[0];
	CLK_2H = CLKH[1];
	CLK_4H = CLKH[2];
	CLK_4H_b = ~CLK_4H;
	MCKF = ~MCKR;
		
end

endmodule

