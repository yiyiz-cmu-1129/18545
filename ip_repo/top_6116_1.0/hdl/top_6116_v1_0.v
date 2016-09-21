
`timescale 1 ns / 1 ps

	module top_6116_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Master Bus Interface to_system
		parameter  C_to_system_START_DATA_VALUE	= 32'hAA000000,
		parameter  C_to_system_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
		parameter integer C_to_system_ADDR_WIDTH	= 32,
		parameter integer C_to_system_DATA_WIDTH	= 32,
		parameter integer C_to_system_TRANSACTIONS_NUM	= 4,

		// Parameters of Axi Slave Bus Interface to_bram
		parameter integer C_to_bram_DATA_WIDTH	= 32,
		parameter integer C_to_bram_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
//            inout wire [7:0] D;
            input wire [10:0] A;
            input wire CS_b, WE_b, OE_b;
            
            //memory interface
            output wire [7:0] data_in;
            output wire [10:0] addr;
            input wire [7:0] data_out;
            output wire clk, we, en;
                    
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Master Bus Interface to_system
		input wire  to_system_init_axi_txn,
		output wire  to_system_error,
		output wire  to_system_txn_done,
		input wire  to_system_aclk,
		input wire  to_system_aresetn,
		output wire [C_to_system_ADDR_WIDTH-1 : 0] to_system_awaddr,
		output wire [2 : 0] to_system_awprot,
		output wire  to_system_awvalid,
		input wire  to_system_awready,
		output wire [C_to_system_DATA_WIDTH-1 : 0] to_system_wdata,
		output wire [C_to_system_DATA_WIDTH/8-1 : 0] to_system_wstrb,
		output wire  to_system_wvalid,
		input wire  to_system_wready,
		input wire [1 : 0] to_system_bresp,
		input wire  to_system_bvalid,
		output wire  to_system_bready,
		output wire [C_to_system_ADDR_WIDTH-1 : 0] to_system_araddr,
		output wire [2 : 0] to_system_arprot,
		output wire  to_system_arvalid,
		input wire  to_system_arready,
		input wire [C_to_system_DATA_WIDTH-1 : 0] to_system_rdata,
		input wire [1 : 0] to_system_rresp,
		input wire  to_system_rvalid,
		output wire  to_system_rready,

		// Ports of Axi Slave Bus Interface to_bram
		input wire  to_bram_aclk,
		input wire  to_bram_aresetn,
		input wire [C_to_bram_ADDR_WIDTH-1 : 0] to_bram_awaddr,
		input wire [2 : 0] to_bram_awprot,
		input wire  to_bram_awvalid,
		output wire  to_bram_awready,
		input wire [C_to_bram_DATA_WIDTH-1 : 0] to_bram_wdata,
		input wire [(C_to_bram_DATA_WIDTH/8)-1 : 0] to_bram_wstrb,
		input wire  to_bram_wvalid,
		output wire  to_bram_wready,
		output wire [1 : 0] to_bram_bresp,
		output wire  to_bram_bvalid,
		input wire  to_bram_bready,
		input wire [C_to_bram_ADDR_WIDTH-1 : 0] to_bram_araddr,
		input wire [2 : 0] to_bram_arprot,
		input wire  to_bram_arvalid,
		output wire  to_bram_arready,
		output wire [C_to_bram_DATA_WIDTH-1 : 0] to_bram_rdata,
		output wire [1 : 0] to_bram_rresp,
		output wire  to_bram_rvalid,
		input wire  to_bram_rready
	);
// Instantiation of Axi Bus Interface to_system
	top_6116_v1_0_to_system # ( 
		.C_M_START_DATA_VALUE(C_to_system_START_DATA_VALUE),
		.C_M_TARGET_SLAVE_BASE_ADDR(C_to_system_TARGET_SLAVE_BASE_ADDR),
		.C_M_AXI_ADDR_WIDTH(C_to_system_ADDR_WIDTH),
		.C_M_AXI_DATA_WIDTH(C_to_system_DATA_WIDTH),
		.C_M_TRANSACTIONS_NUM(C_to_system_TRANSACTIONS_NUM)
	) top_6116_v1_0_to_system_inst (
		.INIT_AXI_TXN(to_system_init_axi_txn),
		.ERROR(to_system_error),
		.TXN_DONE(to_system_txn_done),
		.M_AXI_ACLK(to_system_aclk),
		.M_AXI_ARESETN(to_system_aresetn),
		.M_AXI_AWADDR(to_system_awaddr),
		.M_AXI_AWPROT(to_system_awprot),
		.M_AXI_AWVALID(to_system_awvalid),
		.M_AXI_AWREADY(to_system_awready),
		.M_AXI_WDATA(to_system_wdata),
		.M_AXI_WSTRB(to_system_wstrb),
		.M_AXI_WVALID(to_system_wvalid),
		.M_AXI_WREADY(to_system_wready),
		.M_AXI_BRESP(to_system_bresp),
		.M_AXI_BVALID(to_system_bvalid),
		.M_AXI_BREADY(to_system_bready),
		.M_AXI_ARADDR(to_system_araddr),
		.M_AXI_ARPROT(to_system_arprot),
		.M_AXI_ARVALID(to_system_arvalid),
		.M_AXI_ARREADY(to_system_arready),
		.M_AXI_RDATA(to_system_rdata),
		.M_AXI_RRESP(to_system_rresp),
		.M_AXI_RVALID(to_system_rvalid),
		.M_AXI_RREADY(to_system_rready)
	);

// Instantiation of Axi Bus Interface to_bram
	top_6116_v1_0_to_bram # ( 
		.C_S_AXI_DATA_WIDTH(C_to_bram_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_to_bram_ADDR_WIDTH)
	) top_6116_v1_0_to_bram_inst (
		.S_AXI_ACLK(to_bram_aclk),
		.S_AXI_ARESETN(to_bram_aresetn),
		.S_AXI_AWADDR(to_bram_awaddr),
		.S_AXI_AWPROT(to_bram_awprot),
		.S_AXI_AWVALID(to_bram_awvalid),
		.S_AXI_AWREADY(to_bram_awready),
		.S_AXI_WDATA(to_bram_wdata),
		.S_AXI_WSTRB(to_bram_wstrb),
		.S_AXI_WVALID(to_bram_wvalid),
		.S_AXI_WREADY(to_bram_wready),
		.S_AXI_BRESP(to_bram_bresp),
		.S_AXI_BVALID(to_bram_bvalid),
		.S_AXI_BREADY(to_bram_bready),
		.S_AXI_ARADDR(to_bram_araddr),
		.S_AXI_ARPROT(to_bram_arprot),
		.S_AXI_ARVALID(to_bram_arvalid),
		.S_AXI_ARREADY(to_bram_arready),
		.S_AXI_RDATA(to_bram_rdata),
		.S_AXI_RRESP(to_bram_rresp),
		.S_AXI_RVALID(to_bram_rvalid),
		.S_AXI_RREADY(to_bram_rready)
	);

	// Add user logic here
 /*   
    `ifdef SIM
    wire [10:0][7:0] ram;
    
    always (@posedge CS_b) begin
    
        if(~WE_b & ~OE_b) begin
            ram <= ram;
            ram[A][7:0] <= data_in;
        end
        else ram <= ram;
    end
    assign data_out = ram[A][7:0];
    
    `endif
   */ 
        assign clk = ~CS_b;
        assign we = ~WE_b;
        assign en = OE_b;
        assign addr = A;
        assign D = (~CS_b & ~OE_b & WE_b) ? data_out : 8'bzzzz_zzzz;
        assign data_in = D;
        
        


	// User logic ends

	endmodule
