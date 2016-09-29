//This is one of the memory controllers
//It will interface with the memory IP

module control_6116(Din, Dout, A, CS_b, WE_b, OE_b, clk);
    input logic [7:0] Din;
    output logic [7:0] Dout;
    input logic [10:0] A;
    input logic CS_b, WE_b, OE_b;
    input logic clk;

    logic [7:0] ram [2047:0];

    always_ff @(posedge clk) begin

        if(~WE_b & ~CS_b) ram[A][7:0] <= Din;

        Dout <= (~CS_b & ~OE_b & WE_b) ? ram[A][7:0] : 8'bzzzz_zzzz;
    end  
endmodule

