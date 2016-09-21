//Read only memory
module control_23128(D, A, CS_b, WE_b, OE_b, CE1_b, CE2_b,
            addr, data_out, c_out);
output logic [7:0] D;
input logic [13:0] A;
input logic CS_b, OE_b, CE1_b, CE2_b;

//memory interface
output logic [13:0] addr;
input logic [7:0] data_out;
output logic c_out;
    

    assign c_out = ~CS_b;
    assign addr = A;
    assign D = (~OE_b & ~CE1_b & ~CE2_b) ? data_out : 8'bzzzz_zzzz;

endmodule


