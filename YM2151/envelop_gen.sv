// reg #60-7F total_level [6:0]  
//            Reg = #60 + 8 * DEV + Channel number(0-7)
// reg #80-9F attack rate [4:0]  
//            Reg = #80 + 8 * DEV + Channel number(0-7)
// reg #A0-BF First decay rate [4:0]
//            Reg = #A0 + 8 * DEV + Channel number(0-7)
// reg #C0-DF Second decay rate [4:0]
//            Reg = #C0 + 8 * DEV + Channel number[0:7]
// reg #E0-DF first_decay_level [3:0] +  Release rate [3:0]
//            Reg = #E0 + 8 * DEV + Channel number[0:7]
module envelope_generator
(input logic phiM, //clk
 input logic IC_b, //rst_b
 input logic note_on, note_off,//not sure where to get now
 input logic [6:0] total_level, 
 input logic [4:0] attack_rate, 
 input logic [4:0] first_decay_rate, 
 input logic [4:0] second_decay_rate, 
 input logic [3:0] first_decay_level,
 input logic [3:0] release_rate, 
 output logic [9:0] EG, //output to FM operator 
 output logic busy);//output to FM operator 
 
    enum logic [4:0] {
	  IDLE = 5'b00001, 
	  ATTACK = 5'b00010,
	  DECAY = 5'b00100,
	  SUSTAIN = 5'b01000,
	  RELEASE = 5'b10000
	  } cs, ns;

    //may need counter later
    //logic [4:0] x_attack;
    //logic [4:0] x_1_decay;
    //logic [4:0] x_2_decay;
    //logic [4:0] x_release;

    logic [9:0] second_decay_level;

  	always_ff@(posedge phiM, negedge IC_b) begin
    	if(~IC_b) cs <= IDLE;
    	else begin
          cs <= ns;
          if (cs == SUSTAIN) second_decay_level <= EG;
      end 
  	end	

  	//next state logic
  	always_comb begin
  		case(cs)
  			IDLE: begin
  				if(note_on)
  					ns = ATTACK;
  				else
  					ns = IDLE;
  			end
  			ATTACK: begin
          // max is 0dB
  				if((total_level+attack_rate) > 0)
  					ns = DECAY;
  				else
  					ns = ATTACK;
  			end
  			DECAY: begin
  				if((10'b0 - first_decay_rate) < first_decay_level) 
					ns = SUSTAIN;
  				else
  					ns = DECAY;
  			end
  			SUSTAIN: begin
  				if(note_off)
  					ns = RELEASE;
  				else
  					ns = SUSTAIN;
  			end
  			RELEASE: begin
          //max attenuation is 96dB
  				if((second_decay_level - release_rate) < 10'd96)
  					ns = IDLE;
  				else
  					ns = RELEASE;
  			end
  		endcase
  	end

  	//output logic
  	always_comb begin
  		case(cs)
  			IDLE:begin
  				EG = total_level;
  				busy = 1'b0;
  			end
  			ATTACK:begin
  				EG = total_level + attack_rate;
  				busy = 1'b1;
  			end
  			DECAY:begin
  				EG = 10'b0 - first_decay_rate;
  				busy = 1'b1;
  			end
  			SUSTAIN:begin
  				EG = first_decay_level - second_decay_rate;
  				busy = 1'b1;
  			end
  			RELEASE:begin
  				EG = second_decay_level - release_rate;
  				busy = 1'b1;
  			end
  		endcase
  	end

endmodule:envelope_generator
