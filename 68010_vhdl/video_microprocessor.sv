//This is to be packaged as an IP in order to test the chip
module video_microprocessor(
//Outward facing logic
output logic [22:0] A,
output logic [15:0] D_out,
input logic [15:0] D_in,
output logic R_b_Vs_W,
output logic UDS_b,
output logic LDS_b,
output logic AS_b,
input logic MCKR,
input logic SYSRES_b,
input logic SNDINT_b,
input logic VBKINIT_b,
input logic INT3_b, INT1_b,
input logic AJSINT_b,
input logic VRAM_b, VRAC2,
input logic WAIT_b,
input logic IBUS_b,
input logic MEXT_b,
output logic WH_b, WL_b, RL_b,
input logic PRIO1,

output logic BR_W_b,
input logic BW_R_b,

//Logic to the vhdl code
input logic [31:0] ADR_OUT,
input logic [15:0] DATA_OUT,
input logic DATA_EN,
input logic RESET_OUT,
input logic HALT_OUTn,
input logic [2:0] FC_OUT,
input logic ASn,
input logic RWn,
input logic RMCn,
input logic UDSn,
input logic LDSn,
input logic DBENn,
input logic BUS_EN,
input logic E,
input logic VMAn,
input logic VMA_EN,
input logic BGn,


output logic CLK,
output logic [15:0] DATA_IN,
output logic BERRn,
output logic RESET_INn,
output logic HALT_INn,
output logic AVECn,
output logic [2:0] IPLn,
output logic DTACKn,
output logic VPAn,
output logic BRn,
output logic BGACKn,
output logic K6800n
);
    logic AS;

    //68010 code
    assign A = ADR_OUT[23:1];
    assign D_out = DATA_OUT;
    assign DATA_IN = D_in;
    assign CLK = MCKR;
    assign BERRn = PRIO1;
    assign RESET_INn = SYSRES_b;
    assign HALT_INn = SYSRES_b;
    assign AVECn = 1'b0;
    assign VPAn = 1'b0;
    assign BRn = PRIO1;
    assign BGACKn = PRIO1;
    assign K6800n = 1'b0; /////////////////This might need to be 1
    
    //This is the LS20 13h chip
    assign VPAn = ~(AS & FC_OUT[2] & FC_OUT[1] & FC_OUT[0]);
    
    
    //This is the ls368 chip
    assign BR_W_b = ~RWn;
    assign AS = ~ASn;

    //These are the 3 LS32 chips    
    assign WH_b = UDSn | ~BW_R_b;
    assign WL_b = ~BW_R_b | LDSn;
    assign RL_b = LDSn | BW_R_b;



endmodule
