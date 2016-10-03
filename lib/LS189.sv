module ls189(Q, D, CK, RS_b);
    input logic [3:0] Q;
    input logic [3:0] A;
    output logic [3:0] D;
    input logic W_b, S_b, clk, RS_b;

    logic [3:0] [3:0] mem;

    always_ff @(posedge CK) begin
        if (~S_b & ~W_b)
            mem[A] <= ~Q;
        else if (~S_b & W_b)
            D <= mem[A];
        else
            D <= 4'bzzzz;
    end
endmodule
