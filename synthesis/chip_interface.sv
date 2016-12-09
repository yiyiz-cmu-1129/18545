`default_nettype none

module chip_interface(CLOCK_100, reset, HS, VS,
                      VGA_B, VGA_G, VGA_R);

input logic CLOCK_100, reset;
output logic HS, VS;
output logic [3:0] VGA_B, VGA_G, VGA_R;

//Varialbes for clock generator
logic MCKF, MCKR, HSYNC, VSYNC;
logic VBLANK_b, NXL_b, VRESET_b;
logic VIDBLANK_b;
logic HBLANK_b, CLK_1H, CLK_2H;
logic CLK_2HDL, CLK_4H, CLK_4H_b;
logic CLK_4HDL, CLK_4HDL_b, CLK_4HDD;
logic [2:0] VRAC;
logic [8:0] CLKH;
logic [7:0] CLKV;
logic BUFCLR_b, CLK_4HD3_b, PFHST_b;
logic LMPD_b, VBKINT_b;
logic reset3;

logic [15:0] VIDOUT;
logic [15:0] MD, MDin;
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
logic LDS_b, UDS_b;

logic DTACKn;

//This loads rom
logic SNDINT_b, AJSINT_b;
logic [15:0] meml [131071:0];
logic [15:0] memh [4095:0];
logic [15:0] temph, templ;
bit [7:0] counter;
logic resetN2;
initial $readmemh("../roms/roms/68khrom.hex", memh);
initial $readmemh("../roms/roms/68klromSLIM.hex", meml);
always_ff @(posedge MCKR) begin
    temph <= memh[addr[11:0]];
    templ <= meml[addr[16:0]];
 end

assign VIDBLANK_b = 1'b1; 
assign SNDINT_b = 1'b1;
assign AJSINT_b = 1'b1;
assign VRESET_b = 1'b1;

 always_ff @(posedge MCKR) begin
    if(reset) begin
        counter <= 8'd0;
        resetN2 <= 0;
        PR1 <= 1'b0;
    end
    else if(counter < 8'hff) begin
        resetN2 <= 0;
        counter <= counter + 8'd1;
    end
    else begin
        PR1 <= 1'b1;
        resetN2 <= 1;
    end
 end
    
               
assign MDin = (addr[18]) ? temph : templ;
logic [15:0] data;
logic MEXT_b, AS_b, VRAM_b;
//assign reset3 = reset | resetN2;

vidout VO(.VIDOUT(VIDOUT),
          .CLOCK_100(CLOCK_100),
          .reset(reset),
          .MCKF(MCKF),
          .VIDBLANK_b(VIDBLANK_b),
          .HS(HS),
          .VS(VS),
          .blank_N(),
          .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));

ila2 fuuck(.clk(MCKR),
          .probe0(data),
          .probe1({addr, 1'b0}),
          .probe2(resetN2),
          .probe3({BR_W_b, AS_b, VRAM_b, PR1, MEXT_b, reset}));

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
.UDS_b(UDS_b),
.LDS_b(LDS_b),

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
.MD_to_VMEM(MDin),
.reset(resetN2),

//to sound stuff
.SNDRST_b(), 
.UNLOCK_b(), 
.SYSRES_b(), 
.WL_b(),
.E2PROM_b(), 
.SNDRD_b(), 
.SNDWR_b(),


//Video out
.VIDOUT(VIDOUT),

//Clk
.clk(CLOCK_100),
.PR1(PR1),
//these are testing signals
.addr(addr),
.first(~reset),
.reset3(resetN2),
.DTACKn(DTACKn),
.AS_b(AS_b),
.VRAM_b(VRAM_b),
.MEXT_b(MEXT_b),
.DATA(data)
);

system_clock that_feel(
        .clk100(CLOCK_100), 
        .rst_b(~reset),
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
    .MD_from_VMEM(MDin), /////These are not used 
    .reset(~resetN2), 
    .sysclk(MCKR));



//clock generation
always_ff @(posedge CLK_1H) begin
    CLK_2HDL <= CLK_2H;
    CLK_4HDL_b <= ~CLK_4H;
    CLK_4HDL <= CLK_4H;
    CLK_4HDD <= ~CLK_4HDL_b;
    CLK_4HD3_b <= ~CLK_4HDD;
end

always_comb begin
	CLK_1H = CLKH[0];
	CLK_2H = CLKH[1];
	CLK_4H = CLKH[2];
	CLK_4H_b = ~CLK_4H;
	MCKF = ~MCKR;
		
end

endmodule

