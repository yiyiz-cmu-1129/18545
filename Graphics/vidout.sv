module vidout(
    input logic [15:0] VIDOUT,
    input logic CLOCK_100, reset,
    input logic MCKF, VIDBLANK_b,
    output logic HS, VS, blank_N,
    output logic [7:0] VGA_R, VGA_G, VGA_B);

    logic [8:0] col;
    logic [7:0] row;
    //screen is 336 by 240

    logic [8:0][7:0][15:0] buffer;
    always_ff @(posedge MCKF) begin
        if(reset) begin
            col <= 0;
            row <= 0;
        end
        else if(col > 9'd335) begin
            col <= 9'd0;
            if(row > 8'd239) begin
                row <= 8'd0;
            end
            else begin
                row <= row + 8'd1;
            end
        end
        else begin
            col <= col + 9'd1;
        end
        buffer[col][row] <= VIDOUT;
    end

/*
    VGA_R = {VIDOUT[11:8], 4'b0000};
            VGA_G = {VIDOUT[7:4], 4'b0000};
            VGA_B = {VIDOUT[3:0], 4'b0000};
*/
endmodule