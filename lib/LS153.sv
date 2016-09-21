module ls153(Za, Zb, Ia, Ib, Ea_b, Eb_b, S);
output logic Za, Zb;
input logic [3:0] Ia, Ib;
input logic [1:0] S;
input logic Ea_b, Eb_b;

    assign Za = (~Ea_b) & ((Ia[0] & ~S[1] & ~S[0]) | (Ia[1] & ~S[1] & S[0]) | 
                            (Ia[2] & S[1] & ~S[0]) | (Ia[3] & S[1] & S[0]));

    assign Zb = (~Eb_b) & ((Ib[0] & ~S[1] & ~S[0]) | (Ib[1] & ~S[1] & S[0]) | 
                            (Ib[2] & S[1] & ~S[0]) | (Ib[3] & S[1] & S[0]));


endmodule
