/*
This is an 8 input 8 output D-type latch
*/

module ls374(Q, D, clk, OC_b);
output logic [7:0] Q;
input logic [7:0] D;
input logic clk, OC_b;

        
    logic [7:0] Q_last;
    
    assign Q = (OC_b) ? 8'bzzzz_zzzz : Q_last;
    
    always_ff @(posedge clk) begin
        if(~OC_b) begin 
            Q_last <= D;
        end                
        else Q_last <= Q_last;
    end


endmodule
