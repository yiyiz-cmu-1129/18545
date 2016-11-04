//Bill Fucking Murray
module letaBFM(DB, CS, CK, TEST, AD, RESOLN, rst_b);
    output logic [7:0] DB;
    input logic CS, CK, TEST, RESOLN; //This clock should be 8H
    input logic [1:0] AD;
    input logic rst_b;

    logic [3:0] [7:0] regs;

    always_ff @(posedge CK, negedge rst_b) begin
        if (~rst_b) begin
            regs <= 0;
        end
        else begin
            for (int i = 0; i < 4; i++)
                regs[i] += 10;
        end
    end

    //CS: chip select -> low means enable
    //TEST: low means pass the trackball inputs through, can look like 1111_1111
    assign DB = CS ? 8'bzzzz_zzzz : TEST ? 8'b1111_1111 : regs[AD];
endmodule
