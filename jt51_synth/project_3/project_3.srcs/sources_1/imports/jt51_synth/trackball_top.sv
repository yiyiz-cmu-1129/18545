module trackball_top(JA, JB, GCLK, BTNC, LD,
               VGA_HS, VGA_VS, VGA_R, VGA_G, VGA_B,
               dataX, dataY);
        input logic [3:0] JA;
        input logic [3:0] JB;
        input logic GCLK, BTNC;
        output logic [7:0] LD;
        output logic VGA_HS, VGA_VS;
        output logic [3:0] VGA_B;
        output logic [3:0] VGA_R;
        output logic [3:0] VGA_G;
        output logic [1:0] [7:0] dataX, dataY;
        
        assign dataX[0] = leta_col[0][7:0];
        assign dataY[0] = leta_row[0][7:0];
        assign dataX[1] = leta_col[1][7:0];
        assign dataY[1] = leta_row[1][7:0];
        
        //Leta
        logic [7:0] count;
        logic CK;
        logic [7:0] leta_out;
        logic [1:0] addr;
        
        logic [1:0] [11:0] leta_row;
        logic [1:0] [11:0] leta_col;
        logic [1:0] [11:0] leta_row_scaled;
        logic [1:0] [11:0] leta_col_scaled;
        logic [1:0] [11:0] leta_row_stored;
        logic [1:0] [11:0] leta_col_stored;
        
        //VGA
        logic reset;
        logic CLOCK_50;
        logic [8:0] row;
        logic [9:0] col;
        
        assign reset = BTNC;
        
    
        assign VGA_R = (row == leta_row_stored[0] || col == leta_col_stored[0]) ? 4'hF : 4'h0;
        assign VGA_B =  (row == leta_row_stored[1] || col == leta_col_stored[1]) ? 4'hF : 4'h0;
        assign VGA_G = 4'b0;
        
        
        //Create CLOCK_50
        always_ff @(posedge GCLK) begin
            if (reset)
                CLOCK_50 <= 0;
            else
                CLOCK_50 <= ~CLOCK_50;
        end
        
        
        //Create CK
        always_ff @(posedge GCLK)
            count <= (count >= 114) ? 0 : count + 1;
        
        assign CK = count > 57;
    
    
        //Assign LEDs
        assign LD = leta_out;
    
    
    
        //Draw point in frame buffer
        always_ff @(posedge CK) begin
            if (reset)
                addr <= 0;
            else begin
                if (addr[0])
                    leta_row[addr[1]] <= leta_out;
                else
                    leta_col[addr[1]] <= leta_out;
                addr <= addr + 1;
            end    
        end
        
        //Fit the screen, 480rowsx640cols
        assign leta_row_scaled[0] = (leta_row[0] * 15) / 8;
        assign leta_col_scaled[0] = (leta_col[0] * 5) / 2;
        assign leta_row_scaled[1] = (leta_row[1] * 15) / 8;
        assign leta_col_scaled[1] = (leta_col[1] * 5) / 2;
        
        always_ff @(posedge CLOCK_50) begin
            if (~VGA_VS) begin
                leta_row_stored <= leta_row_scaled;
                leta_col_stored <= leta_col_scaled;
            end
        end
        
        //CHIPS
        LETA_REP leta(.DB(leta_out), //data out
                      .CS(1'b0), //chip select
                      .CK(CK), //clock - .875MHz
                      .TEST(1'b0), //test-enable
                      .AD(addr), //address
                      .CLKS({JB[2], JB[0], JA[2], JA[0]}), //clks (from trackball)
                      .DIRS({JB[3], JB[1], JA[3], JA[1]}), //dirs (from trackball)
                      .RESOLN(1'b1)); //god knows
                      
        
        vga VGA(CLOCK_50, reset, VGA_HS, VGA_VS, row, col);
endmodule
