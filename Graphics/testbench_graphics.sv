module testbench();
graphics GR(
//The following are a bunch of clocks all from the system clock and sync generator
.MCKF, 
.MCKR,
.HSYNC, 
.VSYNC, 
.VBLANK_b, 
.VRESET_b,
.NXL_b, 
.HBLANK_b, 
.CLK_1H,
.CLK_2H, CLK_2HDL, CLK_4H, CLK_4H_b, CLK_4HDL,
input logic CLK_4HDL_b, CLK_4HDD,
input logic [2:0] VRAC,
input logic [7:0] CLKV, CLKH,
input logic BUFCLR_b, CLK_4HD3_b, PFHST_b,
input logic LMPD_b,


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





endmodule

