
module am27s29(
	output logic [7:0] data,
	input logic [8:0] addr,
	input logic clk, reset);
    parameter rom = "../Graphics/roms/alpha.hex";


	logic [7:0] mem[511:0];

	always_ff @(posedge clk) begin
		if(reset) $readmemh(rom, mem);
		data <= mem[addr];
	end



endmodule