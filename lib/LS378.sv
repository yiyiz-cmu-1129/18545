module ls378(
	output logic [5:0] Q,
	input logic [5:0] D,
	input logic E_b, ck);


	always_ff @(posedge ck) begin
		if(~E_b) Q <= D;
		else Q <= Q;
	end


endmodule