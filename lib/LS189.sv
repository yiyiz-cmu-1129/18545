module ls189(Q, A, D, W_b, S_b, CK);
    input logic [3:0] Q;
    input logic [3:0] A;
    output logic [3:0] D;
    input logic W_b, S_b, CK;

    logic [3:0] [3:0] mem;

    always_ff @(posedge CK) begin
        if (~S_b & ~W_b)
            mem[A] <= ~Q;
        if (~S_b)
            D <= ~Q;
        else
            D <= 4'bzzzz;
    end
endmodule
