//PLAYFIELD VERTICAL SCROLL
//4-bit flip-flop counter
module ls191(
  input logic CE_b, DU, clk, load_b,
  input logic a, b, c, d,
  output logic TC, RC_b,
  output logic qa, qb, qc, qd);
  
  bit [3:0] q;
  
  // If nededge load, set output to input. On clock, set normally
  always_ff @(negedge load, posedge clk) begin
    if(~load_b) q <= {d,c,b,a};
    else if (~CE_b) begin
        if (~DU)
            q <= q + 1;
        else
            q <= q - 1;
    end
  end
  
  assign {qd,qc,qb,qa} = q;
  
  // Set Terminal Count
  always_comb begin
    if (~DU)
        TC = q == 4'b1111;
    else
        TC = q == 4'b0000;    
  end
  
  // Set RC
  always_comb begin
    if (~clk & ~CE_b & TC)
        RC_b = 0;
    else
        RC_b = 1;
  end
endmodule

