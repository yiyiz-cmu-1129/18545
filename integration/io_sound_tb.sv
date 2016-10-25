`timescale 1ns / 1ps

module testbench();
    logic clk100, rst_b;
    logic SC_1H, SC_2H;
    logic sc_rst_b;
    
    system_clock sc(.clk100(clk100),
                    .rst_b(sc_rst_b),
                    .SC_1H(SC_1H),
                    .SC_2H(SC_2H),
                    .SC_4H(),
                    .SC_8H(),
                    .SC_16H(),
                    .SC_32H(),
                    .SC_64H(),
                    .SC_128H(),
                    .SC_256H());

    io_sound dut(.clk100(clk100),
                 .SC_1H(SC_1H),
                 .SC_2H(SC_2H),
                 .SNDRST_b(rst_b));

    initial begin
        $readmemh("rom0.hex", dut.rom0.ram);
        $readmemh("rom1.hex", dut.rom1.ram);
        $readmemh("rom2.hex", dut.rom2.ram);
    end
  
    initial begin
	    forever #5 clk100 = ~clk100;
    end

//always @(clk100)
//    $display("%t, count:%03d, clk:%01b", $time, sc.count100, SC_1H);


    longint instCount;
    always @(dut.my6502.state)
        if (~rst_b)
            instCount <= 0;
        else if (dut.my6502.state == 6'd13 || dut.my6502.state == 6'd5 || dut.my6502.state == 6'd23 || dut.my6502.state == 6'd36)
            instCount <= instCount + 1;

    longint cycles100;
    always @(posedge clk100)
        if (~rst_b)
            cycles100 <= 0;
        else
            cycles100 <= cycles100 + 1;
    
    longint cycles3p5;
    always @(posedge SC_2H)
        if (~rst_b)
            cycles3p5 <= 0;
        else
            cycles3p5 <= cycles3p5 + 1;



always @( dut.my6502.PC, dut.my6502.state )
    $display( "%d, PC:%04x State:%s IR:%02x AddrCtrl:%02b SBA:%04x SDin:%02x SDout:%02x SNDBW_b:%01b 6502A:%02x 6502X:%02x 6502S:%02x RAMctrl:%02b SROMctrl:%03b RD68k:%01b IC:%05d",
    cycles3p5,
    dut.my6502.PC,
    dut.my6502.statename,
    dut.my6502.IR,
    dut.my6502toAddrDec,
    dut.SBA,
    dut.SDin,
    dut.SDout,
    dut.SNDBW_b,
    dut.my6502.A,
    dut.my6502.X,
    dut.my6502.S,
    {dut.RAM_CS1_b, dut.RAM_CS0_b},
    dut.SROM_b,
    dut.RD68k_b,
    instCount);

    initial begin;
	    clk100 = 1;
	    rst_b = 0;
        sc_rst_b = 0;
        #15 sc_rst_b = 1;
	    @(posedge SC_2H);
	    rst_b <= 1;
	    #40000000
        $stop;
    end
endmodule
