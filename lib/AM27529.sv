
module am27s29(
	output logic [7:0] data,
	input logic [8:0] addr,
	input logic clk, reset);
    parameter rom = "../Graphics/roms/alpha.hex";


	logic [7:0] mem[511:0];

    initial $readmemh(rom, mem);

	always_ff @(posedge clk) begin
		data <= mem[addr];
	end



endmodule
