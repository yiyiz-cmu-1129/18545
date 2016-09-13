//This is an 8 bit flip flop
//q is out
//d is in
//cp is clk
//oe_b is enable on low
module 574(q, d, cp, oe_b);
output logic [7:0] q;
input logic [7:0] d;
input logic cp, oe_b;

    always_ff @(posedge cp) begin
        if(~oe_b) q <= d;
        else q <= 8'bzzzz_zzzz;
    end

endmodule


