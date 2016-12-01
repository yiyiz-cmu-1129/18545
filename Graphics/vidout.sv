//`include "vga.sv"

module vidout(
    input logic [15:0] VIDOUT,
    input logic CLOCK_100, reset,
    input logic MCKF, VIDBLANK_b,
    output logic HS, VS, blank_N,
    output logic [7:0] VGA_R, VGA_G, VGA_B);

    logic CLOCK_50;

    logic [9:0] vga_col; //This is the size of the actual screen
    logic [8:0] vga_row; //If we're off the screen display 0 cuz fuck it

    logic [8:0] comp_col;
    logic [7:0] comp_row;
    //screen is 336 by 240

    always_ff @(posedge CLOCK_100) begin
        if (reset)
            CLOCK_50 <= 0;
        else
            CLOCK_50 <= ~CLOCK_50;
    end

    vga vgaModule(.CLOCK_50(CLOCK_50),
                  .reset(reset),
                  .HS(HS),
                  .VS(VS),
                  .blank(),
                  .row(vga_row),
                  .col(vga_col));


    logic [8:0][7:0][15:0] buffer;
    always_ff @(posedge MCKF) begin
        if(reset) begin
            comp_col <= 0;
            comp_row <= 0;
        end
        else if(comp_col > 9'd335) begin
            comp_col <= 9'd0;
            if(comp_row > 8'd239) begin
                comp_row <= 8'd0;
            end
            else begin
                comp_row <= comp_row + 8'd1;
            end
        end
        else begin
            comp_col <= comp_col + 9'd1;
        end
        buffer[comp_col][comp_row] <= VIDOUT;
    end


    always_comb begin
        if (vga_col < 336 && vga_row < 240) begin
            VGA_R = {buffer[vga_col][vga_row][11:8], 4'b0000};
            VGA_G = {buffer[vga_col][vga_row][7:4], 4'b0000};
            VGA_B = {buffer[vga_col][vga_row][3:0], 4'b0000};
        end
        else begin
            VGA_R = 0;
            VGA_G = 0;
            VGA_B = 0;
        end
    end

endmodule
