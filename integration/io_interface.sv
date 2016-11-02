`include "../lib/LS374.sv"
`include "../lib/2804A.sv"
`include "../lib/letaBFM.sv"
`default_nettype none

module io_interface(Din68k, Dout68k, A,
                    SC_1H, SC_8H, SYSRES_b, SNDRST_b,
                    Dout6502, Din6502,
                    SNDWR_b, SNDRD_b, WR68k_b, RD68k_b,
                    ctrl_68kBUF, ctrl_SNDBUF,
                    SNDNMI_b, SNDINT_b,
                    WL_b, UNLOCK_b, E2PROM_b, IBUS_b, BW_b,
                    RLETA_b, TBTEST, TBRE_b);
    //Global
    input logic [22:0] A;
    input logic [7:0] Dout68k; //Out of the 68k
    output logic [7:0] Din68k; //In to the 68k
    input logic SC_1H, SC_8H;
    input logic SYSRES_b, SNDRST_b;
    
    //MP Communication Ports
    input logic [7:0] Dout6502;
    output logic [7:0] Din6502;
    input logic SNDWR_b, SNDRD_b;
    input logic WR68k_b, RD68k_b;
    output logic ctrl_68kBUF, ctrl_SNDBUF; //Tells us when there's data in the buffer ready to be read by 6502 or 68k, respectively
    output logic SNDNMI_b, SNDINT_b; //Interupts for the 6502 and 68k, respectively

    //NOVRAM
    input logic WL_b;
    input logic UNLOCK_b;
    input logic E2PROM_b;
    input logic IBUS_b, BW_b;

    //TrakBall
    input logic RLETA_b;
    input logic TBTEST;
    input logic TBRE_b;

    //Internal Signals
    tri [7:0] IBDout, IBDin; //Main Bus, correspond to the directions of the 68k
    logic LS74_Q_b, OE_2804_b;

    
    ///////////////////////////////////////
    //////////Non-Volatile Memory//////////
    ///////////////////////////////////////

    //LS74
    always_ff @(posedge SC_1H) begin
        if (~WL_b) begin
            if (~SYSRES_b)
                LS74_Q_b <= 0;
            else if (~UNLOCK_b)
                LS74_Q_b <= 1;
        end
    end

    assign OE_2804_b = LS74_Q_b & SYSRES_b; //AND for active low is an OR

    control_2804 eeprom(.A(A[10:0]),
                        .Din(IBDout),
                        .Dout(IBDin),
                        .CE_b(E2PROM_b),
                        .OE_b(OE_2804_b),
                        .WE_b(WL_b),
                        .clk(SC_1H),
                        .rst_b(SYSRES_b));

    //LS245
    assign Din68k = (IBUS_b & BW_b) ? IBDin : 8'bzzzz_zzzz;
    assign IBDout = (IBUS_b & ~BW_b) ? Dout68k : 8'bzzzz_zzzz;


    ///////////////////////////////////////////
    //////////Trak-Ball[TM] Interface//////////
    ///////////////////////////////////////////


    letaBFM BillFuckingMurray(.DB(IBDin),
                              .CS(RLETA_b),
                              .CK(SC_8H),
                              .TEST(TBTEST),
                              .AD(A[1:0]),
                              .RESOLN(TBRE_b),
                              .rst_b(SYSRES_b)); //TODO: The actual LETA doesnt have this line



    //////////////////////////////////////////
    //////////MP COMMUNICATION PORTS//////////
    //////////////////////////////////////////

    //This is the control for the handshaking between the 6502 and the 68k
    
    //This set controls the 68k writing to the sound processor
    //The 68k loads the values of the 374 with the data it wants to send to the 6502
    //It at the same time asserts SNDWR_b to trigger a SNDNMI_b
    //The 6502 then responds to this in its interrupt handler and reads the data
    //To signal that it is reading the data it asserts RD68k_b, which outputs the data and resets the NMI signal

    //LS74one
    always_ff @(posedge SNDWR_b, negedge RD68k_b) begin
        if (~RD68k_b) begin
            ctrl_68kBUF <= 1'b0;
            SNDNMI_b <= 1'b1;
        end
        else if (~SNDWR_b & RD68k_b) begin
            ctrl_68kBUF <= 1'b1;
            SNDNMI_b <= 1'b0;
        end
    end

    ls374 ls374one(.Q(IBDout),
                   .D(Din6502),
                   .clk(SNDWR_b),
                   .OC_b(RD68k_b));

    //This set controls the 6502 writing to the video processor
    //The 6502 asserts WR68k_b to write to the 374 the data it wants to sent
    //This also sets the SNDINT_b interrupt signal for the 68k
    //The 68k responds by asserting SNDRD_b to read the data out from the 374 and reset the interrupt

    //LS74two
    always_ff @(posedge WR68k_b, negedge (SNDRD_b & SNDRST_b)) begin //AND of two active low signals is an OR for active highs
        if (~(SNDRD_b & SNDRST_b)) begin
            ctrl_SNDBUF <= 1'b0;
            SNDINT_b <= 1'b1;
        end
        else if (~WR68k_b & (SNDRD_b & SNDRST_b)) begin
            ctrl_SNDBUF <= 1'b1;
            SNDINT_b <= 1'b0;
        end
    end

    ls374 ls374two(.Q(IBDin),
                   .D(Dout6502),
                   .clk(WR68k_b),
                   .OC_b(SNDRD_b));
endmodule
