`include "../6502/cpu.v"
`include "../6502/ALU.v"
`include "../POKEY/POKEY.sv"
`include "../POKEY/matoro.sv"
`include "../lib/LS245.sv"
`include "../lib/6116.sv"
`include "../lib/23128.sv"
`include "../lib/LS139.sv"
`include "../lib/LS138.sv"
`include "../lib/LS259.sv"
`include "../lib/Y2151.sv"
`include "../lib/clockFPLA.sv"
`default_nettype none

module io_sound (SC_1H, SC_2H, clk100, SNDRST_b,
                 SDin68k, SDout68k, SNDNMI_b, ctrl_SNDBUF, ctrl_68kBUF, WR68k_b, RD68k_b,
                 SELFTEST_b, coin_aux, coin_l, coin_r);
    input  logic SC_1H; //Clocks the YM2151
    input  logic SC_2H; //SC_2H == phi0 == phi2 == Bphi2
    input  logic clk100; //Not in the original design, specifically for POKEY
    input  logic SNDRST_b;

    //MP Communication Port Signals
    input logic [7:0] SDin68k;
    output logic [7:0] SDout68k;
    input logic SNDNMI_b;
    input logic ctrl_SNDBUF, ctrl_68kBUF;
    output logic WR68k_b, RD68k_b;

    //Coin IO and self test
    input logic SELFTEST_b;
    input logic coin_aux, coin_l, coin_r;




    //Address used mostly in address decoder, nowhere externally
    logic [13:0] SBA; //Sound Address Bus

    //6502
    logic SNDBW;
    logic SNDBW_b;
    logic my6502IRQ_b; //from Music
    tri [7:0] SDin, SDout;
    //Address Decoder
    logic [1:0] my6502toAddrDec;
    logic RAM_CS0_b, RAM_CS1_b;
    logic [2:0] SROM_b;
    logic AddrDecToAddrDec;
    logic [7:0] ls138oneOut;
    logic ls138toSIO, ls138to68k;
    logic SIOWR_b, SIORD_b;
    logic SNDEXT_b; //To cartridge, unused
    logic MXT; //Internal signal, supposed to control comm port and rom/ram tristates, now unused


    //Music
    logic WRphi2, RDphi2;
    logic MUSRES_b;
    logic YMHCS_b;

    //Coin
    logic [7:0] SDinCoin;

    //Sound
    logic CSND_b;
    logic PKS;
    

    //Signals needed to be found
    logic PR101; //God knows
    //Temp till I find it
    assign PR101 = 1;



    ///////////////////////////////////////////////
    /////////I/O and Sound Microprocessor//////////
    ///////////////////////////////////////////////
    
    //These are like this so that they only assert for 1 cycle
    //of the SC_1H clk, which is 2x as fast as the SC_2H
    assign RDphi2 = ~(SC_2H & SNDBW_b);
    assign WRphi2 = ~(SC_2H & ~SNDBW_b);

    //Working in the abstraction that the 6502 controls everything
    //IE things output to the IN line of the 6502 and input from it's OUT line
    //This might not be the case
    cpu my6502(.clk(SC_2H),
               .reset(~SNDRST_b),
               .AB({my6502toAddrDec, SBA}),
               .DI(SDin),
               .DO(SDout),
               .WE(SNDBW), //It passes WE as active high
               .IRQ(~my6502IRQ_b),
               .NMI(~SNDNMI_b),
               .RDY(PR101));

    assign SNDBW_b = ~SNDBW;


    //Enable the connection when doing a WR68k or RD68k
    //This isn't how they do it but should work more clearly
    logic [7:0] SDin68kbuffer; //Buffer for read synchronization
    always_ff @(posedge SC_2H) SDin68kbuffer = (~RD68k_b) ? SDin68k : 8'bzzzz_zzzz;
    assign SDin = SDin68kbuffer;
    

    assign SDout68k = (~WR68k_b) ? SDout68k : 8'bzzzz_zzzz;




    /////////////////////////////////
    //////////Sound Effects//////////
    /////////////////////////////////
    logic [7:0] POKEY_P; //unused
    POKEY myPOKEY(.Din(SDout),
                  .Dout(SDin), //This should drive the 6502 input line
                  .A(SBA[3:0]),
                  .phi2(SC_2H),
                  //Yes, this is the same WE as the 6502
                  //That's what the diagram shows
                  .readHighWriteLow(SNDBW_b),
                  .cs0Bar(CSND_b | ~PR101), //There are 2 CS signals, we just OR them because Demorgans
                  .aud(PKS),
                  //This clk is the 100 MHz clock, and is not a pin on the POKEY DIP
                  .clk(clk100),
                  .P(POKEY_P));
    




    ///////////////////////
    //////////RAM//////////
    ///////////////////////
    control_6116 RAM0(.Dout(SDin),
                      .Din(SDout),
                      .A(SBA[10:0]),
                      .CS_b(RAM_CS0_b),
                      .WE_b(SNDBW_b),
                      .OE_b(1'b0),
                      .clk(SC_2H));
    control_6116 RAM1(.Dout(SDin),
                      .Din(SDout),
                      .A(SBA[10:0]),
                      .CS_b(RAM_CS1_b),
                      .WE_b(SNDBW_b),
                      .OE_b(1'b0),
                      .clk(SC_2H));

    




    /////////////////////////////////////
    //////////Sound Program ROM//////////
    /////////////////////////////////////

    control_23128 #("rom0.hex") rom0(.Dout(SDin),
                                .A(SBA),
                                .CS_b(SROM_b[0]),
                                .OE_b(~SNDBW_b), //This is READ active low
                                .clk(SC_2H),
                                .reset(~SNDRST_b));

    control_23128 #("rom1.hex") rom1(.Dout(SDin),
                                .A(SBA),
                                .CS_b(SROM_b[1]),
                                .OE_b(~SNDBW_b),
                                .clk(SC_2H),
                                .reset(~SNDRST_b));


    control_23128 #("rom2.hex") rom2(.Dout(SDin),
                                .A(SBA),
                                .CS_b(SROM_b[2]),
                                .OE_b(~SNDBW_b),
                                .clk(SC_2H),
                                .reset(~SNDRST_b));






    ///////////////////////////////////
    //////////Address Decoder//////////
    ///////////////////////////////////
    ls139 ls139one(.y({SROM_b, AddrDecToAddrDec}),
                   .g(1'b0),
                   .a(my6502toAddrDec[0]),
                   .b(my6502toAddrDec[1]));

    ls139 ls139two(.y({MXT, SNDEXT_b, RAM_CS1_b, RAM_CS0_b}),
                   .g(AddrDecToAddrDec),
                   .a(SBA[12]),
                   .b(SBA[11]));

    ls138 ls138one(.y(ls138oneOut),
                   .g1(1'b1),
                   .g2(MXT),
                   .a(SBA[4]),
                   .b(SBA[5]),
                   .c(SBA[6]));
    assign CSND_b = ls138oneOut[7];
    assign ls138toSIO = ls138oneOut[2];
    assign ls138to68k = ls138oneOut[1];
    assign YMHCS_b = ls138oneOut[0];

    assign SIOWR_b = ~(~WRphi2 & ~ls138toSIO);
    assign SIORD_b = ~(~RDphi2 & ~ls138toSIO);
    assign WR68k_b = ~(~WRphi2 & ~ls138to68k);
    assign RD68k_b = ~(~RDphi2 & ~ls138to68k);
    




    ///////////////////////
    //////////LED//////////
    ///////////////////////
    logic [7:0] LEDctrl;
    ls259 coin259(.S(SBA[2:0]),
                  .D(SDout[0]),
                  .En_b(SIOWR_b),
                  .Q(LEDctrl),
                  .clr_b(SNDRST_b),
                  .clk(SC_2H));
    assign MUSRES_b = LEDctrl[0];




    /////////////////////////
    //////////COIN///////////
    /////////////////////////

    //The first call to this wants it to return 8'h87 ACCORDING TO MAME
    //This means that ctrl_SNDBUF, an active high signal, should be asserted
    //The code doesnt care, as long as SELFTEST_b is 1, so maybe MAME is wrong
    //TODO: Look into why
    //Actually it's probably active high
    always_ff @(posedge SC_2H) SDinCoin <= (~SIORD_b) ? {SELFTEST_b, 1'b0, 1'b1, ctrl_SNDBUF, ctrl_68kBUF, coin_aux, coin_l, coin_r} : 8'bzzzz_zzzz;
    assign SDin = SDinCoin;



    /////////////////////////
    //////////MUSIC//////////
    /////////////////////////
    logic [7:0] y2151Din, y2151Dinbuffer;
    y2151 musicy2151(.Din(SDout),
                     .Dout(y2151Din),
                     .A0(SBA[0]),
                     .WR_b(WRphi2),
                     .RD_b(RDphi2),
                     .CS_b(YMHCS_b),
                     .IC_b(MUSRES_b),
                     .iRQ_b(my6502IRQ_b),
                     .SO(),
                     .SH1(),
                     .SH2(),
                     .phiM(SC_1H)); //Twice the speed of the 6502 and everything else

    always_ff @(posedge SC_2H) y2151Dinbuffer <= y2151Din;
    assign SDin = y2151Dinbuffer;

endmodule
