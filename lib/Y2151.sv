module y2151(Din, Dout, A0, WR_b, RD_b, CS_b, IC_b, iRQ_b, SO, SH1, SH2, phiM);
    input logic [7:0] Din;
    output logic [7:0] Dout;
    input logic A0; //0=>address, 1=>data
    input logic WR_b, RD_b;
    input logic CS_b;
    input logic IC_b; //Initial clear
    output logic iRQ_b;
    output logic SO;
    output logic SH1, SH2;
    input logic phiM;

    logic [7:0] addr;
    logic [255:0] [7:0] regs;


    //Temp Output Assigns
    assign iRQ_b = 1;

    //This should emulate how its internal registers work
    //(Won't produce sound)
    always_ff @(posedge phiM) begin
        if (~IC_b) begin
            regs = 2048'b0;
        end
        else begin
            //Writes can either write a new address or to registers
            if (~WR_b && ~CS_b) begin
                if (~A0) addr <= Din;
                if (A0)  regs[addr] <= Din;
            end

            //Read gives {busy, 5'b0, timerB, timerA}
            //Here we just say NOT busy and don't know what the timers are
            if (~RD_b && ~CS_b) Dout <= 8'b0000_0000; 
            else Dout <= 8'bzzzz_zzzz;
        end
    end

endmodule
