

module color_ram(
    output logic [15:0] D,      //This should go to the Monitor interface
    output logic [15:0] VBD_out, //Also part of cartarge
    input logic [15:0] VBD_in, //Part of cartargage
    input logic [6:0] MPX,  //Found in Motion Horizontal Line Buffer
    input logic [9:0] MA,   //Comes from video microprocessor Main Memory
    input logic [1:0] GCT,  //Found in Graphics Proirity Control
    input logic [7:0] PFX,  //Found in Playfield Horizontal Scroll
    input logic [2:0] ALC,  //Found in Alphanumerics
    input logic [1:0] APIX, //Found in Alphanumerics
    input logic [1:0] CRAS, //Found in Graphics Proirity Control
    input logic CRAM_b,     //Found in Address Decoder
    input logic CRAMWR_b,   //Found in Address Decoder
    input logic MCKF,       //Found in the System clock and Sync Generator
    input logic BR_W_b, clk);    //Found in the hookups from the 68010 diagram

    logic [6:0] MPX_b;
    logic CR_3c_pin7, CR_3c_pin9;
    logic CR_4c_pin7, CR_4c_pin9;
    logic CR_7c_pin7, CR_7c_pin9;
    logic CR_6c_pin7, CR_6c_pin9;
    logic MCKR;
    assign MCKR = ~MCKF;
    assign MPX_b = ~MPX;

    ls153 cr3c(CR_3c_pin7, 
            CR_3c_pin9, 
            {PFX[2], PFX[6], MPX_b[6], 1'b0},
            {PFX[3], PFX[7], 2'b00},
            1'b0, 
            1'b0,
            GCT);

    ls153 cr4c(CR_4c_pin7, 
            CR_4c_pin9, 
            {PFX[1], PFX[5], MPX_b[5], 1'b0},
            {PFX[0], PFX[4], MPX_b[4], ALC[2]},
            1'b0, 
            1'b0,
            GCT);
    
    ls153 cr7c(CR_7c_pin7, 
            CR_7c_pin9, 
            {MPX_b[3], PFX[3], MPX_b[3], ALC[1]},
            {MPX_b[2], PFX[2], MPX_b[2], ALC[0]},
            1'b0, 
            1'b0,
            GCT);

    ls153 cr6c(CR_6c_pin7, 
            CR_6c_pin9, 
            {MPX_b[1], PFX[1], MPX_b[1], APIX[1]},
            {MPX_b[0], PFX[0], MPX_b[0], APIX[0]},
            1'b0, 
            1'b0,
            GCT);
    logic CRAM;
    logic [7:0] CR_9d_Q;
    
    assign CRAM = ~CRAM_b;

    ls374 cr9d({CR_9d_Q[7], CR_9d_Q[4], CR_9d_Q[0], CR_9d_Q[2], 
            CR_9d_Q[1], CR_9d_Q[3], CR_9d_Q[5], CR_9d_Q[6]},
            {CR_3c_pin9, CR_4c_pin9, CR_6c_pin9, CR_7c_pin9,
            CR_6c_pin7, CR_7c_pin7, CR_4c_pin7, CR_3c_pin7},
            MCKF,
            CRAM);

    logic [9:0] A_2149;
    
    //This takes care of the ls244 which is not really needed
    //This needs to feed into the 2149 ram
    //It is the address for them this should be CRAM NOT CRAM_b but I am having issues so it is CRAM_b now
    assign A_2149 = (CRAM) ? MA : {CRAS, CR_9d_Q};
    logic [15:0] Din, Dout;

    control_2149 cr13D(
    Din[3:0],
    Dout[3:0],
    A_2149,
    1'b0,
    CRAMWR_b,
    MCKF);
    
    control_2149 cr12D(
    Din[7:4],
    Dout[7:4],
    A_2149,
    1'b0,
    CRAMWR_b,
    MCKF);
    
    control_2149 cr10D(
    Din[11:8],
    Dout[11:8],
    A_2149,
    1'b0,
    CRAMWR_b,
    MCKF);

    control_2149 cr11D(
    Din[15:12],
    Dout[15:12],
    A_2149,
    1'b0,
    CRAMWR_b,
    MCKF);

    //This is the LS245 except we cant have inout ports so sad
    assign D = (CRAM & BR_W_b) ? VBD_in : Dout; ///This goes to vidout
    assign Din = VBD_in;
    assign VBD_out = (CRAM & BR_W_b) ? 16'bzzzz_zzzz_zzzz_zzzz : Dout;

endmodule

    
