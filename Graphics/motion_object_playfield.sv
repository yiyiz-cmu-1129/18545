//This is a combined motion playfield and alphanumerics
module motion_playfield(
output logic [9:0] MGRA,
output logic [1:0] MGRI, //This is the MGRI9 and MGRI8 pins
output logic MATCH_b,
output logic LDA_b, LDB_b,
output logic GLD_b, ACS_b, BCS_b,
output logic [1:0] APIX,
output logic [2:0] ALC,
output logic P2, H01_b;
input logic MCKF, PR27,
input logic MOP_4H, MOP_4HDD, MOP_2HDL, MOP_4HDL, PHFLIP,
input logic MOP_1H, MOP_2H, BUFCLR_b, LPMD_b,
input logic [15:0] VRD,
input logic [9:0] PP,
input logic [1:0] PPI, //This is PPI9 and PPI8
input logic [6:0] MOSR,
input logic VRESET_b
);

    logic [11:0] MM; //This include MMI9 and MMI8
    logic MOP_2HDL_b, MOHFLIP, MOP_4HDD_b;
    logic MOP_4HDL_b;

    assign MOP_2HDL_b = ~MOP_2HDL;
    assign MOP_4HDD_b = ~MOP_4HDD;
    assign MOP_4HDL_b = ~MOP_4HDL;

    ls374 MOP_9m(MGRA[17:10], VRD[13:6], MOP_2HDL_b, 1'b0);

    logic [3:0] MOP_8l_B_in;
    logic MOP_1a_in;

    ls174 MOP_9k(
        {MOHFLIP, MOP_1a_in, MOP_8l_B_in},
        {VRD[15], VRD[13], VRD[12:9]},
        MOP_4HDD_b,
        1'b1);


    logic [3:0] MOP_8l_out, MOP_5l_b_in, MOP_7l_a_in, MOP_7l_out;
    logic [3:0] MOP_6f_a_in;
    logic MOP_8l_cout, MOP_5l_cout, MOP_7l_b0, MOP_7l_cout;
    logic MOP_4f_in;
    ls273 MOP_6k(
        {VRD[8:5], VRD[3:0]}, 
        MOP_4HDD_b, 
        1'b1, 
        {MOP_5l_b_in, MOP_7l_a_in});


    ls273 MOP_8k(
        {VRD[15:14], VRD[5:0]},
        MOP_4HDL,
        1'b1, 
        {MM[11:10], MM[9], MOP_4f_in, MOP_6f_a_in});

    logic dnc1, dnc2, dnc3, MOP_4j_pin6;
    logic MOP_1a_3, MOP_1a_8, MOP_4f_in2, MOP_13h_out;

    ls139 MOP_4j(
        {dnc1, MOP_4j_pin6, H01_b, GLD_b},
        1'b0,
        MOP_1H, 
        MOP_2H);

    ls139 MOP_3d(
        {dnc2, dnc3, LDA_b, LDB_b},
        MOP_4j_pin6,
        MOP_4H,
        PADB);


    always_comb begin
        {MOP_8l_cout, MOP_8l_out} = 5'b01111 + {1'b0, MOP_8l_B_in} + {4'b0000, MOP_5l_cout};
        {MOP_5l_cout, MOP_7l_b0, MM[3:1]} = 5'b01111 + {1'b0, MOP_5l_b_in} + 5'b00001;
        {MOP_7l_cout, MOP_7l_out} =  {1'b0, MOP_7l_a_in} + {1'b0, MOP_8l_out[2:0], MOP_7l_b0} + 5'b00001;
        {MOP_4f_in2, MM[7:4]} = {1'b0, MOP_7l_out} + {1'b0, MOP_6f_a_in};
        MOP_1a_3 = VRESET_b ^ MOP_1a_in;//1a
        MOP_1a_8 = MOP_1a_3 ^ MOP_8l_cout;//1a
        MOP_13h_out = ~(MOP_7l_cout & MOP_8l_out[3] & MOP_1a_8);//13h
        MATCH_b = MOP_4HDL & MOP_13h_out; //1d
        MM[8] = MOP_4f_in | MOP_4f_in2; //4f
    end


    logic MOP_8m_pin9_out; //This feeds into the alphanumerics
    //These are the LS257's which are just muxes
    //8m
    assign {MOP_8m_pin9_out, MGRI, MGRA[9]} = (MOP_4HDL_b) ? {PHFLIP, PPI, PP[9]} : {MOHFLIP, MM[11:9]};
    //7m
    assign MGRA[8:5] = (MOP_4HDL_b) ? PP[8:5] : MM[8:5];
    //6m
    assign MGRA[4:1] = (MOP_4HDL_b) ? PP[4:1] : MM[4:1];



/////////////////////Motion Object Horizontal Line Buffer Control//////////////////




////////////////////ALPHANUMERICS/////////////////////////////////

////////////////////Graphic Priority Control//////////////////////




endmodule

