//PLAYFIELD VERTICAL SCROLL
//4-bit flip-flop counter
//CTEN = count_enable, DU = down/up, RCO = ripple_clock_output
module ls191(
  input logic CTEN, DU, clk, load,
  input logic a, b, c, d,
  output logic MaxMin, RCO,
  output logic qa, qb, qc, qd);
  
  logic [3:0] q;
  logic [3:0] data;
  
  // Increment or decrement data accordingly
  always_comb
    case({CTEN, DU})
      2'b01 : data[3:0] = q[3:0] - 1;
      2'b00 : data[3:0] = q[3:0] + 1;
      2'b1x : data[3:0] = q[3:0];
    endcase
  
  // If nededge load, set output to input. On clock, set normally.
  always_ff @(negedge load, posedge clk) begin
    if(~load) q[3:0] <= {d,c,b,a};
    else q[3:0] <= data[3:0];
  end
  
  assign {qd,qc,qb,qa} = q[3:0];
  
  // Set MaxMin
  always_comb begin
    if((q[3:0] == 4'b1111 & ~DU) | (q[3:0] == 4'b0000 & DU))
      MaxMin = 1;
    else
      MaxMin = 0;
  end
  
  // Set RCO
  always_comb begin
    if(MaxMin & CTEN & ~clk)
      RCO = 0;
    else
      RCO = 1;
  end      
endmodule

