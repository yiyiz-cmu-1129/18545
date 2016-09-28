`timescale 1ns / 1ps

module testbench();
    logic clk, rst_b, nmi_b;
    io_sound dut(.phi0(clk),
                 .SNDRST_b(rst_b),
                 .SNDNMI_b(nmi_b));

    initial begin
        $readmemh("rom0.hex", dut.rom0.ram);
        $readmemh("rom1.hex", dut.rom1.ram);
        $readmemh("rom2.hex", dut.rom2.ram);
    end
  
    initial begin
	    forever #5 clk = ~clk;
    end

always @( dut.my6502.PC, dut.my6502.state )
    $display( "%t, PC:%04x State:%s IR:%02x AddrCtrl:%02b SBA:%04x SDin:%02x SDout:%02x SNDBW_b:%01b 6502A:%02x 6502X:%02x 6502S:%02x RAMctrl:%02b SROMctrl:%03b MUSRES:%01b",
    $time,
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
    dut.MUSRES_b);

    initial begin;
	    clk = 1;
	    rst_b = 0;
	    nmi_b = 1;
	    #15
	    rst_b = 1;
	    #400
        $stop;
    end
endmodule
