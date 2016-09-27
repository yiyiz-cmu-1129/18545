module y2151(Din, Dout, A0, WR_b, RD_b, CS_b, IC_b, iRQ_b, SO, SH1, SH2, phiM, phi1);
    input logic [7:0] Din;
    output logic [7:0] Dout;
    input logic A0, //0=>address, 1=>data
    input logic WR_b, RD_b;
    input logic CS_b;
    input logic IC_b; //Initial clear
    output logic iRQ_b;
    output logic SO;
    output logic SH1, SH2;
    input logic phiM;

    logic [7:0] addr;
    logic [7:0] regs [255:0];

    //This should emulate how its internal registers work
    //(Won't produce sound)
    always_ff @(posedge phiM) begin
        if (~A0 && ~WR_b) addr <= Din;
        if (A0 && ~WR_b) regs[addr] <= Din;
        Dout <= (~RD_b) ? regs[addr] : 8'bzzzz_zzzz;
    end

endmodule
