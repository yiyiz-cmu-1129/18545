module top(JA1, JA2, JA3, JA4, JB1, JB2, JB3, JB4, SW0, SW1, GCLK,
           LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7);
    input logic JA1, JA2, JA3, JA4;
    input logic JB1, JB2, JB3, JB4;
    input logic SW0, SW1, GCLK;
    output logic LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7;
    
    logic [7:0] count;
    logic CK;
    logic [7:0] leta_out;
    
    always_ff @(posedge GCLK)
        count <= (count >= 114) ? 0 : count + 1;
    
    assign CK = count > 57;

    assign {LD0, LD1, LD2, LD3, LD4, LD5, LD6, LD7} = leta_out; //{4'b0, JA4, JA3, JA2, JA1};
    
    LETA_REP leta(.DB(leta_out), //data out
                  .CS(1'b0), //chip select
                  .CK(CK), //clock - .875MHz
                  .TEST(1'b0), //test-enable
                  .AD({SW1, SW0}), //address
                  .CLKS({JB3, JB1, JA3, JA1}), //clks (from trackball)
                  .DIRS({JB4, JB2, JA4, JA2}), //dirs (from trackball)
                  .RESOLN(1'b1)); //god knows
endmodule
