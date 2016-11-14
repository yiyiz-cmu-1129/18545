//This is a rom that they burn in when they make the system one.
//It is basically the same thing as a normal rom, we just have to load the
//Memory in ourselves



////FIXME


module control_82S129(
	output logic [3:0] O,
	input logic [7:0] A,
	input logic CE1_b, CE2_b, clk, reset);
    parameter rom = "../roms/roms/alpha.hex";
	
    logic [3:0] mem [4096:0];
    logic CE;

    assign CE = ~(CE1_b | CE2_b);
    
    always_ff @(posedge clk) begin //hmmmm
        if(~reset) $readmemh(rom, mem);
        O <= (CE) ? mem[A] : 4'bzzzz; 
    end
endmodule