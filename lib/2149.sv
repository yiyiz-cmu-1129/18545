module control_2149(
    input logic [3:0] Din,
    output logic [3:0] Dout,
    input logic [9:0] A,
    input logic CS_b, WE_b, clk);


    logic [3:0] ram [1024:0];
    logic [3:0] data_in, data_out;
    always_ff (@posedge clk) begin
        if(~WE_b) begin
            ram <= ram;
            ram[A][3:0] <= data_in;
        end
        else ram <= ram;
    end
    assign data_out = ram[A][3:0];
    assign Dout = (~CS_b & ~WE_b) ? data_out : 4'bzzzz;
    assign data_in = Din;
    

endmodule
