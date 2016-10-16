
// The regfile consists of 256 byte registers
// and a READ-ONLY status register
// Need to set the Write busy flag

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

 //Guess write complete needs 68 clk cycles??? Need to confirm
 logic [6:0] write_complete_cnt;
 logic write_cnt_inc;

 //not sure about the timing now, so make everything to be synchronous now
 always_ff @(posedge phiM) begin
        if (~IC_b) begin
            regs <= 2048'b0;
        end
        else begin
            //Writes can either write a new address or to registers
            if (~WR_b && ~CS_b) begin
                if (~A0) addr <= Din;
                //write busy flag is not set
                if (A0 && (status_reg[7]==1'b0))  begin 
                  regs[addr] <= Din;
                end 
            end

            //Read gives {busy, 5'b0, timerB, timerA}
            if (~RD_b && ~CS_b) Dout <= status_reg; 
            else Dout <= 8'bzzzz_zzzz;


            //timer sets the status reg
            status_reg[1] <= TM_2;
            status_reg[0] <= TM_1;
       end
    end

    // IRQ set when either timer has a carry bit 
    assign IRQ_b = ((TM_1==1) || (TM_2==1)) ? 1'b0 : 1'b1;
    
    // CT_1 and CT_2 are from reg #1B
    // Upon initial clear CT_1 and CT_2 shall be 0
    assign CT_1 = (~IC_b) ? 1'b0 : regs[27][7];
    assign CT_2 = (~IC_b) ? 1'b0 : regs[27][6];

endmodule
