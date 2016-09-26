//Simple 8 bit Multiplexer
//~G1 and G2 are enable
//a, b and c are select
//Y is the one hot inverted output
module ls138(y, g1, g2, a, b, c);
    output logic [7:0] y;
    input logic g1, g2, a, b, c;
    
    always_comb begin
        case({c, b, a})
            3'b000: y = 8'b1111_1110;
            3'b001: y = 8'b1111_1101;
            3'b010: y = 8'b1111_1011;
            3'b011: y = 8'b1111_0111;
            3'b100: y = 8'b1110_1111;
            3'b101: y = 8'b1101_1111;
            3'b110: y = 8'b1011_1111;
            3'b111: y = 8'b0111_1111;
        endcase
        if (~g1 | g2) y = 8'b1111_1111;
    end     

endmodule

