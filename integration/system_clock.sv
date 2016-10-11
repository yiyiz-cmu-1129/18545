module system_clock(clk100, rst_b, SC_1H, SC_2H, SC_4H, SC_8H,
                    SC_16H, SC_32H, SC_64H, SC_128H, SC_256H);
    input logic clk100, rst_b;
    output logic SC_1H, SC_2H, SC_4H, SC_8H, SC_16H, SC_32H, SC_64H, SC_128H, SC_256H;
    
    logic clk7;
    logic [7:0] count100;
    logic [7:0] count7;

    
    //This part makes the 7ish MHz clk from a 100MHz clk
    always_ff @(posedge clk100, negedge rst_b) begin
        if (~rst_b)
            count100 <= 0;
        else
            count100 <= (count100 >= 114) ? 0 : count100 + 1;
    end

    assign clk7 = count100 > 57;



    //This part gives us our divisors of the 7MHz clk
    always_ff @(posedge clk7, negedge rst_b) begin
        if (~rst_b)
            count7 <= 0;
        else
            count7 += 1;
end

    assign SC_1H = clk7;
    assign SC_2H = count7[0];
    assign SC_4H = count7[1];
    assign SC_8H = count7[2];
    assign SC_16H = count7[3];
    assign SC_32H = count7[4];
    assign SC_64H = count7[5];
    assign SC_128H = count7[6];
    assign SC_256H = count7[7];

endmodule
