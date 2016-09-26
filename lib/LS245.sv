//Input to output direction based on Dir
//OE is a disable

module ls245(A, B, Dir, OE_b);
    inout logic [7:0] A, B;
    input logic Dir, OE_b;

    assign A = (Dir & ~OE_b) ? B : 8'bzzzz_zzzz;
    assign B = (~Dir & ~OE_b) ?  A: 8'bzzzz_zzzz;
endmodule
