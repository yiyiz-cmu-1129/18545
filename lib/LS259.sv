//8-bit active high demux from S[2:0] to Q[7:0]
//The actual chip isn't clocked, but we need a clock because we don't want to use latches
module ls259(S, D, Q, En_b, clr_b, clk);
    input logic [2:0] S;
    input logic D;
    input logic En_b;
    input logic clr_b, clk;
    output logic [7:0] Q;

    always_ff @(posedge clk) begin
        case ({clr_b, En_b}) //This ordering matches the table on the spec sheet
            2'b10: Q[S] <= D;
            //2'b11: //no op
            2'b00: $error("This should never be used in the design");
            2'b01: Q <= 8'b0;
        endcase
    end
endmodule
