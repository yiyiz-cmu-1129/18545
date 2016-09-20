module ls244(Y, A, G1_b, G2_b);
output logic [7:0] Y;
input logic [7:0] A;
input logic G1_b, G2_b;

    assign Y[3:0] = (G1_b) ? A[3:0] : 4'bzzzz;
    assign Y[7:4] = (G2_b) ? A[7:4] : 4'bzzzz;

endmodule
