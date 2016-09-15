//I found this in the other teams git

module ls245(A, B, Dir, OE_b);
inout logic [7:0] A, B;
input logic Dir, OE_b;

    always_comb begin
        if(OE_b == 1'b1) begin
            A = 8'bzzzz_zzzz;
            B = 8'bzzzz_zzzz;
        end
        else begin
            if(Dir)
                B = A;
            else
                A = B;
        end
    end
endmodule
