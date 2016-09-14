

module testbench();
  logic clk, rst;
  logic [15:0] address_bus;
  logic [7:0] data_in, data_out;
  logic write_en, irq, nmi, ready;
  
  cpu my6502(.clk(clk), .reset(rst), .AB(address_bus),
            .DI(data_in), .DO(data_out), .WE(write_en),
            .IRQ(irq), .NMI(nmi), .RDY(ready));

  reg [7:0] mem[65535:0];

  assign data_in = mem[address_bus];
  always_ff @(posedge clk)
	if(write_en) mem[address_bus] <= data_out;
  
  initial begin
	forever #5 clk = ~clk;
  end

   //initial begin
   //   forever @(posedge clk) $display("Time: %d, AB: %h, PC: %h, OP: %h", $time, address_bus, my6502.PC, mem[my6502.PC]);
   //end

  initial begin;
	$readmemh("functional_test_bytecode.hex", mem);
	clk = 1;
	rst = 1;
	ready = 1;
	irq = 0;
	nmi = 0;
        //force my6502.PC = 0;
	#15
	rst = 0;
        //#10
        //release my6502.PC;
	#200 $stop;
  end
endmodule
