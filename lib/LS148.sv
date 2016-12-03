module ls148(A, EO, GS, I, EI);
	output logic [2:0] A;
	output logic EO, GS;
	input logic [7:0] I;
	input logic EI;

	always_comb begin
		casex({EI, I})
			9'b1_xxxx_xxxx: {A, GS, EO} = 5'b11111;
			9'b0_1111_1111: {A, GS, EO} = 5'b11110;
			9'b0_0xxx_xxxx: {A, GS, EO} = 5'b00001;
			9'b0_10xx_xxxx: {A, GS, EO} = 5'b00101;
			9'b0_110x_xxxx: {A, GS, EO} = 5'b01001;
			9'b0_1110_xxxx: {A, GS, EO} = 5'b01101;
			9'b0_1111_0xxx: {A, GS, EO} = 5'b10001;
			9'b0_1111_10xx: {A, GS, EO} = 5'b10101;
			9'b0_1111_110x: {A, GS, EO} = 5'b11001;
			9'b0_1111_1110: {A, GS, EO} = 5'b11101;
		endcase
	end


endmodule
