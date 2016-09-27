//The ls174 is a simple flipflop with clear
module ls174(
output logic [5:0] Q,
input logic [5:0] D,
input logic ck, cl);

    logic [5:0] Q1;
    //it has async reset    

    assign Q = (cl) ? Q1 : 6'b000000;
    
    always_ff @(posedge ck) begin
        if(cl) Q1 <= 6'b000000;
        else Q1 <= D;
    end
    

endmodule
