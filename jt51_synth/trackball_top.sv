module trackball_top(JA1, JA2, JA3, JA4, JB1, JB2, JB3, JB4, SW0, SW1, GCLK,
           LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7, addr0, data_outX, data_outY, reset, sync);
    input logic sync;
    input logic JA1, JA2, JA3, JA4;
    input logic JB1, JB2, JB3, JB4;
    input logic SW0, SW1, GCLK, reset;
    output logic LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7;
    output logic addr0; 
    output logic [7:0] data_outX, data_outY;

    logic [7:0] count;
    logic CK;
    logic [7:0] leta_out;
    
//making a little video demo
    logic [11:0] frameBuffer [10:0][9:0]; 
    logic [7:0] data_from_trackball, colorR, colorG;
    logic [10:0] posX, prevPosX; 
    logic [9:0] posY, prevPosY;
    logic [1:0] adr;

    //logic sync;

    assign addr0 = adr[0];
    assign data_outX = posX[10:3];
    assign data_outY = posY[9:2];
    always_ff @(posedge CK, posedge reset) begin
        if(reset) begin 
            adr <= 2'b00;
            posX <= 11'd0;
            posY <= 10'd0;
            prevPosX <= 11'd0;
            prevPosY <= 10'd0;
            colorR <= 8'd0;
            colorG <= 8'd0;
        end
        else begin
            if(sync) begin
            case(adr)
                2'b00: posX <= {data_from_trackball, 3'b000};
                2'b01: posY <= {data_from_trackball, 2'b00};
                2'b10: colorR <= {data_from_trackball};
                2'b11: colorG <= {data_from_trackball};
            endcase
            adr <= adr + 1;
            prevPosX <= posX;
            prevPosY <= posY;
            frameBuffer[posX][posY] <= {colorR[7:4], colorG[7:4], 4'hF};
            if(posX != prevPosX | posY != prevPosY) frameBuffer[prevPosX][prevPosY] <= 12'h000;
            
            frameBuffer[posX + 1][posY] <=  {colorR[7:4], colorG[7:4], 4'hF};
            if(posX != prevPosX | posY != prevPosY) frameBuffer[prevPosX + 1][prevPosY] <= 12'h000;

            frameBuffer[posX -1][posY] <=  {colorR[7:4], colorG[7:4], 4'hF};
            if(posX != prevPosX | posY != prevPosY) frameBuffer[prevPosX - 1][prevPosY] <= 12'h000;
            
            frameBuffer[posX][posY + 1] <=  {colorR[7:4], colorG[7:4], 4'hF};
            if(posX != prevPosX | posY != prevPosY) frameBuffer[prevPosX][prevPosY + 1] <= 12'h000;

            frameBuffer[posX][posY - 1] <=  {colorR[7:4], colorG[7:4], 4'hF};
            if(posX != prevPosX | posY != prevPosY) frameBuffer[prevPosX][prevPosY - 1] <= 12'h000;
            end
            

            
        end
    end
 
    always_ff @(posedge GCLK)
        count <= (count >= 114) ? 0 : count + 1;
    
    assign CK = count > 57;
    assign data_from_trackball = leta_out;
    assign {LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7} = leta_out; //{4'b0, JA4, JA3, JA2, JA1};
    
    LETA_REP leta(.DB(leta_out), //data out
                  .CS(1'b0), //chip select
                  .CK(CK), //clock - .875MHz
                  .TEST(1'b0), //test-enable
                  .AD({1'b0, adr[0]}), //address
                  .CLKS({JB3, JB1, JA3, JA1}), //clks (from trackball)
                  .DIRS({JB4, JB2, JA4, JA2}), //dirs (from trackball)
                  .RESOLN(1'b1)); //god knows
endmodule
