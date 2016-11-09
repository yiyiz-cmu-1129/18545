iosm:
	@vlib work
	@vlog io_sound_microprocessor.sv system_clock.sv io_interface.sv io_sound_tb.sv
	@vsim -c -do "run -all" testbench

clean:
	@rm -r work
