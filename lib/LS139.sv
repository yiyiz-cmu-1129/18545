//Simple 4 bit Multiplexer
//G is enable
//a and b select
//Y is the one hot inverted output
module ls139(y, g, a, b);
    output logic [3:0] y;
    input logic g, a, b;
    
    logic [3:0] y_g_b;
    always_comb begin
        y = (g) ? 4'b1111 : y_g_b;
        case({b, a})
            2'b00: y_g_b = 4'b1110;
            2'b01: y_g_b = 4'b1101;
            2'b10: y_g_b = 4'b1011;
            2'b11: y_g_b = 4'b0111;
        endcase
    end     

endmodule

