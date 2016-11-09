//Read Only Memory

//HUGE PROBLEM
//The 6502 reads the value on every clock edge
//It doesnt expect the value back until the *next* clock edge
//This works in real hardware because there's a delay between when
//You switch the address and when you get the value
//I'll try to figure out a good simulation way to do this
//But someone else will have to figure out the synth one


//WE NEED TO FIND WHAT GOES IN HERE

module control_23128(Dout, A, CS_b, OE_b, clk);
	parameter rom = "../Graphics/roms/alpha.hex";
    output logic [7:0] Dout;
    input logic [13:0] A;
    input logic CS_b, OE_b;
    input clk;

    logic [7:0] ram [1048575:0];
    logic first;

    always_ff @(posedge clk) begin //hmmmm
    	/*
        if(first == 1'b0) begin
    		Dout <= 8'b0000_0000;
    		$readmemh(rom, ram);
    		first <= 1'b1;
    	end
        else Dout <= (~CS_b && ~OE_b) ? ram[A][7:0] : 8'bzzzz_zzzz;
        */
        /////////FIXME
        Dout <= (~CS_b && ~OE_b) ? 8'b0000_0000 : 8'bzzzz_zzzz;
    end
endmodule


