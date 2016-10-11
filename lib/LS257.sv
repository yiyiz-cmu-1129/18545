//I got rid of the output control since it is always down
module ls257(
	output logic [3:0] Y,
	input logic [3:0] A, B, 
	input logic Sel);

	always_comb begin
		if(Sel) Y = B;	
		else Y = A;
	end
	

endmodule