
// The regfile consists of 256 byte registers
// and a READ-ONLY status register

module reg_file 
(input logic [7:0] Din,
 input logic IC_b, //initialize everything to 0
 input logic CS_b, //enable A0, WR, RD
 input logic WR_b,//write to reg
 input logic RD_b, //read from reg
 input logic A0, // 0=>address, 1 => data
 input logic phiM, //clk is 3579.545KHZ
 input logic TM_1, TM_2, //indicating timer overflows 
 output logic IRQ_b, //set by the timer
 output logic CT_1, CT_2, // not quite sure now, but shall be output
                          // to the processor 
 output logic [7:0] Dout);

 logic [7:0] addr;
 logic [7:0] status_reg;
 logic [255:0][7:0] regs;


 //not sure about the timing now, so make everything to be synchronous now
 always_ff @(posedge phiM) begin
        if (~IC_b) begin
            regs <= 2048'b0;
            CT_1 <= 1'b0;
            CT_2 <= 1'b0; //Upon initial clear CT_1 and CT_2 shall be 0
        end
        else begin
            //Writes can either write a new address or to registers
            if (~WR_b && ~CS_b) begin
                if (~A0) addr <= Din;
                if (A0)  regs[addr] <= Din;
            end

            //Read gives {busy, 5'b0, timerB, timerA}
            if (~RD_b && ~CS_b) Dout <= status_reg; 
            else Dout <= 8'bzzzz_zzzz;


            //CT_1 and CT_2 are from reg #1B
            CT_1 <= regs[27][7];
            CT_2 <= regs[27][6];
       end
    end

    //IRQ set when either timer has a carry bit 
    assign IRQ_b = ((TM_1==1) || (TM_2==1)) ? 1'b0 : 1'b1;

endmodule
