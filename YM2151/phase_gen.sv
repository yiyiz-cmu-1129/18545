
//  KEY CODE [6:4] Octave [3:0] Note
module phase_gen 
  (input logic [7:0] key_code, 
   input logic )




endmodule phase_gen


module sin_bram();
    reg [15:0] sin_tbl[0:1023];
    
    initial begin
        $readmemh("sine_table.txt",sin_tbl);
    end 


endmodule 
