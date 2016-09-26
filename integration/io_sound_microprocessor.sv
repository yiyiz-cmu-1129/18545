`include "../6502/cpu.v"
`include "../6502/ALU.v"
`include "../POKEY/POKEY.sv"
`include "../POKEY/matoro.sv"
`include "../lib/LS245.sv"
`include "../lib/6116.sv"
`include "../lib/23128.sv"
`include "../lib/LS139.sv"
`include "../lib/LS138.sv"
`default_nettype none

module io_sound (phi0, SNDRST_b, SNDNMI_b);
    input  logic phi0; //phi0 == phi2 == Bphi2
    input  logic SNDRST_b;
    input  logic SNDNMI_b;

    tri [7:0]  SDin, SDout; //Sound Data into processor and out of
    logic [13:0] SBA; //Sound Address Bus
    
    logic [1:0] my6502toAddrDec;
    logic RAM_CS0_b, RAM_CS1_b;
    logic [2:0] SROM_b;
    logic AddrDecToAddrDec;
    logic [7:0] ls138oneOut;
    logic ls138toSIO, ls138to68k;
    logic MXT;
    logic WRphi2, RDphi2;
    logic CSND_b;
    logic SNDBW;
    logic SNDBW_b;
    logic [7:0] POKEYout;


    assign SNDBW_b = ~SNDBW;

    //Signals needed to be found
    logic PR101;
    logic my6502IRQ_b;
    logic PKS;
    logic YMHCS_b;
    logic SIOWR_b, SIORD_b;
    logic WR68k_b, RD68k_b;
    logic SNDEXT_b;


    //Temp till I find these
    assign PR101 = 1;
    assign my6502IRQ_b = 1;

    assign RDphi2 = ~(phi0 & SNDBW_b);
    assign WRphi2 = ~(phi0 & ~SNDBW_b);

    //Working in the abstraction that the 6502 controls everything
    //IE things output to the IN line of the 6502 and input from it's OUT line
    //This might not be the case
    cpu my6502(.clk(phi0),
               .reset(~SNDRST_b),
               .AB({my6502toAddrDec, SBA}),
               .DI(SDin),
               .DO(SDout),
               .WE(SNDBW),
               .IRQ(~my6502IRQ_b),
               .NMI(~SNDNMI_b),
               .RDY(PR101));

    logic clk; //oh god why
    logic [7:0] POKEY_P; //unused
    POKEY myPOKEY(.Din(SDout),
                  .Dout(/*POKEYout*/),
                  .A(SBA[3:0]),
                  .phi2(phi0),
                  //Yes, this is the same WE as the 6502
                  //That's what the diagram shows
                  .readHighWriteLow(SNDBW_b),
                  .cs0Bar(CSND_b),
                //.cs1(PR101), //This is missing
                  .aud(PKS),
                  //This clk is the 100 MHz clock, and is not a pin on the POKEY DIP
                  //WHAT'S THE RELATIVE TIMING to PHI2
                  .clk(clk),
                  .P(POKEY_P));
    //assign SDin = (~SNDBW_b) ? POKEYout : 8'bzzzz_zzzz; 


    logic [7:0] RAM0datatoMem, RAM1datatoMem; //Memory Interface Signals
    logic [10:0] RAM0addrtoMem, RAM1addrtoMem;
    logic RAM0c_out, RAM1c_out, RAM0_we, RAM1_we, RAM0_en, RAM1_en;
    control_6116 RAM0(.Dout(SDin),
                      .Din(SDout),
                      .A(SBA[10:0]),
                      .CS_b(RAM_CS0_b),
                      .WE_b(SNDBW_b),
                      .OE_b(1'b0),
                      //Unimportant:
                      .data_in(RAM0datatoMem),
                      .addr(RAM0addrtoMem),
                      .data_out(8'b0),
                      .c_out(RAM0c_out), .we(RAM0_we), .en(RAM0_en));
    control_6116 RAM1(.Dout(SDin),
                      .Din(SDout),
                      .A(SBA[10:0]),
                      .CS_b(RAM_CS1_b),
                      .WE_b(SNDBW_b),
                      .OE_b(1'b0),
                      //Unimportant:
                      .data_in(RAM1datatoMem),
                      .addr(RAM1addrtoMem),
                      .data_out(8'b0),
                      .c_out(RAM1c_out), .we(RAM1_we), .en(RAM1_en));


    logic [13:0] ROM0addr, ROM1addr,ROM2addr;
    logic ROM0c_out, ROM1c_out, ROM2c_out;
    control_23128 rom0(.Dout(SDin),
                       .A(SBA),
                       .CS_b(SROM_b[0]),
                       .OE_b(~SNDBW_b), //This is READ active low
                       //Unimportant:
                       .addr(ROM0addr),
                       .data_out(8'b0),
                       .c_out(ROM0c_out));

    control_23128 rom1(.Dout(SDin),
                       .A(SBA),
                       .CS_b(SROM_b[1]),
                       .OE_b(~SNDBW_b),
                       //Unimportant:
                       .addr(ROM1addr),
                       .data_out(8'b0),
                       .c_out(ROM1c_out));


    control_23128 rom2(.Dout(SDin),
                       .A(SBA),
                       .CS_b(SROM_b[2]),
                       .OE_b(~SNDBW_b),
                       //Unimportant:
                       .addr(ROM2addr),
                       .data_out(8'b0),
                       .c_out(ROM2c_out));



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
    
    //Self test logic
    //Comes from the COIN diagram to some extent
    //Very temporary till we figure out what self test is
    logic [7:0] SDinCoin;
    always_ff @(posedge phi0) SDinCoin <= (~SIORD_b) ? 8'h87 : 8'bzzzz_zzzz;
    assign SDin = SDinCoin;


endmodule
