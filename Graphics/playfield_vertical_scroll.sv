//This is from the other teams git

`include "../lib/LS191.sv"
`include "../lib/LS273.sv"

module playfield_vertical_scroll(
  input logic VSCRLD,
  input logic VBLANK,
  input logic HSYNC,
  input logic HDL,
  input logic [15:0] VBD,
  input logic [15:0] VRD,
  output logic [256:8] PF,
  output logic PFHFLIP,
  output logic [18:1] PP);
  
  logic clk, ripple1, ripple2;
  
  assign clk = ~VBLANK & HSYNC;
  
  ls273 byte_ff(.d({VRD[15:14],VRD[5:0]}),
                .q({PFHFLIP,PP[18],PP[9:4]}),
                .ck(~HDL),
                .clr(1'b0));
                
  ls191 count_1(.a(VBD[0]), .b(VBD[1]), .c(VBD[2]), .d(VBD[3]),
                .qa(PP[1]), .qb(PP[2]), .qc(PP[3]), .qd(PF[8]),
                .clk(clk),
                .load(VSCRLD),
                .DU(~VSCRLD),
                .CTEN(VSCRLD),
                .MaxMin(),
                .RCO(ripple1));
                
  ls191 count_2(.a(VBD[4]), .b(VBD[5]), .c(VBD[6]), .d(VBD[7]),
                .qa(PF[16]), .qb(PF[32]), .qc(PF[64]), .qd(PF[128]),
                .clk(clk),
                .load(VSCRLD),
                .DU(1'b0),
                .CTEN(ripple1),
                .MaxMin(),
                .RCO(ripple2));
  
  ls191 count_3(.a(VBD8), .b(1'b1), .c(1'b1), .d(1'b1),
                .qa(PF[256]), .qb(), .qc(), .qd(),
                .clk(clk),
                .load(VSCRLD),
                .DU(1'b0),
                .CTEN(ripple2),
                .MaxMin(),
                .RCO());
endmodule
