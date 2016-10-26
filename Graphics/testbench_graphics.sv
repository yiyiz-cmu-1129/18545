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
logic [7:0] CLKV, CLKH;
logic BUFCLR_b, CLK_4HD3_b, PFHST_b;
logic LMPD_b;
logic clk;


graphics GR(
//The following are a bunch of clocks all from the system clock and sync generator
.MCKF(MCKF), 
.MCKR(MCKR),
.HSYNC(HSYNC), 
.VSYNC(VSYNC), 
.VBLANK_b(VBLANK_b), 
.VRESET_b(VRESET_b),
.NXL_b(NXK_b), 
.HBLANK_b(HBLANK_b), 
.CLK_1H,
.CLK_2H, 
.CLK_2HDL, 
.CLK_4H, 
.CLK_4H_b, 
.CLK_4HDL,
.CLK_4HDL_b, 
.CLK_4HDD,
.VRAC,
.CLKV, 
.CLKH,
.BUFCLR_b, 
.CLK_4HD3_b, 
.PFHST_b,
.LMPD_b,
.VBKINT_b(),


//Interface with cartarage
.SLAP_b, 
.BR_W_b,
.ROMOUT_b,
.MATCH_b, 
.MA18_b, 
.P2,
.MOSR,
.MGRA,
.MGRI,
.PFSR,
.MA_from_VMEM, 
.MD_from_VMEM,
.MD_to_VMEM,


//to sound stuff
.SNDRST_b, 
.UNLOCK_b, 
.SYSRES_b, 
.WL_b,
.E2PROM_b, 
.SNDRD_b, 
.SNDWR_b,
.SNDINT_b(1'b1),

//to joystick
AJSINT_b(1'b1),

//Video out
.VIDOUT,

//Clk
.clk(clk)
);

always forever #1 clk = ~clk; //this is going to be the base clk

initial begin


end




endmodule

