//This is a shift registers

module ls299(
    output logic [7:0] Q,
    output logic QA, QH,
    
    input logic [7:0] D,
    input logic [1:0] G_b, S,
    input logic CLR_b, SL, SR, CK);

	always_ff @(posedge CK) begin
		if(~CLR_b) begin
			Q <= 8'd0;
			QA <= 0;
			QH <= 0;
		end
		else if(S == 2'b00 && G_b == 2'b00) begin
			Q <= Q;
			QA <= Q[7];
			QH <= Q[0];
		end
		else if(S == 2'b01 && G_b == 2'b00) begin
			Q <= {SR, Q[7:1]};
			QA <= SR;
			QH <= Q[1];
		end
		else if(S == 2'b10 && G_b == 2'b00) begin
			Q <= {Q[6:0], SL};
			QA <= Q[6];
			QH <= SL;
		end
		else if(S == 2'b11) begin
			Q <= D;
			QA <= D[7];
			QH <= D[0];
		end
	end
endmodule
