module ls273
 (input logic [7:0] d,
  input logic ck, clr,
  output logic [7:0] q);
  
  always_ff @(negedge clr, posedge ck) begin
    if(~clr) q[7:0] <= 0;
    else q[7:0] <= d[7:0];
  end
endmodule