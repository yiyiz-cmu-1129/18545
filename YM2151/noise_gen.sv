//reg #0F
//f_noise = clock/(32*noise_reg[4:0])
//noise_reg[7] is noise enable

module noise_gen
  (input logic [7:0] noise_reg,
   output logic [9:0] noise_divisor);

   always_comb 
   begin
       if (noise_reg[7]) begin
           //divisor is 32*noise_reg[4:0] = 2^5 * noise_reg[4:0]
           noise_divisor = noise_reg[5:0] << 5;
       end 
       else begin
           // noise not enabled, divisor is 0 
           noise_divisor = 10'd0;
       end 
   end

endmodule 
