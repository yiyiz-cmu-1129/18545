module vga
  (input logic CLK_50, reset,
   output logic HS, VS, //blank,
   output logic [8:0] row,
   output logic [9:0] col);

   logic [10:0]       countHS, col_temp;
   logic [9:0] 	      countVS, row_temp;
   logic 	      resetHS, resetVS;
   
   
   counter #(11) HS_counter(.up(1'b1), .clear(resetHS), .clk(CLK_50), .en(1'b1), .count(countHS));
   counter #(10) VS_counter(.up(1'b1), .clear(resetVS), .clk(CLK_50), .en(resetHS), .count(countVS));

   always_comb begin
      //Reset HS logic
      if(countHS == 11'd1600 || reset)
	resetHS = 1'b1;
      else
	resetHS = 1'b0;

      //Reset VS logic
      if(countVS == 10'd521 || reset)
	resetVS = 1'b1;
      else
	resetVS = 1'b0;

      //Output col logic
      //(countHS - T_pw(HS) - T_bp(HS))/# of clocks pixel displayed
      col_temp = (countHS - 11'd192 - 11'd96) >> 1;
      col = col_temp[9:0];

      //Output row logic
      //countVS - T_pw(VS) - T_bp(VS)
      row_temp = countVS - 10'd2 - 10'd29;
      row = row_temp[8:0];

      //HS logic
      //countHS < T_pw(HS)
      if(countHS < 11'd192)
	HS = 1'b0;
      else
	HS = 1'b1;

      //VS logic
      //countVS < T_pw(VS)
      if(countVS < 10'd2)
	VS = 1'b0;
      else
	VS = 1'b1;
      
   end
endmodule: vga


module counter                                                                                                                                                              
   #(parameter WIDTH=8)
   (input logic en,up,clear,clk,
    output logic [WIDTH-1:0] count);
 
   logic [WIDTH-1:0] q;
 
   always_ff@(posedge clk)
     if(clear) q<='d0;
     else if(en&&up) q<=(q+'d1);
     else if(en&&(~up)) q<=(q-'d1);
 
   //output logic 
   assign count=q;
 
endmodule:counter
/*
module ChipInterface
  (input logic GCLK,
   input logic BTNU,
   input logic SW0,
   //input logic [17:0] SW,
   //output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
   
   output logic VGA_R1, VGA_R2, VGA_R3, VGA_R4, 
   output logic VGA_G1, VGA_G2, VGA_G3, VGA_G4, 
   output logic VGA_B1, VGA_B2, VGA_B3, VGA_B4, 
   output logic VGA_VS, VGA_HS);

   logic [8:0] 	row;
   logic [9:0] 	col;
   //logic 	blank, 
   logic reset;
   logic CLK_50;
   
   //Half the clock100 freq
   always_ff @(posedge GCLK) begin
       if (BTNU)
           CLK_50 <= 0;
       else
           CLK_50 <= ~CLK_50;
   end
   
   vga vgaController(CLK_50, reset, VGA_HS, VGA_VS, row, col);

   //assign VGA_BLANK_N = ~blank;
   //assign VGA_CLK = ~CLOCK_50;
   //assign VGA_SYNC_N = 0;
   assign reset = BTNU;
   always_comb begin
        if (SW0) begin
            {VGA_R1,VGA_R2, VGA_R3, VGA_R4} = ((col >= 320) && (col <= 639)) ? 4'hF : 4'h0;
            {VGA_G1,VGA_G2, VGA_G3, VGA_G4} = ((col >=160) && (col <= 319) || (col >= 480) && (col <= 639)) ? 4'hF : 4'h0;
            {VGA_B1,VGA_B2, VGA_B3, VGA_B4} = ((col >= 80) && (col <= 159) || (col >= 240) && (col <= 319) || (col >= 400) && (col <= 479) || (col >= 560) && (col <= 639)) ? 4'hF : 4'h0;
        end
        else begin
             {VGA_G1,VGA_G2, VGA_G3, VGA_G4} = ((col >= 320) && (col <= 639)) ? 4'hF : 4'h0;
             {VGA_R1,VGA_R2, VGA_R3, VGA_R4} = ((col >=160) && (col <= 319) || (col >= 480) && (col <= 639)) ? 4'hF : 4'h0;
             {VGA_B1,VGA_B2, VGA_B3, VGA_B4} = ((col >= 80) && (col <= 159) || (col >= 240) && (col <= 319) || (col >= 400) && (col <= 479) || (col >= 560) && (col <= 639)) ? 4'hF : 4'h0;
        end
    end
        

endmodule // ChipInterface
*/

