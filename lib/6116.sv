//This is one of the memory controllers
//It will interface with the memory IP

module 6116(D, A, CS_b, WE_b, OE_b,
            data_in, addr, data_out, clk, we, en);
inout logic [7:0] D;
input logic [10:0] A;
input logic CS_b, WE_b, OE_b;

`ifdef SIM

`endif

//memory interface
output logic [7:0] data_in;
output logic [10:0] addr;
input logic [7:0] data_out;
output logic clk, we, en;

    assign clk = ~CS_b;
    assign we = ~WE_b;
    assign en = OE_b;
    assign addr = A;
    assign D = (~CS_b & ~OE_b & WE_b) ? data_out : 8'bzzzz_zzzz;
    assign data_in = D;
    
    
endmodule

