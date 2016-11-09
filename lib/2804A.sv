module control_2804(A, Din, Dout, CE_b, OE_b, WE_b, clk, rst_b);
    input logic [10:0] A;
    input logic [7:0] Din;
    output logic [7:0] Dout;
    input logic CE_b, OE_b, WE_b, clk, rst_b;

    logic [7:0] eeprom [511:0];

    always_ff @(posedge clk) begin
        if (~rst_b) begin
            $readmemh("../lib/eeprom.hex", eeprom);
        end
        else begin
            if(~WE_b & ~CE_b) eeprom[A[7:0]][7:0] <= Din;

            Dout <= (~CE_b & ~OE_b & WE_b) ? eeprom[A[7:0]][7:0] : 8'bzzzz_zzzz;
        end
    end

endmodule
