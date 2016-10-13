module ls378(
	output logic [5:0] Q,
	input logic [5:0] D,
	input logic E_b, CP);

	logic [5:0] QL;
	assign Q = QL;
	always_ff @(posedge CP) begin
		if(~E_b) QL <= D;
		else QL <= QL;
	end


endmodule