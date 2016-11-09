`timescale 1ns / 1ps
`default_nettype none
module testbench();

    //Global
    logic clk100, rst_b;

    logic SC_1H, SC_2H, SC_8H;
    logic sc_rst_b;
    //6502 to IO
    logic [7:0] SDin68k, SDout68k;
    logic SNDNMI_b, ctrl_SNDBUF, ctrl_68kBUF;
    logic WR68k_b, RD68k_b;
    //68k to IO
    logic [7:0] Din68k, Dout68k;
    logic [22:0] A;
    logic SNDWR_b, SNDRD_b;
    logic SNDINT_b;
    logic WL_b;
    logic UNLOCK_b, E2PROM_b, IBUS_b, BW_b;
    logic RLETA_b, TBTEST, TBRE_b;

    //68k to 6502
    logic SELFTEST_b;
    
    //Buttons to 6502
    logic coin_aux, coin_l, coin_r;

    system_clock sc(.clk100(clk100),
                    .rst_b(sc_rst_b),
                    .SC_1H(SC_1H),
                    .SC_2H(SC_2H),
                    .SC_4H(),
                    .SC_8H(SC_8H),
                    .SC_16H(),
                    .SC_32H(),
                    .SC_64H(),
                    .SC_128H(),
                    .SC_256H());

    io_sound dut(.clk100(clk100),
                 .SC_1H(SC_1H),
                 .SC_2H(SC_2H),
                 .SNDRST_b(rst_b),
                 .SDin68k(SDin68k),
                 .SDout68k(SDout68k),
                 .SNDNMI_b(SNDNMI_b),
                 .ctrl_SNDBUF(ctrl_SNDBUF),
                 .ctrl_68kBUF(ctrl_68kBUF),
                 .WR68k_b(WR68k_b),
                 .RD68k_b(RD68k_b),
                 .SELFTEST_b(SELFTEST_b),
                 .coin_aux(coin_aux),
                 .coin_r(coin_r),
                 .coin_l(coin_l));

    io_interface IO(.Din68k(Din68k), //to 68k
                    .Dout68k(Dout68k), //from 68k
                    .A(A), //from 68k
                    .SC_1H(SC_1H),
                    .SC_8H(SC_8H),
                    .SYSRES_b(rst_b),
                    .SNDRST_b(rst_b),
                    .Dout6502(SDout68k), //from 6502
                    .Din6502(SDin68k), //to 6502
                    .SNDWR_b(SNDWR_b), //from 68k
                    .SNDRD_b(SNDRD_b), //from 68k
                    .WR68k_b(WR68k_b), //from 6502
                    .RD68k_b(RD68k_b), //from 6502
                    .ctrl_68kBUF(ctrl_68kBUF), //to 6502 (and possiblyhopefully 68k)
                    .ctrl_SNDBUF(ctrl_SNDBUF), //to 6502
                    .SNDNMI_b(SNDNMI_b), //to 6502
                    .SNDINT_b(SNDINT_b), //to 68k
                    .WL_b(WL_b), //from 68k
                    .UNLOCK_b(UNLOCK_b),
                    .E2PROM_b(E2PROM_b),
                    .IBUS_b(IBUS_b), //from 68k
                    .BW_b(BW_b), //from 68k
                    .RLETA_b(RLETA_b),
                    .TBTEST(TBTEST),
                    .TBRE_b(TBRE_b));

    //Temp assigns
    assign A = 23'b0;
    assign SNDRD_b = 1;
    assign WL_b = 1;
    assign UNLOCK_b = 1;
    assign E2PROM_b = 1;
    assign RLETA_b = 1;
    assign TBTEST = 0;
    assign TBRE_b = 1;
    assign SELFTEST_b = 1; //When 6502 reads from address 1820, it expects this to be 1????

    //Should be hooked to buttons
    assign coin_aux = 1; assign coin_l = 1; assign coin_r = 1;


    

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
        else if (dut.my6502.state == 6'd13 || dut.my6502.state == 6'd5 || dut.my6502.state == 6'd23 || dut.my6502.state == 6'd36 || dut.my6502.state == 6'd34)
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



always @( dut.my6502.state )
    $display( "%06d, PC:%04x State:%s IR:%02x AddrCtrl:%02b SBA:%04h SDin:%02h SDout:%02x SNDBW_b:%01b 6502A:%02x 6502X:%02x 6502S:%02x RAMctrl:%02b SROMctrl:%03b IC:%05d DIMUX:%02h",
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
    instCount,
    dut.my6502.DIMUX);

    initial begin;
        SNDWR_b = 1;
        IBUS_b = 1;
        BW_b = 1;
        Dout68k = 8'h00;

	    clk100 = 1;
	    rst_b = 0;
        sc_rst_b = 0;
        #15 sc_rst_b = 1;
	    @(posedge SC_2H);
	    rst_b <= 1;
        while (instCount <= 1000) @(posedge SC_2H) //Do 1000 instructions
        SNDWR_b <= 1; //Then simulate the 68k sending some data
        IBUS_b <= 1;
        BW_b <= 1;
        @(posedge SC_2H);
        SNDWR_b <= 0;
        IBUS_b <= 0;
        BW_b <= 0;
        Dout68k <= 8'h42;
        @(posedge SC_2H);
        SNDWR_b <= 1;
        IBUS_b <= 1;
        BW_b <= 1;
        #200000
	    //#9000000
        $finish;
    end


endmodule


//Everything matches through inst 1000
