//  KEY CODE [6:4]->Octave [3:0]->Note
//  sample rate of the audio codec is 48K
module phase_gen 
  (input logic [7:0] key_code, 
   input logic phiM, //clk
   input logic IC_b, //rst_b
   output logic [15:0] out_val);

// sample rate in the table is 2.5K 
// Sample audio is 48K

// step size = note_freq * table_sample_size / audio_sample_rate

// Octave 5          step size                               Real Freq  Delta 
// 1. C -> 523 HZ    27.24 => 27                             518.4 HZ   4.6
// 2. C# -> 554 HZ   28.85 => 29                             556.8 HZ   2.8
// 3. D -> 587 HZ    30.57 => 31                             595.2 HZ   8.2
// 4. D# -> 622 HZ   31.40 => 32                             614.4 HZ   7.6 
// 5. E -> 659 HZ    34.32 => 34                             652.8 HZ   6.2
// 6. F -> 698 HZ    36.35 => 36                             691.2 HZ   6.8 
// 7. F# -> 740 HZ   38.54 => 39                             748.8 HZ   8.8 
// 8. G -> 784 HZ    40.83 => 41                             787.2 HZ   3.2 
// 9. G# -> 831 HZ   43.28 => 43                             825.6 HZ   4.4 
// 10.A  -> 880 HZ   45.83 => 46                             883.2 Hz   3.2 
// 11.A# -> 932 HZ   48.54 => 49                             940.8 Hz   7.2 
// 12 B -> 988 HZ    51.46 => 51                             979.2 Hz   8.8

   



endmodule phase_gen


module sin_bram();
    reg [15:0] square_tbl[0:2499]; //2.5K sample
    reg [15:0] sawtooth_tbl[0:2499]; //2.5K sample
    reg [15:0] triangle_tbl[0:2499]; //2.5K sample

    initial begin
        $readmemh("square.txt",square_tbl);
        $readmemh("sawtooth.txt",sawtooth_tbl);
        $readmemh("triangle.txt",triangle_tbl);
    end 

endmodule 
