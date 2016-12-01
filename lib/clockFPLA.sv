module clockFPLA(in, out, rst_b);
    parameter rom = "../roms/roms/clockFPLA.hex";
    input logic [7:0] in;
    output logic [9:0] out;
    input logic rst_b;

    logic [7:0] mem [256:0];


    initial $readmemh(rom, mem);

    always_comb
        out = mem[in];
endmodule
