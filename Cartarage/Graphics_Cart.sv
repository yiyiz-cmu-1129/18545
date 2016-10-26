`include "../lib/23128.sv"


module graphics_cart(
input logic SLAP_b, BR_W_b,
input logic [3:0] ROMOUT_b,
input logic MATCH_b, MA18_b, P2,
output logic [6:0] MOSR,


input logic [17:0] MGRA,
input logic [1:0] MGRI,
output logic [7:0] PFSR,

input logic [15:0] MA_from_VMEM, MD_from_VMEM,
output logic [15:0] MD_to_VMEM,

input logic clk
);

/////////Video MicroProcessor Rom////////////////
logic MA18_V_MA15;

control_23128 VMPR_13D(
    MD_to_VMEM[15:8],
    {MA18_V_MA15, MA_from_VMEM[14:1]},
    ROMOUT_b[1],
    MA18_V_MA15,
    clk);

control_23128 VMPR_14D(
    MD_to_VMEM[7:0],
    {MA18_V_MA15, MA_from_VMEM[14:1]},
    ROMOUT_b[1],
    MA18_V_MA15,
    clk);

control_23128 VMPR_15D(
    MD_to_VMEM[15:8],
    {MA18_V_MA15, MA_from_VMEM[14:1]},
    ROMOUT_b[2],
    MA18_V_MA15,
    clk);

control_23128 VMPR_16D(
    MD_to_VMEM[7:0],
    {MA18_V_MA15, MA_from_VMEM[14:1]},
    ROMOUT_b[2],
    MA18_V_MA15,
    clk);

control_23128 VMPR_17D(
    MD_to_VMEM[15:8],
    {MA18_V_MA15, MA_from_VMEM[14:1]},
    ROMOUT_b[3],
    MA18_V_MA15,
    clk);

control_23128 VMPR_18D(
    MD_to_VMEM[7:0],
    {MA18_V_MA15, MA_from_VMEM[14:1]},
    ROMOUT_b[3],
    MA18_V_MA15,
    clk);


///////////////Graphics Palette Select




endmodule
