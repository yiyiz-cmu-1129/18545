//This is another memory module which has no clock input normally so we will need to provide one
module ims1420(
	input logic [11:0] ADDR,
	input logic [3:0] DATA_IN,
	output logic [3:0] DATA_OUT,
	input logic WE_b, E_b, clk);


	logic [3:0] ram [4096:0];
	
    always_ff (@posedge clk) begin
        if(~WE_b & ~E_b) begin
            ram <= ram;
            ram[ADDR][3:0] <= DATA_IN;
        end
        else ram <= ram;
    end
    assign DATA_OUT = (~E_b & WE_b) ? ram[ADDR][3:0] : 4'bzzzz;

endmodule
