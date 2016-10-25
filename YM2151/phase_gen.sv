//  KEY CODE [6:4]->Octave [3:0]->Note
//  reg #1B [7:6]control_output [1:0] waveform select
//  sample rate of the audio codec is 48K
module phase_gen 
  (input logic [7:0] key_code,
   input logic [1:0] wave_form, 
   input logic phiM, //clk
   input logic IC_b, //irst_b
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

    logic [15:0] val;
    logic [5:0] step_size;
    logic [11:0] counter; //largest val is 4096

    //tables 
    reg [15:0] square_tbl[0:2499]; //2.5K sample
    reg [15:0] sawtooth_tbl[0:2499]; //2.5K sample
    reg [15:0] triangle_tbl[0:2499]; //2.5K sample

    initial begin
        $readmemh("square.txt",square_tbl);
        $readmemh("sawtooth.txt",sawtooth_tbl);
        $readmemh("triangle.txt",triangle_tbl);
    end 

    always_ff @(posedge phiM, negedge IC_b) begin
        if(~IC_b) begin
            out_val <= 16'd0;
            counter <= 12'd0;
        end 
        else begin 
            if ((counter + step_size) > 12'd2499)
                counter <= 12'd0;
            else begin
                counter <= counter + step_size;
            end 
            if (wave_form==2'd0) out_val <= sawtooth_tbl[counter];
            else if (wave_form==2'd1) out_val <= square_tbl[counter];
            else if (wave_form==2'd2) out_val <= triangle_tbl[counter];
            else out_val <= 16'dx;
        end 
    end 

    always_comb 
    case(key_code[3:0])
      4'd1: step_size = 6'd27;
      4'd2: step_size = 6'd29;
      4'd3: step_size = 6'd31;
      4'd4: step_size = 6'd32;
      4'd5: step_size = 6'd34;
      4'd6: step_size = 6'd36;
      4'd7: step_size = 6'd39;
      4'd8: step_size = 6'd41;
      4'd9: step_size = 6'd43;
      4'd10: step_size = 6'd46;
      4'd11: step_size = 6'd49;
      4'd12: step_size = 6'd51;
    endcase 
  

endmodule


