`include "68010Defines.vh"
//This is the decoder
module decoder(reg1, reg2, reg_dest, alu_op, size, 
	mem_read, reg_vs_imm, sign_extend, cond_code_update,
	quick, br, jump, br_sub, inst);
	output logic [3:0] reg1, reg2, reg_dest, alu_op, size;
	output logic mem_read, reg_vs_imm, sign_extend; 
	output logic cond_code_update, quick, br, jump, br_sub;
	input logic [15:0] inst;

	logic [2:0] mode;
	logic mem_read_mode, mem_read_inst;
	assign mem_read = mem_read_inst | mem_read_mode;
	always_comb begin
		mem_read = 0;
		reg1 = 0;
		reg2 = 0;
		reg_dest = 0;
		reg_vs_imm = 0;
		alu_op = 0;
		size = `BYTE;
		quick = 0;
        jump = 0;
		mode = inst[5:3];
		br = 0;
		br_sub = 0;
		cond_code_update = 1;
		case(mode)
			3'b000: begin
				reg1 = {0, inst[2:0]};
				reg2 = {0, inst[11:9]};
			end
			3'b001: begin
				reg1 = {1, inst[2:0]};
				reg2 = {1, inst[11:9]};
			end
			3'b010: begin
				reg1 = {1, inst[2:0]};
				reg2 = {1, inst[11:9]};
				mem_read_mode = 1;
			end
		endcase


		//This is the main decode area
		case(inst[15:11])
			//Byte only operation
			`ADD: begin
				alu_op = `ALU_ADD;
				case(inst[7:6])
					2'b00: begin
						size = `BYTE;
						reg_dest = (inst[8]) ? reg1 : reg2;
					end
					2'b01: begin
						size = `WORD;
						reg_dest = (inst[8]) ? reg1 : reg2;
					end
					2'b10: begin
						size = `LONG;
						reg_dest = (inst[8]) ? reg1 : reg2;
					end
					//Why the put the an ADDA instruction like this no idea
					`ADDA: begin
						size = (inst[8]) ? `LONG : `WORD;
						reg_dest = reg1;
						sign_extend = 1;
						cond_code_update = 0;
					end
				endcase
			end
			`ADDQ: begin
				alu_op = `ALU_ADD;
				quick = 1;
				reg_dest = reg1;
				case(inst[7:6])
					2'b00: size = `BYTE;
					2'b01: size = `WORD;
					2'b10: size = `LONG;
				endcase
			end
			`AND: begin
				case(inst[7:6])
					2'b00: begin
						size = `BYTE;
						alu_op = `ALU_AND;
						reg_dest = (inst[8]) ? reg1 : reg2;
					end
					2'b01: begin
						size = `WORD;
						alu_op = `ALU_AND;
						reg_dest = (inst[8]) ? reg1 : reg2;
					end
					2'b10: begin
						size = `LONG;
						alu_op = `ALU_AND;
						reg_dest = (inst[8]) ? reg1 : reg2;
					end
					//Why did they decided to put this with the 
					//and I will never know...
					`ABCD: begin
						alu_op = `ALU_ADD;
						mem_read_inst = inst[3];
						reg_dest = reg2;
						sign_extend = 1;
						size = `BYTE;
					end
				endcase
			end
			`AS: begin
				alu_op = (inst[8]) ? `ALU_ASL : `ALU_ASR;
				case(inst[7:6])
					2'b00: begin
						size = `BYTE;
						mode = 3'b000;
						quick = ~inst[5];
					end
					2'b01: begin
						size = `WORD;
						mode = 3'b000;
						quick = ~inst[5];
					end
					2'b10: begin 
						size = `LONG;
						mode = 3'b000;
						quick = ~inst[5];
					end
					2'b11: begin
						size = `LONG;
						mem_read_inst = 1;
					end
				endcase
				reg_dest = reg1;
			end
			`BCC: begin
				if(inst[7:0] == 8'd0) size = `WORD;
				if(inst[7:0] == 8'hFF) size = `LONG;
				reg_vs_imm = 1;
				br = 1;
				cond_code_update = 0;
                if(inst[11:8] == 4'd0) jump = 1;
                else if(inst[11:8] == `BSR) begin 
                	br_sub = 1;
                	jump = 1;
                end
                else alu_op = {1, inst[11:8]};
			end
            `CHK: begin
            	case(inst[8:6])
            		3'b110: begin //check
            			size = `WORD;
            			alu_op = `ALU_CHK;
            		end
            		3'b000: begin //CLR byte
            			size = `BYTE;
            			alu_op = `ALU_CLR;
            			reg_dest = reg1;
            		end
            		3'b001: begin //CLR word
            			size = `WORD;
            			alu_op = `ALU_CLR;
            			reg_dest = reg1;
            		end
            		3'b010: begin //CLR LONG
            			size = `LONG;
            			alu_op = `ALU_CLR;
            			reg_dest = reg1;
            		end
            	endcase
            end
            `CMP: begin
            	reg_dest = reg1;
            	case(inst[8:6])
            		3'b000: begin
            			size = `BYTE;
            			alu_op = `ALU_CMP;
            		end
            		3'b001: begin
            			size = `WORD;
            			alu_op = `ALU_CMP;
            		end
            		3'b010: begin
            			size = `LONG;
            			alu_op = `ALU_CMP;
            		end
            		3'b011: begin
            			size = `WORD;
            			alu_op = `ALU_CMPA;
            		end
            		3'b111: begin
            			size = `LONG;
            			alu_op = `ALU_CMPA;
            		end
            	endcase
            end
			`IMM: begin
                if(inst[8]) begin
                    case(inst[7:6])
                        `BCHG: begin
                            reg_dest = reg1;
                            alu_op = `ALU_BCHG;
                            size = `LONG;
                        end
                        `BCLR: begin
                            reg_dest = reg1;
                            alu_op = `ALU_BCLR;
                            size = `LONG;
                        end
                        `BSET: begin
                            reg_dest = reg1;
                            alu_op = `ALU_BSET;
                            size = `LONG;
                        end
                        `BTST: begin
                            reg_dest = reg1;
                            alu_op = `ALU_BTST;
                            size = `LONG;
                        end    
                    endcase
                end
                else begin
				    case(inst[11:9])
					    `ADDI: begin
						    alu_op = `ALU_ADD;
						    reg_vs_imm = 1;
						    case(inst[7:6])
							    2'b00: size = `BYTE;
							    2'b01: size = `WORD;
							    2'b10: size = `LONG;
						    endcase
						    reg_dest = reg1;
					    end
					    `ANDI: begin
						    alu_op = `ALU_AND;
						    reg_vs_imm = 1;
						    case(inst[7:6])
							    2'b00: size = `BYTE;
							    2'b01: size = `WORD;
							    2'b10: size = `LONG;
						    endcase
						    reg_dest = reg1;
					    end
                        `BITTEST: begin
                            case(inst[7:6])
                                `BCHG: begin
                                    reg_dest = reg1;
                                    alu_op = `ALU_BCHG;
                                    size = `BYTE;
                                    reg_vs_imm = 1;
                                end
                                `BCLR: begin
                                    reg_dest = reg1;
                                    alu_op = `ALU_BCLR;
                                    size = `BYTE;
                                    reg_vs_imm = 1;
                                end
                                `BSET: begin
                                    reg_dest = reg1;
                                    alu_op = `ALU_BSET;
                                    size = `BYTE;
                                    reg_vs_imm = 1;
                                end
                                `BTST: begin
                                    reg_dest = reg1;
                                    alu_op = `ALU_BTST;
                                    size = `BYTE;
                                    reg_vs_imm = 1;
                                end
                            endcase
					    end
				    endcase
                end
			end

		endcase
	end
endmodule
