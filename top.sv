module top(JA1, JA2, JA3, JA4, JB1, JB2, JB3, JB4, GCLK, BTNC,
           LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7,
           VGA_HS, VGA_VS,
           VGA_R, VGA_G, VGA_B);
    input logic JA1, JA2, JA3, JA4;
    input logic JB1, JB2, JB3, JB4;
    input logic GCLK, BTNC;
    output logic LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7;
    output logic VGA_HS, VGA_VS;
    output logic [3:0] VGA_B;
    output logic [3:0] VGA_R;
    output logic [3:0] VGA_G;
    
    //Leta
    logic [7:0] count;
    logic CK;
    logic [7:0] leta_out;
    logic addr;
    
    logic [11:0] leta_row;
    logic [11:0] leta_col;
    logic [11:0] leta_row_scaled;
    logic [11:0] leta_col_scaled;
    logic [11:0] leta_row_stored;
    logic [11:0] leta_col_stored;
    
    //VGA
    logic reset;
    logic CLOCK_50;
    logic [8:0] row;
    logic [9:0] col;
    
    assign reset = BTNC;
    

    assign {VGA_R, VGA_G, VGA_B} = (row == leta_row_stored && col || col == leta_col_stored) ? 12'hFFF : 12'h0;
    
    
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
    assign {LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7} = leta_out; //{4'b0, JA4, JA3, JA2, JA1};



    //Draw point in frame buffer
    always_ff @(posedge CK) begin
        if (reset)
            addr <= 0;
        else begin
            if (addr)
                leta_row <= leta_out;
            else
                leta_col <= leta_out;
            addr <= ~addr;
        end    
    end
    
    //Fit the screen, 480rowsx640cols
    assign leta_row_scaled = (leta_row * 15) / 8;
    assign leta_col_scaled = (leta_col * 5) / 2;
    
    always_ff @(posedge CLOCK_50) begin
        if (VGA_VS) begin
            leta_row_stored <= leta_row_scaled;
            leta_col_stored <= leta_col_scaled;
        end
    end
    
    //CHIPS
    LETA_REP leta(.DB(leta_out), //data out
                  .CS(1'b0), //chip select
                  .CK(CK), //clock - .875MHz
                  .TEST(1'b0), //test-enable
                  .AD({1'b0, addr}), //address
                  .CLKS({JB3, JB1, JA3, JA1}), //clks (from trackball)
                  .DIRS({JB4, JB2, JA4, JA2}), //dirs (from trackball)
                  .RESOLN(1'b1)); //god knows
                  
    
    vga VGA(CLOCK_50, reset, VGA_HS, VGA_VS, row, col);
endmodule
