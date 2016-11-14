module control_23256(
	output logic [7:0] data,
	input logic [14:0] addr,
	input logic clk, reset);
    parameter rom = "../roms/roms/bank1plane0.hex";


	logic [7:0] mem[32767:0];

	always_ff @(posedge clk) begin
		if(reset) $readmemh(rom, mem);
		data <= mem[addr];
	end



endmodule