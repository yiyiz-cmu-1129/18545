all:
	@vlib work
	@vlog cpu.v ALU.v 6502_testbench.sv
	@vsim -c -do "run -all" testbench

clean:
	@rm -r work
