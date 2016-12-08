module chip_interface(JA1, JA2, JA3, JA4, JB1, JB2, JB3, JB4, SW3, SW2, SW0, SW1, clk_100,
           LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7, BTNC, AC_GPIO0, AC_GPIO1, AC_GPIO2, 
	AC_GPIO3, AC_ADR0, AC_ADR1, AC_SCK, AC_MCLK, AC_SDA);

    input logic JA1, JA2, JA3, JA4;
    input logic JB1, JB2, JB3, JB4;
    input logic SW0, SW1, clk_100;
    input logic SW2, SW3;
    output logic LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7;
    input logic BTNC; 
    output logic AC_GPIO0;
    input logic AC_GPIO1, AC_GPIO2, AC_GPIO3;
    output logic AC_ADR0, AC_ADR1, AC_SCK, AC_MCLK;
    inout logic AC_SDA; 

 

  //logic AC_MCLK, AC_ADR0, AC_ADR1, AC_SCK, AC_SDA;
  //logic AC_GPIO0, AC_GPIO1, AC_GPIO2, AC_GPIO3;
  logic [23:0] hphone_l, hphone_r;
  //logic [23:0] line_in_l, line_in_r;
  //logic new_sample, 
  logic sample_clk_48k;
  logic hphone_l_valid, hphone_r_valid;

  logic [23:0] left_to_board, right_to_board;
  logic sample;
  logic [7:0] dataX, dataY;
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
                .addr0(addr0),
                .clk(MCKR), // 7 MHZ clk 
                .rst(BTNC),
                .SW3(SW3),
                .SW2(SW2),
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

  trackball_top tbt(.data_outX(dataX),
                    .data_outY(dataY),
                    .addr0(addr0),
                    .JA1(JA1), 
                    .JA2(JA2), 
                    .JA3(JA3), 
                    .JA4(JA4), 
                    .JB1(JB1), 
                    .JB2(JB2), 
                    .JB3(JB3), 
                    .JB4(JB4), 
                    .SW0(SW0), 
                    .SW1(SW1), 
                    .GCLK(clk_100),
                    .LD0(LD0), 
                    .LD1(LD1), 
                    .LD2(LD2), 
                    .LD3(LD3), 
                    .LD4(LD4), 
                    .LD5(LD5), 
                    .LD6(LD6), 
                    .LD7(LD7), 
                    .reset(BTNC),
                    .sync(sync));

endmodule 
