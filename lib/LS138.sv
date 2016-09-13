//Simple 8 bit Multiplexer
//~G1 and G2 are enable
//a, b and c are select
//Y is the one hot inverted output
module ls139(y, g1, g2, a, b, c);
    output logic [7:0] y;
    input logic g1, g2, a, b, c;
    
    logic [7:0] y_g_b;
    always_comb begin
        y = (~g1 | g2) ? 8'b1111_1111 : y_g_b;
        case({c, b, a})
            3'b000: y_g_b = 8'b1111_1110;
            3'b001: y_g_b = 8'b1111_1101;
            3'b010: y_g_b = 8'b1111_1011;
            3'b011: y_g_b = 8'b1111_0111;
            3'b100: y_g_b = 8'b1110_1111;
            3'b101: y_g_b = 8'b1101_1111;
            3'b110: y_g_b = 8'b1011_1111;
            3'b111: y_g_b = 8'b0111_1111;
        endcase
    end     

endmodule

