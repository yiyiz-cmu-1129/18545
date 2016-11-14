module system_clock(clk100, rst_b, MCKR, SC_1H, SC_2H, SC_4H, SC_8H,
                    SC_16H, SC_32H, SC_64H, SC_128H, SC_256H,
                    PFHST_b, BUFCLR_b, NXL_b, LMPD_b, HBLANK_b, HSYNC, NXL_b_star, VRAC);
    input logic clk100, rst_b;
    output logic MCKR, SC_1H, SC_2H, SC_4H, SC_8H, SC_16H, SC_32H, SC_64H, SC_128H, SC_256H;
    output logic PFHST_b, BUFCLR_b, NXL_b, LMPD_b, HBLANK_b, HSYNC, NXL_b_star;
    output logic [2:0] VRAC;

    logic [3:0] count100;
    logic [8:0] count8;


    
    //This part makes the 7ish MHz clk from a 100MHz clk
    always_ff @(posedge clk100, negedge rst_b) begin
        if (~rst_b)
            count100 <= 4'd0;
        else
            count100 <= (count100 >= 4'd13) ? 0 : count100 + 1;
    end

    assign MCKR = count100 > 4'd6;
    


    //This part gives us our divisors of the 7MHz clk
    always_ff @(posedge MCKR, negedge rst_b) begin
        if (~rst_b)
            count8 <= 0;
        else
            count8 += 1;
end

    assign SC_1H = count8[0];
    assign SC_2H = count8[1];
    assign SC_4H = count8[2];
    assign SC_8H = count8[3];
    assign SC_16H = count8[4];
    assign SC_32H = count8[5];
    assign SC_64H = count8[6];
    assign SC_128H = count8[7];
    //assign SC_256H = count8[8];

    logic [6:0] FPLAtoFF;
        clockFPLA FPLA(.in({SC_128H, SC_64H, SC_32H, SC_16H, SC_8H, SC_4H, SC_2H, SC_1H}),
                   .out({FPLAtoFF, PFHST_b, BUFCLR_b, SC_256H}),
                   .rst_b(rst_b));

    always_ff @(posedge MCKR) begin
        NXL_b <= FPLAtoFF[6];
        VRAC <= FPLAtoFF[5:3];
        LMPD_b <= FPLAtoFF[2];
        HBLANK_b <= FPLAtoFF[1];
        HSYNC <= FPLAtoFF[0];
        NXL_b_star <= NXL_b;
    end

endmodule



module system_clk_test;

  logic clk100; 
  logic rst_b;
  logic MCKR; //main clk 7Mhz
  logic sc_1h, sc_2h, sc_4h, sc_8h; 
  logic sc_16h, sc_32h, sc_64h, sc_128h, sc_256h; 


  system_clock sys_cl(.clk100(clk100), 
                      .rst_b(rst_b),
                      .MCKR(MCKR),
                      .SC_1H(sc_1h), 
                      .SC_2H(sc_2h), 
                      .SC_4H(sc_4h), 
                      .SC_8H(sc_8h),
                      .SC_16H(sc_16h), 
                      .SC_32H(sc_32h), 
                      .SC_64H(sc_64h), 
                      .SC_128H(sc_128h), 
                      .SC_256H(sc_256h));

  initial begin 
  clk100 = 0;
  forever #5 clk100 = ~clk100;
  end

  initial begin 
  rst_b <= 1'b0; 
  @(posedge clk100);
  rst_b <= 1'b1;
  #50000
  $finish;
  end 

endmodule 
