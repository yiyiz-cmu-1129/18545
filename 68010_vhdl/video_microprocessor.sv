//This is to be packaged as an IP in order to test the chip
`default_nettype none

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
input logic VRAC2,
input logic WAIT_b,
output logic WH_b, WL_b, RL_b,
input logic PRIO1, PR1,
output logic BR_W_b,
input logic BW_R_b,
output logic CRAMWR_b,
output logic CRAM_b,
output logic RAM1_b, RAM0_b,
output logic VRAMWR, VRAMRD_b, MA18_b,
output logic UNLOCK_b, VBKACK_b, WDOG_b, MISC_b, VBUS_b, PFSPC_b,
output logic VSCRLD_b, HSCRLD_b, SLAP_b, SNDRD_b,
output logic SNDWR_b, INPUT_b, RAJs_b, RAJs, RLETA_b,
output logic E2PROM_b,
output logic [3:0] ROM_b
);
//Logic to the vhdl code
logic [31:0] ADR_OUT;
logic [15:0] DATA_OUT;
logic DATA_EN;
logic RESET_OUT;
logic HALT_OUTn;
logic [2:0] FC_OUT;
logic ASn;
logic RWn;
logic RMCn;
logic UDSn;
logic LDSn;
logic DBENn;
logic BUS_EN;
logic E;
logic VMAn;
logic VMA_EN;
logic BGn;
logic IBUS_b;
logic VRAM_b;
logic MEXT_b;
logic CLK;
logic [15:0] DATA_IN;
logic BERRn;
logic RESET_INn;
logic HALT_INn;
logic AVECn;
logic [2:0] IPLn;
logic DTACKn;
logic VPAn;
logic BRn;
logic BGACKn;
logic K6800n;
logic VRDTACK_b;

    logic AS;



    logic dontcare, noonecares;
    logic [2:0] dnc;
    logic qd_12m, rip_12m, c_12m, out_13e;

    //68010 code
    WF68K10_TOP PRO(.CLK(CLK), 
        .ADR_OUT(ADR_OUT), 
        .DATA_IN(DATA_IN), 
        .DATA_OUT(DATA_OUT),
        .DATA_EN(DATA_EN),
        .BERRN(BERRn),
        .RESET_INN(RESET_INn),
        .RESET_OUT(RESET_OUT),
        .HALT_INN(HALT_INn),
        .HALT_OUTN(HALT_OUTn),
        .FC_OUT(FC_OUT),
        .AVECN(AVECn),
        .IPLN(IPLn),
        .DTACKN(DTACKn), 
        .ASN(ASn),
        .RWN(RWn),
        .RMCN(RMCn),
        .UDSN(UDSn),
        .LDSN(LDSn),
        .DBENN(DBENn),
        .BUS_EN(BUS_EN),
        .E(E),
        .VMAN(VMAn),
        .VMA_EN(VMA_EN),
        .VPAN(VPAn),
        .BRN(BRn),
        .BGN(BGn),
        .BGACKN(BGACKn),
        .K6800N(K6800n));

    assign A = ADR_OUT[23:1];
    assign D_out = DATA_OUT;
    assign DATA_IN = D_in;
    assign CLK = MCKR;
    assign BERRn = PRIO1;
    assign RESET_INn = SYSRES_b;
    assign HALT_INn = SYSRES_b;
    assign AVECn = 1'b0;
    assign BRn = PRIO1;
    assign BGACKn = PRIO1;
    assign K6800n = 1'b0; /////////////////This might need to be 1
    assign AS_b = ASn;
    //This is the LS20 13h chip
    assign VPAn = ~(AS & FC_OUT[2] & FC_OUT[1] & FC_OUT[0]);
    
    
    //This is the ls368 chip
    assign BR_W_b = ~RWn;
    assign AS = ~ASn;
    //These are the 3 LS32 chips    
    assign WH_b = UDSn | ~BW_R_b;
    assign WL_b = ~BW_R_b | LDSn;
    assign RL_b = LDSn | BW_R_b;
    
    ls148 VM_14h(IPLn[2:0], 
            dontcare, 
            noonecares, 
            {1'b1, SNDINT_b, 1'b1, VBKINIT_b, INT3_b, AJSINT_b, INT1_b, 1'b1},
            1'b0);
    
    /////////////////574 This is the ls74////////////////////
    logic Q_574, Q_574_b;
    assign Q_574_b = ~Q_574;
    always_ff @(posedge VRAC2) begin
        if(~PR1) Q_574 <= 1'b0;
        else if(AS_b) Q_574 <= VRAM_b;
        else Q_574 <= Q_574;
    end

    assign VRDTACK_b = Q_574;
    //END OF 574
    assign out_13e = ~(Q_574_b | rip_12m);
    assign DTACKn = out_13e;


    assign c_12m = WAIT_b & AS & VRAM_b;
    ls163a VM_12m(
        {qd_12m, dnc}, 
        rip_12m, 
        {2'b11, IBUS_b, MEXT_b},
        c_12m, 
        qd_12m,
        1'b1, 
        out_13e,
        MCKR);

/////////////////////Address Decoder//////////////////
    
logic [1:0] AD_4J_Y;
logic dnc2, AD_3D_Y, dnc4;
logic [7:0] AD_14C_Y;
logic AD_2C_G2_b, AD_14M_G2_b;
logic [2:0] dnc3;

    assign AD_2C_G2_b = WL_b | AD_3D_Y;
    assign AD_14M_G2_b = ADR_OUT[23] | ADR_OUT[22];

    ls139 AD_4J(
        {IBUS_b, VBUS_b, AD_4J_Y},
        AS_b,
        ADR_OUT[22],
        ADR_OUT[23]);
    
    ls139 AD_3D(
        {CRAM_b, VRAM_b, dnc2, AD_3D_Y},
        VBUS_b,
        ADR_OUT[20],
        ADR_OUT[21]);

    ls138 AD_14C(
        AD_14C_Y,
        1'b1, 
        IBUS_b,
        ADR_OUT[17],
        ADR_OUT[18],
        ADR_OUT[19]);

    ls138 AD_2C(
        {dnc4, UNLOCK_b, VBKACK_b, WDOG_b, MISC_b, PFSPC_b, VSCRLD_b, HSCRLD_b},
        1'b1, 
        AD_2C_G2_b,
        ADR_OUT[17],
        ADR_OUT[18],
        ADR_OUT[19]);

    ls138 AD_14M(
        {dnc3, SLAP_b, ROM_b},
        BR_W_b, 
        AD_14M_G2_b,
        ADR_OUT[16],
        ADR_OUT[17],
        ADR_OUT[19]);

    
    
    always_comb begin
        MEXT_b = AD_4J_Y[0] | ~ADR_OUT[21]; //3B and 4A
        RAM1_b = ADR_OUT[12] | AD_4J_Y[1]; //4f
        RAM0_b = ~ADR_OUT[12] | AD_4J_Y[1]; //4f
        VRAMRD_b = RL_b | VRAM_b;
        VRAMWR = ~VRDTACK_b & ~VRAM_b & ~WL_b;
        CRAMWR_b = CRAM_b | WL_b;
        MA18_b = ~(ADR_OUT[18]);
    end

endmodule
