module chip_interface(
        input logic clk_100,
        input logic reset,
        output logic AC_GPIO0,
        input logic AC_GPIO1, AC_GPIO2, AC_GPIO3,
        output logic AC_ADR0, AC_ADR1, AC_SCK, AC_MCLK,
        inout logic AC_SDA, 
        input logic SW0, SW1);

  logic [23:0] hphone_l, hphone_r;
  //logic [23:0] line_in_l, line_in_r;
  //logic new_sample, 
  logic sample_clk_48k;
  logic hphone_l_valid, hphone_r_valid;

  logic [23:0] left_to_board, right_to_board;
  //                                             logic sample;

    //7mhz clock generator
  logic [3:0] count100;
  logic MCKR;
 
  always_ff @(posedge clk_100, negedge reset) begin
        if (reset) count100 <= 4'd0;
        else count100 <= (count100 >= 4'd13) ? 0 : count100 + 1;
  end

  assign MCKR = count100 > 4'd6;
  logic clk_100_buf;
  audio_helper audHelp(
                .CLK_100(clk_100),
                .CLK_100_BUFFERED(clk_100_buf));
                
  jt51_top jtMod(
                .left_to_board(hphone_l), 
                .right_to_board(hphone_r),
                .sample(hphone_l_valid),
                .clk(MCKR), // 7 MHZ clk 
                .rst(reset),
                .SW1(SW1),
                .SW0(SW0)); // a button on fpga?


   audio_top audMod(
               .CLK_100(clk_100_buf), //input                
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


endmodule 
