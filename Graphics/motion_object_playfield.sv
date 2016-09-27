//This is a combined motion playfield and alphanumerics
module motion_playfield(
output logic [19:0] MGRA,
output logic MATCH_b,
output logic LDA_b, LDB_b,
output logic GLD_b,
output logic [1:0] APIX,
output logic [2:0] ALC,
output logic P2,
input logic MCKF,
input logic 4H, 4HDD, 2HDL, 4HDL, PHFLIP,
input logic 1H, 2H,
input logic [15:0] VRD,
input logic [9:0] PP,
input logic VRESET_b
);

    logic 2HDL_b, MOHFLIP, 4HDD_b;
    assign 2HDL_b = ~2HDL;
    assign 4HDD_b = ~4HDD;

    ls374 MOP_9m(MGRA[17:10], VRD[13:6], 2HDL_b, 1'b0);

    logic [3:0] MOP_8l_B_in;
    logic MOP_1a_in;

    ls174 MOP_9k(
        {MOHFLIP, MOP_1a_in, MOP_8l_B_in},
        {VRD[15], VRD[13], VRD[12:9]},
        4HDD_b,
        1'b1);


    logic [3:0] MOP_8l_out;
    logic MOP_8l_cin, MOP_8l_cout;


    //This always comb is 1a, 13h, and 1d


                
//ls283 is a 4bit adder

endmodule

