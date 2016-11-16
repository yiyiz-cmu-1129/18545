module control_2149(
    input logic [3:0] Din,
    output logic [3:0] Dout,
    input logic [9:0] A,
    input logic CS_b, WE_b, clk);


    logic [3:0] ram [1023:0];
    logic [3:0] data_out;
    always_ff @(posedge clk) begin
        if(~WE_b & ~CS_b) begin
            ram[A] <= Din;
        end
    end
    assign data_out = ram[A];
    assign Dout = (~CS_b) ? data_out : 4'bzzzz;
    

endmodule
