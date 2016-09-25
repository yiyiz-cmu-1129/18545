module control_2149(
    input logic [3:0] Din,
    output logic [3:0] Dout,
    input logic [9:0] A,
    input logic CS_b, WE_b,
    
    //Will need to have viv
    //Vivado Interface
    output logic [3:0] data_in,
    input logic [3:0] data_out,
    output logic [9:0] Addr,
    output logic WE);

    `ifdef SIM
    logic [9:0][3:0] ram;

    always_ff (@posedge CS_b) begin
        if(~WE_b) begin
            ram <= ram;
            ram[A][3:0] <= data_in;
        end
        else ram <= ram;
    end
    assign data_out = ram[A][3:0];

    `endif

    assign WE = ~WE_b;
    assign addr = A;
    assign Dout = (~CS_b & ~WE_b) ? data_out : 4'bzzzz;
    assign data_in = Din;

    

endmodule
