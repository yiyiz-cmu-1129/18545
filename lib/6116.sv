//This is one of the memory controllers
//It will interface with the memory IP

module 6116(D, A, CS_b, WE_b, OE_b);
inout logic [7:0] D;
input logic [10:0] A;
input logic CS_b, WE_b, OE_b;


    logic [7:0] data_out, data_in;
    reg [10:0][7:0] Mem;

    assign D = (~CS_b & ~OE_b & WE_b) ? data_out : 8'bzzzz_zzzz;
    assign data_in = D;
    
    
endmodule

