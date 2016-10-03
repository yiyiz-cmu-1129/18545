//This is just a 8-bit reg so feel free to not use it
module control_5273(Q, D, CK, RS_b);
    input logic [7:0] Q;
    output logic [7:0] D;
    input logic CK, RS_b;

    always_ff @(posedge CK) begin
        if (~RS_b)
            D <= 0;
        else
            D <= Q;
    end
endmodule
