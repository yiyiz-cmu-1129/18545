//Instructions
`define ADD   4'b1101		//Add
	`define ADDA  2'b11		//Add Address
`define ADDQ  4'b0101		//Add Quick
`define ADDI  3'b011		//Add Immidiate
//Not needed `define ADDX			//Add with extend
`define AND   4'b1100		//Logical AND
	`define ABCD  2'b11		//Add decimal with extend
`define ANDI  3'b001	//And immidiate
`define AS	  4'b1110	//Arithmatic shift
`define BCC	  4'b0110	//Branch Conditionally
`define BCHG  2'b01		//Bit Test and Change
`define BITTEST 3'b100  //Test bits imm
`define BCLR  2'b10		//Bit Test and Clear
//`define BRA     		//Branch always  included in bcc
`define BSET  2'b11		//Bit Test and Set
`define BSR     		//Branch to Subroutine
`define BTST  2'b00		//Bit Test
`define CHK     		//Check Register Against Bounds
`define CLR     		//Clear Operand
`define CMP     		//Compare
`define CMPA 			//Compare Address
`define CMPM 			//Compare Memory
`define CMPI			//Compare Immidiate
`define DBCC			//Test Condition, Decrement, and branch
`define DIVS			//Signed Divide
`define DIVU 			//Unsigned Divide
`define EOR				//Exclusive Or eg. xor
`define EXG				//Exchange Registers
`define EXT 			//Sign Extend
`define JMP				//Jump
`define JSR				//Jump to Subroutine
`define LEA				//Load Effective Address
`define LINK			//Link Stack
`define LSL				//Logical Shift Left
`define LSR 			//Logical Shift Right
`define MOVE			//Move
`define MULS			//Signed Multiply
`define MULU			//Unsigned multiply
`define NBCD			//Negate Decimal with extend
`define NEG 			//Negate
`define NOP				//nop
`define NOT 			//ones complement
`define OR 				//logical or
`define PEA 			//Push Effective Address
`define RESET 			//Reset External Devices
`define ROL 			//Rotate Left without extend
`define ROR 			//Rotate Right without extend
`define ROXL			//Rotate Left with Extend
`define ROXR			//Rotate Right with Extend
`define RTD				//Return and Deallocate
`define RTE 			//Return from exception
`define RTR 			//Return and Restore
`define RTS 			//Return from Subroutine
`define SBCD			//Subtract Decimal with Extend
`define SCC				//Set Conditional
`define STOP			//Stop
`define SUB 			//Subtract
`define SWAP			//Swap Data Register Halves
`define TAS 			//Test and Set Operand
`define TRAP			//Trap
`define TRAPV 			//Trap on overflow
`define TST 			//Test
`define UNLK 			//unlink



//size definitions
`define BYTE 4'b0001
`define WORD 4'b0011
`define LONG 4'b1111

`define IMM 4'b0000

//ALU OPS
`define ALU_ADD
`define ALU_AND 
`define ALU_ASL
`define ALU_ASR
`define ALU_BCHG
`define ALU_BCLR
`define ALU_BSET
`define ALU_BTST



//Registers

//
