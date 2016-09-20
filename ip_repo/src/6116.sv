//This is one of the memory controllers
//It will interface with the memory IP

module control_6116(D, A, CS_b, WE_b, OE_b,
            data_in, addr, data_out, c_out, we, en);
inout logic [7:0] D;
input logic [10:0] A;
input logic CS_b, WE_b, OE_b;

//memory interface
output logic [7:0] data_in;
output logic [10:0] addr;
input logic [7:0] data_out;
output logic c_out, we, en;

/*
`ifdef SIM
logic [10:0][7:0] ram;

always_ff (@posedge CS_b) begin

    if(~WE_b & ~OE_b) begin
        ram <= ram;
        ram[A][7:0] <= data_in;
    end
    else ram <= ram;
end
assign data_out = ram[A][7:0];

`endif
*/
    assign c_out = ~CS_b;
    assign we = ~WE_b;
    assign en = OE_b;
    assign addr = A;
    assign D = (~CS_b & ~OE_b & WE_b) ? data_out : 8'bzzzz_zzzz;
    assign data_in = D;
    
    
endmodule

