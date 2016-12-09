module chip_interface(JA, JB, SW, clk_100,
           LD, BTNC, AC_GPIO0, AC_GPIO1, AC_GPIO2, 
	AC_GPIO3, AC_ADR0, AC_ADR1, AC_SCK, AC_MCLK, AC_SDA,
	VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS);

    input logic [3:0] JA;
    input logic [3:0] JB;
    input logic clk_100;
    input logic [3:0] SW;
    output logic [7:0] LD;
    input logic BTNC; 
    output logic AC_GPIO0;
    input logic AC_GPIO1, AC_GPIO2, AC_GPIO3;
    output logic AC_ADR0, AC_ADR1, AC_SCK, AC_MCLK;
    inout logic AC_SDA;
    
    output logic [3:0] VGA_R, VGA_G, VGA_B;
    output logic VGA_HS, VGA_VS; 

 

  //logic AC_MCLK, AC_ADR0, AC_ADR1, AC_SCK, AC_SDA;
  //logic AC_GPIO0, AC_GPIO1, AC_GPIO2, AC_GPIO3;
  logic [23:0] hphone_l, hphone_r;
  //logic [23:0] line_in_l, line_in_r;
  //logic new_sample, 
  logic sample_clk_48k;
  logic hphone_l_valid, hphone_r_valid;

  logic [23:0] left_to_board, right_to_board;
  logic sample;
  logic [1:0][7:0] dataX, dataY;
  logic addr0;
  logic sync;

  logic [3:0] count100;
  logic MCKR;
  logic CLKBUF;
  //changed to posedge edge reset
  always_ff @(posedge clk_100, negedge BTNC) begin
        if (BTNC)
            count100 <= 4'd0;
        else
            count100 <= (count100 >= 4'd13) ? 0 : count100 + 1;
    end

    assign MCKR = count100 > 4'd6;
   audio_helper audHelp( 
              .CLK_100(clk_100),
              .CLK_100_BUFFERED(CLKBUF));

  jt51_top jt(
                .left_to_board(hphone_l), 
                .right_to_board(hphone_r),
                .sample(hphone_l_valid),
                .dataX(dataX),
                .dataY(dataY),
                .clk(MCKR), // 7 MHZ clk 
                .rst(BTNC),
                .SW3(SW[3]),
                .SW2(SW[2]),
                .sync(sync)); // a button on fpga?


  audio_top at(.CLK_100(CLKBUF), //input                
               .AC_MCLK(AC_MCLK),   //output                
	             .AC_ADR0(AC_ADR0),   //output                 
               .AC_ADR1(AC_ADR1),   //output
	             .AC_SCK(AC_SCK),     //output  
               .AC_SDA(AC_SDA),     //input  
		           .AC_GPIO0(AC_GPIO0), //output                        
               .AC_GPIO1(AC_GPIO1), //input                       
               .AC_GPIO2(AC_GPIO2), //input                       
               .AC_GPIO3(AC_GPIO3), //input
               .HPHONE_L(hphone_l),         //input
               .HPHONE_L_VALID(hphone_l_valid),
               .HPHONE_R(hphone_r),
               .HPHONE_R_VALID_DUMMY(hphone_r_valid),
               .LINE_IN_L(),
               .LINE_IN_R(),
               .NEW_SAMPLE(),
               .SAMPLE_CLK_48K(sample_clk_48k));


  //FIXME: Removed the SYNC signal from trackball
  trackball_top tbt(.dataX(dataX),
                    .dataY(dataY),
                    .JA(JA),
                    .JB(JB),  
                    .GCLK(clk_100),
                    .LD(LD),
                    .VGA_R(VGA_R),
                    .VGA_G(VGA_G),
                    .VGA_B(VGA_B),
                    .VGA_HS(VGA_HS),
                    .VGA_VS(VGA_VS),
                    .BTNC(BTNC));

endmodule 
