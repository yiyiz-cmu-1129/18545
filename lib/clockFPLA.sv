module clockFPLA(in, out, rst_b);
    input logic [7:0] in;
    output logic [9:0] out;
    input logic rst_b;

    logic [7:0] mem [256:0];

    always_ff @(negedge rst_b)
        $readmemh("../roms/roms/clockFPLA.hex", mem);

    always_comb
        out = mem[in];
endmodule
