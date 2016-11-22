module ls189(Q, A, D, CK, S_b);
    input logic [3:0] Q;
    input logic [3:0] A;
    output logic [3:0] D;
    input logic CK, S_b;

    logic [3:0] mem [15:0];

    logic [3:0] Dspecial;

    always_ff @(posedge CK) begin
        if (~S_b) begin
            Dspecial <= mem[A];
            mem[A] <= ~Q;
        end
    end

    assign D = (~S_b) ? Dspecial : 4'bzzzz;
endmodule
