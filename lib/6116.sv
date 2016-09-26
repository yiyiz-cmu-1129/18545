//This is one of the memory controllers
//It will interface with the memory IP
`define SIM 1

module control_6116(Din, Dout, A, CS_b, WE_b, OE_b,
                    data_in, addr, data_out, c_out, we, en);
input logic [7:0] Din;
output logic [7:0] Dout;
input logic [10:0] A;
input logic CS_b, WE_b, OE_b;
output logic [7:0] data_in;
output logic [10:0] addr;
input logic [7:0] data_out;
output logic c_out, we, en;


`ifdef SIM //This appears to emaulate function correctly now
logic [7:0] ram [2047:0];

always_ff @(posedge testbench.dut.phi0) begin

    if(~WE_b & ~CS_b) ram[A][7:0] <= Din;

    Dout <= (~CS_b & ~OE_b & WE_b) ? ram[A][7:0] : 8'bzzzz_zzzz;

end
`else
//memory interface
    assign c_out = ~CS_b;
    assign we = ~WE_b & ~CS_b;
    assign en = OE_b;
    assign addr = A;
    assign Dout = (~CS_b & ~OE_b & WE_b) ? data_out : 8'bzzzz_zzzz;
    assign data_in = Din;
`endif
    
endmodule

