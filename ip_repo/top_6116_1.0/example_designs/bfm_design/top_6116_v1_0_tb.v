
`timescale 1 ns / 1 ps

`include "top_6116_v1_0_tb_include.vh"

// lite_response Type Defines
`define RESPONSE_OKAY 2'b00
`define RESPONSE_EXOKAY 2'b01
`define RESP_BUS_WIDTH 2
`define BURST_TYPE_INCR  2'b01
`define BURST_TYPE_WRAP  2'b10

// AMBA AXI4 Lite Range Constants
`define to_bram_MAX_BURST_LENGTH 1
`define to_bram_DATA_BUS_WIDTH 32
`define to_bram_ADDRESS_BUS_WIDTH 32
`define to_bram_MAX_DATA_SIZE (`to_bram_DATA_BUS_WIDTH*`to_bram_MAX_BURST_LENGTH)/8

module top_6116_v1_0_tb;
	reg tb_ACLK;
	reg tb_ARESETn;

	reg to_system_INIT_AXI_TXN;
	wire to_system_TXN_DONE;
	wire to_system_ERROR;

	// Create an instance of the example tb
	`BD_WRAPPER dut (.ACLK(tb_ACLK),
				.ARESETN(tb_ARESETn),
				.to_system_TXN_DONE(to_system_TXN_DONE),
				.to_system_ERROR(to_system_ERROR),
				.to_system_INIT_AXI_TXN(to_system_INIT_AXI_TXN));

	// Local Variables

	// AMBA to_bram AXI4 Lite Local Reg
	reg [`to_bram_DATA_BUS_WIDTH-1:0] to_bram_rd_data_lite;
	reg [`to_bram_DATA_BUS_WIDTH-1:0] to_bram_test_data_lite [3:0];
	reg [`RESP_BUS_WIDTH-1:0] to_bram_lite_response;
	reg [`to_bram_ADDRESS_BUS_WIDTH-1:0] to_bram_mtestAddress;
	reg [3-1:0]   to_bram_mtestProtection_lite;
	integer to_bram_mtestvectorlite; // Master side testvector
	integer to_bram_mtestdatasizelite;
	integer result_slave_lite;


	// Simple Reset Generator and test
	initial begin
		tb_ARESETn = 1'b0;
	  #500;
		// Release the reset on the posedge of the clk.
		@(posedge tb_ACLK);
	  tb_ARESETn = 1'b1;
		@(posedge tb_ACLK);
	end

	// Simple Clock Generator
	initial tb_ACLK = 1'b0;
	always #10 tb_ACLK = !tb_ACLK;

	//------------------------------------------------------------------------
	// TEST LEVEL API: CHECK_RESPONSE_OKAY
	//------------------------------------------------------------------------
	// Description:
	// CHECK_RESPONSE_OKAY(lite_response)
	// This task checks if the return lite_response is equal to OKAY
	//------------------------------------------------------------------------
	task automatic CHECK_RESPONSE_OKAY;
		input [`RESP_BUS_WIDTH-1:0] response;
		begin
		  if (response !== `RESPONSE_OKAY) begin
			  $display("TESTBENCH ERROR! lite_response is not OKAY",
				         "\n expected = 0x%h",`RESPONSE_OKAY,
				         "\n actual   = 0x%h",response);
		    $stop;
		  end
		end
	endtask

	//------------------------------------------------------------------------
	// TEST LEVEL API: COMPARE_LITE_DATA
	//------------------------------------------------------------------------
	// Description:
	// COMPARE_LITE_DATA(expected,actual)
	// This task checks if the actual data is equal to the expected data.
	// X is used as don't care but it is not permitted for the full vector
	// to be don't care.
	//------------------------------------------------------------------------
	`define S_AXI_DATA_BUS_WIDTH 32 
	task automatic COMPARE_LITE_DATA;
		input [`S_AXI_DATA_BUS_WIDTH-1:0]expected;
		input [`S_AXI_DATA_BUS_WIDTH-1:0]actual;
		begin
			if (expected === 'hx || actual === 'hx) begin
				$display("TESTBENCH ERROR! COMPARE_LITE_DATA cannot be performed with an expected or actual vector that is all 'x'!");
		    result_slave_lite = 0;
		    $stop;
		  end

			if (actual != expected) begin
				$display("TESTBENCH ERROR! Data expected is not equal to actual.",
				         "\nexpected = 0x%h",expected,
				         "\nactual   = 0x%h",actual);
		    result_slave_lite = 0;
		    $stop;
		  end
			else 
			begin
			   $display("TESTBENCH Passed! Data expected is equal to actual.",
			            "\n expected = 0x%h",expected,
			            "\n actual   = 0x%h",actual);
			end
		end
	endtask

	task automatic to_bram_TEST;
		begin
			$display("---------------------------------------------------------");
			$display("EXAMPLE TEST : to_bram");
			$display("Simple register write and read example");
			$display("---------------------------------------------------------");

			to_bram_mtestvectorlite = 0;
			to_bram_mtestAddress = `to_bram_SLAVE_ADDRESS;
			to_bram_mtestProtection_lite = 0;
			to_bram_mtestdatasizelite = `to_bram_MAX_DATA_SIZE;

			 result_slave_lite = 1;

			for (to_bram_mtestvectorlite = 0; to_bram_mtestvectorlite <= 3; to_bram_mtestvectorlite = to_bram_mtestvectorlite + 1)
			begin
			  dut.`BD_INST_NAME.master_0.cdn_axi4_lite_master_bfm_inst.WRITE_BURST_CONCURRENT( to_bram_mtestAddress,
				                     to_bram_mtestProtection_lite,
				                     to_bram_test_data_lite[to_bram_mtestvectorlite],
				                     to_bram_mtestdatasizelite,
				                     to_bram_lite_response);
			  $display("EXAMPLE TEST %d write : DATA = 0x%h, lite_response = 0x%h",to_bram_mtestvectorlite,to_bram_test_data_lite[to_bram_mtestvectorlite],to_bram_lite_response);
			  CHECK_RESPONSE_OKAY(to_bram_lite_response);
			  dut.`BD_INST_NAME.master_0.cdn_axi4_lite_master_bfm_inst.READ_BURST(to_bram_mtestAddress,
				                     to_bram_mtestProtection_lite,
				                     to_bram_rd_data_lite,
				                     to_bram_lite_response);
			  $display("EXAMPLE TEST %d read : DATA = 0x%h, lite_response = 0x%h",to_bram_mtestvectorlite,to_bram_rd_data_lite,to_bram_lite_response);
			  CHECK_RESPONSE_OKAY(to_bram_lite_response);
			  COMPARE_LITE_DATA(to_bram_test_data_lite[to_bram_mtestvectorlite],to_bram_rd_data_lite);
			  $display("EXAMPLE TEST %d : Sequential write and read burst transfers complete from the master side. %d",to_bram_mtestvectorlite,to_bram_mtestvectorlite);
			  to_bram_mtestAddress = to_bram_mtestAddress + 32'h00000004;
			end

			$display("---------------------------------------------------------");
			$display("EXAMPLE TEST to_bram: PTGEN_TEST_FINISHED!");
				if ( result_slave_lite ) begin                                        
					$display("PTGEN_TEST: PASSED!");                 
				end	else begin                                         
					$display("PTGEN_TEST: FAILED!");                 
				end							   
			$display("---------------------------------------------------------");
		end
	endtask

	// Create the test vectors
	initial begin
		// When performing debug enable all levels of INFO messages.
		wait(tb_ARESETn === 0) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);  

		dut.`BD_INST_NAME.master_0.cdn_axi4_lite_master_bfm_inst.set_channel_level_info(1);

		// Create test data vectors
		to_bram_test_data_lite[0] = 32'h0101FFFF;
		to_bram_test_data_lite[1] = 32'habcd0001;
		to_bram_test_data_lite[2] = 32'hdead0011;
		to_bram_test_data_lite[3] = 32'hbeef0011;
	end

	// Drive the BFM
	initial begin
		// Wait for end of reset
		wait(tb_ARESETn === 0) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     

		to_bram_TEST();

	end

	// Drive the BFM
	initial begin
		// Wait for end of reset
		wait(tb_ARESETn === 0) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     
		wait(tb_ARESETn === 1) @(posedge tb_ACLK);     

		to_system_INIT_AXI_TXN = 1'b0;
		#500 to_system_INIT_AXI_TXN = 1'b1;

		$display("EXAMPLE TEST to_system:");
		wait( to_system_TXN_DONE == 1'b1);
		$display("to_system: PTGEN_TEST_FINISHED!");
		if ( to_system_ERROR ) begin
		  $display("PTGEN_TEST: FAILED!");
		end else begin
		  $display("PTGEN_TEST: PASSED!");
		end

	end

endmodule
