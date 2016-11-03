`include "../lib/LS138.sv"
`include "../lib/LS139.sv"
`include "../lib/LS148.sv"
`include "../lib/LS151.sv"
`include "../lib/LS153.sv"
`include "../lib/LS163A.sv"
`include "../lib/LS174.sv"
`include "../lib/LS189.sv"
`include "../lib/LS191.sv"
`include "../lib/LS194.sv"
`include "../lib/LS197.sv"
//`include "../lib/LS245.sv"
`include "../lib/LS257.sv"
`include "../lib/LS259.sv"
`include "../lib/LS273.sv"
`include "../lib/LS368A.sv"
`include "../lib/LS373.sv"
`include "../lib/LS374.sv"
`include "../lib/LS378.sv"
`include "../lib/2149.sv"
`include "../lib/23128.sv"
`include "../lib/6116.sv"
`include "../lib/82S129.sv"
`include "../lib/IMS1420.sv"
`include "color_ram.sv"
`include "motion_object_playfield.sv"
`include "playfield_horizontal_scroll.sv"
`include "video_ram.sv"
`include "video_mem.sv"
`include "../68010_vhdl/video_microprocessor.sv"
`default_nettype none


module graphics(
//The following are a bunch of clocks all from the system clock and sync generator
input logic MCKF, MCKR,
input logic HSYNC, VSYNC, VBLANK_b, VRESET_b,
input logic NXL_b, HBLANK_b, CLK_1H, /////////////////The NXL_b may need to be hooked to the NXL_b*
input logic CLK_2H, CLK_2HDL, CLK_4H, CLK_4H_b, CLK_4HDL,
input logic CLK_4HDL_b, CLK_4HDD,
input logic [2:0] VRAC,
input logic [7:0] CLKV, CLKH,
input logic BUFCLR_b, CLK_4HD3_b, PFHST_b,
input logic LMPD_b, VBKINT_b,


//Interface with cartarage
output logic SLAP_b, BR_W_b,
output logic [3:0] ROMOUT_b,
output logic MATCH_b, MA18_b, P2,
input logic [6:0] MOSR,


output logic [17:0] MGRA,
output logic [1:0] MGRI,
input logic [7:0] PFSR,

output logic [15:0] MA_from_VMEM, MD_from_VMEM,
input logic [15:0] MD_to_VMEM,


//to sound stuff
output logic SNDRST_b, UNLOCK_b, SYSRES_b, WL_b,
output logic E2PROM_b, SNDRD_b, SNDWR_b,
input logic SNDINT_b,

//to joystick
input logic AJSINT_b,

//Video out
output logic [15:0] VIDOUT,

//Clk
input logic clk
);

logic [22:0] Addr_68k;
logic [15:0] Data_to_68k, Data_from_68k, Data_to_VRAM, Data_from_VRAM, Data_to_VMEM, Data_from_VMEM;
logic [3:0] ROM_b;
logic UDS_b, LDS_b, AS_b, R_b_Vs_W;
logic VRAMRD_b, VRAMWR;

logic [15:0] VRD_from_VRAM, VBD_From_VRAM, VBD_To_VRAM;
logic PFSPC_b, MGHF;
logic RAM0_b, RAM1_b, WH_b, RL_b, BCS_b;
logic WAIT_b, BW_R_b, VSCRLD_b;
logic MISC_b, CRAMWR_b, CRAM_b, HSCRLD_b;

logic [5:0] PFH_from_PH, PFV_from_VR;
logic [7:0] PFX_from_PH, MPX_from_MOP;
logic ALBNK, PFHFLIP;
logic [8:0] PP_from_VR;

logic [1:0] GCT_from_MOP, CRAS, APIX;
logic [2:0] ALC;
logic [15:0] VBD_to_CRAM, VBD_from_CRAM;
logic PFSC_V_MO, H01_b;

logic [1:0] PPI;
logic INT3_b, INT1_b, PRIO1, PR1, VBKACK_b, WDOG_b;
logic VBUS_b;

assign ROMOUT_b = ROM_b;

assign INT3_b = 1'b1;
assign INT1_b = 1'b1;
assign PRIO1 = 1'b1;
assign PR1 = 1'b1;


//The following is a bunch of tristate stuff which wont work :(
logic [15:0] DATA;

always_comb begin
    if(~VBUS_b & BR_W_b) DATA = Data_from_VRAM;
    else if(~(Addr_68k[22] | AS_b) & BW_R_b) DATA = Data_from_VMEM;
    else DATA = Data_from_68k;
end
assign Data_to_68k = DATA;
assign Data_to_VRAM = DATA;
assign Data_to_VMEM = DATA;

logic [15:0] VBD;


assign VBD = (~CRAM_b & BW_R_b) ? VBD_From_VRAM : VBD_from_CRAM; //I am puting the mux out here because I hate tristates
assign VBD_to_CRAM = VBD;
assign VBD_To_VRAM = VBD;



video_microprocessor VM_68(
    //Outward facing logic
    .A(Addr_68k),
    .D_out(Data_from_68k),
    .D_in(Data_to_68k),
    .R_b_Vs_W(R_b_Vs_W),
    .UDS_b(UDS_b),
    .LDS_b(LDS_b),
    .AS_b(AS_b),
    .MCKR(MCKR),
    .SYSRES_b(SYSRES_b),
    .SNDINT_b(SNDINT_b),
    .VBKINIT_b(VBKINT_b), //I am not sure where this comes from
    .INT3_b(INT3_b), //I am not sure where this comes from
    .INT1_b(INT1_b), //I am not sure where this comes from
    .AJSINT_b(AJSINT_b),
    .VRAC2(VRAC[2]),
    .WAIT_b(WAIT_b),
    .WH_b(WH_b),
    .WL_b(WL_b),
    .RL_b(RL_b),
    .PRIO1(PRIO1), //I am not sure where this comes from
    .PR1(PR1), //I am not sure where this comes from
    .BR_W_b(BR_W_b),
    .BW_R_b(BW_R_b),
    .CRAMWR_b(CRAMWR_b),
    .CRAM_b(CRAM_b),
    .RAM1_b(RAM1_b), 
    .RAM0_b(RAM0_b),
    .VRAMWR(VRAMWR), 
    .VRAMRD_b(VRAMRD_b),
    .MA18_b(MA18_b),
    .UNLOCK_b(UNLOCK_b), 
    .VBKACK_b(VBKACK_b), 
    .WDOG_b(WDOG_b), 
    .MISC_b(MISC_b), 
    .VBUS_b(VBUS_b),
    .PFSPC_b(PFSPC_b),
    .VSCRLD_b(VSCRLD_b), 
    .HSCRLD_b(HSCRLD_b), 
    .SLAP_b(SLAP_b), 
    .SNDRD_b(SNDRD_b),//The following are all outputs that I am not connecting
    .SNDWR_b(SNDWR_b), 
    .INPUT_b(), 
    .RAJs_b(), 
    .RAJs(), 
    .RLETA_b(),
    .E2PROM_b(E2PROM_b),
    .ROM_b(ROM_b)
);


video_ram Grap_VR(
	.MA(MA_from_VMEM), //from video memory
	.VRD_out(VRD_from_VRAM),
	.VBD_in(VBD_To_VRAM),
	.VBD_out(VBD_From_VRAM),
	.D_in(Data_to_VRAM), //This is from the 68k
	.D_out(Data_from_VRAM), //This is to the 68k
	.VRAMRD_b(VRAMRD_b), //From 68k
	.VRAMWR(VRAMWR), //From 68k
	.BR_W_b(BR_W_b), //From address decoder
	.VRAM_4H_b(CLK_4H_b), 
	.MCKR(MCKR), 
	.NXL_b(NXL_b), 
	.VRAM_4HDL_b(CLK_4HDL_b), //Comes from the clock gen
	.VRAC(VRAC), //Comes from the clock gen
	.PFH(PFH_from_PH), //This is {PF256H, PF128H, PF64H, PF32H, PF16H, PF8H}
	.VRAM_4HDL(CLK_4HDL), //Comes from the clock gen
	.SYSCLK_V(CLKV), //This comes from clock gen and is {128V, 64V, 32V, 16V, 8V, 4V, 2V, 1V}
	.SYSCLK_H(CLKH), //This comes from clock gen and is {128H, 64H, 32H, 16H, 8H, 4H, 2H, 1H}
	.H01_b(H01_b),
	.MN_out(), //I dont see this used anywhere

	//For playfield verticle scroll
	.PP(PP_from_VR), //This is PP9-PP1
	.PP18(PPI[0]),     //This is actually PPI8
	.PFHFLIP(PFHFLIP),
	.VSCRLD_b(VSCRLD_b), 
	.VBLANK_b(VBLANK_b), 
	.HSYNC(HSYNC), 
	.VBUS_b(VBUS_b), //I am not sure where this comes from
	.PFV(PFV_from_VR), //This is {PF256V, PF128V, PF64V, PF32V, PF16V, PF8V}

    //For control register
    .SNDRST_b(SNDRST_b), 
    .TBTEST(), 
    .PP19(PPI[1]),  //This is actually PPI9
    .TBRES_b(), 
    .ALBNK(ALBNK),
    .SYSRES_b(SYSRES_b), 
    .MISC_b(MISC_b),
    .clk(clk)
);

video_mem Grap_VM(
	.data_out(Data_from_VMEM),
	.data_in(Data_to_VMEM),
	.address_in(Addr_68k), //ALL OF THE ADDRESS SIGNALS ARE DECREMENTED BY 1
	//Example A12 = address_in[11]
	.AS_b(AS_b),
	.RAM0_b(RAM0_b), 
    .RAM1_b(RAM1_b),
	.WH_b(WH_b), 
    .WL_b(WL_b), 
    .BW_R_b(BW_R_b),
	.ROM0_b(ROM_b[0]),
	.MA_out(MA_from_VMEM),
	.MD_out(MD_from_VMEM),
	.MD_in(MD_to_VMEM),
    //The clk signal will need to be generated by us
    .clk(clk));

playfield_horizontal Grap_PH(
	.PFH(PFH_from_PH), //renamed the pf8h, pf16h... to match this
	.PFX(PFX_from_PH), 
	.VBD(VBD[8:0]), //9 bits
	.HSCRLD_b(HSCRLD_b),
    .MCKR(MCKR),
    .MCKF(MCKF),
	.PFHST_b(PFHST_b), 
	.PFSR(PFSR), //8 bits comes from cartarage
	.PR1(1'b1), 
    .PR97(1'b1), 
    .clk_4H(CLK_4H),
    .PFSPC_b(PFSPC_b),
    .PFSC_V_MO(PFSC_V_MO),
    .clk(clk) 
	);

motion_playfield Grap_MP(
    .MGRA(MGRA), //18 bits also to cartargage
    .MGRI(MGRI), //This is the MGRI9 and MGRI8 pins to cartarage
    .MATCH_b(MATCH_b), //To cartarage
    .GLD_b(), //This 1 bit out might not be used
    .APIX(APIX), // 2 bits
    .ALC(ALC), //3 bits
    .P2(P2), 
    .H01_b(H01_b),
    .MCKF(MCKF),
    .PR27(1'b1), 
    .MCKR(MCKR),
    .PR1(1'b1), 
    .PR80(1'b1), 
    .PR97(1'b1),
    .MOP_4H(CLK_4H), 
    .MOP_4HDD(CLK_4HDD), 
    .MOP_2HDL(CLK_2HDL), 
    .MOP_4HDL(CLK_4HDL), 
    .PHFLIP(PFHFLIP), ///////////Im assuming these are the same signal 
    .MOP_4HD3_b(CLK_4HD3_b),
    .MOP_1H(CLK_1H), 
    .MOP_2H(CLK_2H), 
    .BUFCLR_b(BUFCLR_b), 
    .VRD(VRD_from_VRAM),
    .PP({PP_from_VR, 1'b0}), //10 bits in but does not use pp0
    .PPI(PPI), //This is PPI9 and PPI8
    .MOSR(MOSR), //7bits to cartarage
    .VRESET_b(VRESET_b),

//Additional signals for the Motion Object Horizontal Line Buffer
    .LMPD_b(LMPD_b),
    .ACS_b(),//These are internal 
    .BCS_b(BCS_b), 
    .CLRA_b(), //These are internal
    .CLRB_b(), //These are internal

//Graphic Priority Control
    .CRAS(CRAS), //2bits
    .GCT(GCT_from_MOP), //2 bits 
    .PFX(PFX_from_PH[7:3]), //This is PFX7-3 From Playfield Hor
    .MPX(MPX_from_MOP), //8 bits From Playfield Vert
    .PFSC(PFSC_V_MO),

//This is for alphanumerics
    .ALBNK(ALBNK), //From Control Register
    .MGHF(MGHF),
    .clk(clk)
);


color_ram Grap_sad(
    .D(VIDOUT),      //This should go to the Monitor interface
    .VBD_out(VBD_from_CRAM), //Also part of cartarge 16 bit
    .VBD_in(VBD_to_CRAM), //Part of cartargage 16 bit
    .MPX(MPX_from_MOP[6:0]),  //Found in Motion Horizontal Line Buffer
    .MA(MA_from_VMEM[10:1]),   //Comes from video microprocessor Main Memory
    .GCT(GCT_from_MOP),  //Found in Graphics Proirity Control
    .PFX(PFX_from_PH),  //Found in Playfield Horizontal Scroll
    .ALC(ALC),  //Found in Alphanumerics
    .APIX(APIX), //Found in Alphanumerics
    .CRAS(CRAS), //Found in Graphics Proirity Control
    .CRAM_b(CRAM_b),     //Found in Address Decoder
    .CRAMWR_b(CRAMWR_b),   //Found in Address Decoder
    .MCKF(MCKF),       //Found in the System clock and Sync Generator
    .BR_W_b(BR_W_b),
    .clk(clk));    //Found in the hookups from the 68010 diagram


endmodule