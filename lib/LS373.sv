/*
This is an 8 input 8 output D-type latch
*/

module ls373(Q, D, clk, OC_b);
output logic [7:0] Q;
input logic [7:0] D;
input logic clk, OC_b;

    logic [7:0] Q_last;
    
    always_comb begin
        if(OC_b) Q = 8'bzzzz_zzzz;
        else begin
            if(clk) Q = D;
            else Q = Q_last;
        end
    end
    
    always_ff @(posedge clk) begin
        if(~OC_b) Q_last <= Q; 
        else Q_last <= Q_last;
    end


endmodule
