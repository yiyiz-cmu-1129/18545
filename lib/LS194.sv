/ Left-right shift register
//Also found this module
module ls194(
  input logic clr, clk,
  input logic s0, s1,
  input logic SR, SL,
  input logic a, b, c, d,
  output logic qa, qb, qc, qd);
  
  logic [3:0] data;
  
  always_comb
    case({s1, s0})
      2'b00 : data[3:0] = q[3:0];
      2'b11 : data[3:0] = {a, b, c, d};
      2'b01 : data[3:0] = {SR, a, b, c};
      2'b10 : data[3:0] = {b, c, d, SL};
    endcase
    
  always_ff @(negedge clr, posedge clk) begin
    if(~clr) {qa, qb, qc, qd} <= 4'd0;
    else {qa, qb, qc, qd} <= data[3:0];
  end
endmodule
