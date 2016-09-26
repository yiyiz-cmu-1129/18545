

module testbench();
  logic clk, rst;
  logic [15:0] address_bus;
  logic [7:0] data_in, data_out;
  logic write_en, irq, nmi, ready;
  
  cpu my6502(.clk(clk), .reset(rst), .AB(address_bus),
            .DI(data_in), .DO(data_out), .WE(write_en),
            .IRQ(irq), .NMI(nmi), .RDY(ready));

  reg [7:0] mem[65535:0];

    always @( my6502.PC, my6502.state, my6502.AB )
        $display( "%t, PC:%04x AB:%04x DI:%02x IR:%02x State:%s", $time, my6502.PC_delayed, my6502.AB, my6502.DI, my6502.IR, my6502.statename);

  always_ff @(posedge clk) //SYNCHRONOUS READS FROM MEMORY FFS
	data_in <= mem[address_bus];

  always_ff @(posedge clk)
	if(write_en) mem[address_bus] <= data_out;
  
  initial begin
	forever #5 clk = ~clk;
  end

  initial begin;
	//The run flow is:
	//Take the address from 0xfffc, 0xfffd
	//Jump to that address
	//Start executing
	$readmemh("mm6502memory.hex", mem);
	clk = 1;
	rst = 1;
	ready = 1;
	irq = 0;
	nmi = 0;
	#15
	rst = 0;
	#30
	//forever @(posedge clk) $stop;
	#10000 $stop;
  end
endmodule
