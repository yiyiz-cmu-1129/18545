//8bit mux
module ls151(I, S, Z, Z_b, E_b);
    input logic [2:0] S;
    input logic [7:0] I;
    input logic E_b;
    output logic Z, Z_b;

    always_comb begin
        if (E_b) begin
            Z = 0; 
            Z_b = 1;
        end
        else begin
            Z = I[S]; 
            Z_b = ~I[S];
        end
    end
endmodule
