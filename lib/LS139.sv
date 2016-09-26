//Simple 4 bit Multiplexer
//G is enable
//a and b select
//Y is the one hot inverted output
module ls139(y, g, a, b);
    output logic [3:0] y;
    input logic g, a, b;
    
    always_comb begin
        case({b, a})
            2'b00: y = 4'b1110;
            2'b01: y = 4'b1101;
            2'b10: y = 4'b1011;
            2'b11: y = 4'b0111;
        endcase
        if (g) y = 4'b1111;
    end     

endmodule

