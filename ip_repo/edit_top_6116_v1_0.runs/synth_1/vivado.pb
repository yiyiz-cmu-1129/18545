

Command: %s
53*	vivadotcl2Q
=synth_design -top top_6116_v1_0_to_bram -part xc7z020clg484-12default:defaultZ4-113h px
7
Starting synth_design
149*	vivadotclZ4-321h px
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7z0202default:defaultZ17-347h px
�
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7z0202default:defaultZ17-349h px
�
�The version limit for your license is '%s' and will expire in %s days. A version limit expiration means that, although you may be able to continue to use the current version of tools or IP with this license, you will not be eligible for any updates or new releases.
519*common2
2016.072default:default2
-502default:defaultZ17-1223h px
�
%s*synth2�
�Starting Synthesize : Time (s): cpu = 00:00:04 ; elapsed = 00:00:05 . Memory (MB): peak = 1063.824 ; gain = 154.520 ; free physical = 8966 ; free virtual = 21346
2default:defaulth px
�
synthesizing module '%s'638*oasys2)
top_6116_v1_0_to_bram2default:default2~
h/afs/ece.cmu.edu/usr/cmeredit/Private/class/18545/18545/ip_repo/top_6116_1.0/hdl/top_6116_v1_0_to_bram.v2default:default2
42default:default8@Z8-638h px
e
%s*synth2P
<	Parameter C_S_AXI_DATA_WIDTH bound to: 32 - type: integer 
2default:defaulth px
d
%s*synth2O
;	Parameter C_S_AXI_ADDR_WIDTH bound to: 4 - type: integer 
2default:defaulth px
Z
%s*synth2E
1	Parameter ADDR_LSB bound to: 2 - type: integer 
2default:defaulth px
c
%s*synth2N
:	Parameter OPT_MEM_ADDR_BITS bound to: 1 - type: integer 
2default:defaulth px
�
default block is never used226*oasys2~
h/afs/ece.cmu.edu/usr/cmeredit/Private/class/18545/18545/ip_repo/top_6116_1.0/hdl/top_6116_v1_0_to_bram.v2default:default2
2232default:default8@Z8-226h px
�
default block is never used226*oasys2~
h/afs/ece.cmu.edu/usr/cmeredit/Private/class/18545/18545/ip_repo/top_6116_1.0/hdl/top_6116_v1_0_to_bram.v2default:default2
3642default:default8@Z8-226h px
�
%done synthesizing module '%s' (%s#%s)256*oasys2)
top_6116_v1_0_to_bram2default:default2
12default:default2
12default:default2~
h/afs/ece.cmu.edu/usr/cmeredit/Private/class/18545/18545/ip_repo/top_6116_1.0/hdl/top_6116_v1_0_to_bram.v2default:default2
42default:default8@Z8-256h px
�
!design %s has unconnected port %s3331*oasys2)
top_6116_v1_0_to_bram2default:default2#
S_AXI_AWPROT[2]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2)
top_6116_v1_0_to_bram2default:default2#
S_AXI_AWPROT[1]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2)
top_6116_v1_0_to_bram2default:default2#
S_AXI_AWPROT[0]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2)
top_6116_v1_0_to_bram2default:default2#
S_AXI_ARPROT[2]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2)
top_6116_v1_0_to_bram2default:default2#
S_AXI_ARPROT[1]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2)
top_6116_v1_0_to_bram2default:default2#
S_AXI_ARPROT[0]2default:defaultZ8-3331h px
�
%s*synth2�
�Finished Synthesize : Time (s): cpu = 00:00:05 ; elapsed = 00:00:06 . Memory (MB): peak = 1100.113 ; gain = 190.809 ; free physical = 8929 ; free virtual = 21309
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Constraint Validation : Time (s): cpu = 00:00:05 ; elapsed = 00:00:06 . Memory (MB): peak = 1100.113 ; gain = 190.809 ; free physical = 8929 ; free virtual = 21308
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
S
%s*synth2>
*Start Loading Part and Timing Information
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
G
%s*synth22
Loading part: xc7z020clg484-1
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:05 ; elapsed = 00:00:06 . Memory (MB): peak = 1108.113 ; gain = 198.809 ; free physical = 8929 ; free virtual = 21308
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
S
Loading part %s157*device2#
xc7z020clg484-12default:defaultZ21-403h px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:05 ; elapsed = 00:00:06 . Memory (MB): peak = 1116.117 ; gain = 206.812 ; free physical = 8921 ; free virtual = 21301
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
B
%s*synth2-

Report RTL Partitions: 
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
I
%s*synth24
 Start RTL Component Statistics 
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
H
%s*synth23
Detailed RTL Component Info : 
2default:defaulth px
:
%s*synth2%
+---Registers : 
2default:defaulth px
W
%s*synth2B
.	               32 Bit    Registers := 5     
2default:defaulth px
W
%s*synth2B
.	                4 Bit    Registers := 2     
2default:defaulth px
W
%s*synth2B
.	                2 Bit    Registers := 2     
2default:defaulth px
W
%s*synth2B
.	                1 Bit    Registers := 5     
2default:defaulth px
6
%s*synth2!
+---Muxes : 
2default:defaulth px
W
%s*synth2B
.	   2 Input     32 Bit        Muxes := 4     
2default:defaulth px
W
%s*synth2B
.	   4 Input     32 Bit        Muxes := 5     
2default:defaulth px
W
%s*synth2B
.	   2 Input      1 Bit        Muxes := 6     
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
L
%s*synth27
#Finished RTL Component Statistics 
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
V
%s*synth2A
-Start RTL Hierarchical Component Statistics 
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
L
%s*synth27
#Hierarchical RTL Component report 
2default:defaulth px
G
%s*synth22
Module top_6116_v1_0_to_bram 
2default:defaulth px
H
%s*synth23
Detailed RTL Component Info : 
2default:defaulth px
:
%s*synth2%
+---Registers : 
2default:defaulth px
W
%s*synth2B
.	               32 Bit    Registers := 5     
2default:defaulth px
W
%s*synth2B
.	                4 Bit    Registers := 2     
2default:defaulth px
W
%s*synth2B
.	                2 Bit    Registers := 2     
2default:defaulth px
W
%s*synth2B
.	                1 Bit    Registers := 5     
2default:defaulth px
6
%s*synth2!
+---Muxes : 
2default:defaulth px
W
%s*synth2B
.	   2 Input     32 Bit        Muxes := 4     
2default:defaulth px
W
%s*synth2B
.	   4 Input     32 Bit        Muxes := 5     
2default:defaulth px
W
%s*synth2B
.	   2 Input      1 Bit        Muxes := 6     
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
X
%s*synth2C
/Finished RTL Hierarchical Component Statistics
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
E
%s*synth20
Start Part Resource Summary
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2k
WPart Resources:
DSPs: 220 (col length:60)
BRAMs: 280 (col length: RAMB18 60 RAMB36 30)
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
H
%s*synth23
Finished Part Resource Summary
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Start Parallel Synthesis Optimization  : Time (s): cpu = 00:00:08 ; elapsed = 00:00:09 . Memory (MB): peak = 1223.789 ; gain = 314.484 ; free physical = 8814 ; free virtual = 21194
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
K
%s*synth26
"Start Cross Boundary Optimization
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
!design %s has unconnected port %s3331*oasys2)
top_6116_v1_0_to_bram2default:default2#
S_AXI_AWPROT[2]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2)
top_6116_v1_0_to_bram2default:default2#
S_AXI_AWPROT[1]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2)
top_6116_v1_0_to_bram2default:default2#
S_AXI_AWPROT[0]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2)
top_6116_v1_0_to_bram2default:default2#
S_AXI_ARPROT[2]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2)
top_6116_v1_0_to_bram2default:default2#
S_AXI_ARPROT[1]2default:defaultZ8-3331h px
�
!design %s has unconnected port %s3331*oasys2)
top_6116_v1_0_to_bram2default:default2#
S_AXI_ARPROT[0]2default:defaultZ8-3331h px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Cross Boundary Optimization : Time (s): cpu = 00:00:08 ; elapsed = 00:00:09 . Memory (MB): peak = 1224.797 ; gain = 315.492 ; free physical = 8810 ; free virtual = 21190
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Parallel Reinference  : Time (s): cpu = 00:00:08 ; elapsed = 00:00:09 . Memory (MB): peak = 1224.797 ; gain = 315.492 ; free physical = 8810 ; free virtual = 21190
2default:defaulth px
B
%s*synth2-

Report RTL Partitions: 
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
�
6propagating constant %s across sequential element (%s)3333*oasys2
02default:default2&
\axi_rresp_reg[1] 2default:defaultZ8-3333h px
�
6propagating constant %s across sequential element (%s)3333*oasys2
02default:default2&
\axi_bresp_reg[1] 2default:defaultZ8-3333h px
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2&
\axi_bresp_reg[1] 2default:default2)
top_6116_v1_0_to_bram2default:defaultZ8-3332h px
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2&
\axi_bresp_reg[0] 2default:default2)
top_6116_v1_0_to_bram2default:defaultZ8-3332h px
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2'
\axi_araddr_reg[1] 2default:default2)
top_6116_v1_0_to_bram2default:defaultZ8-3332h px
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2'
\axi_araddr_reg[0] 2default:default2)
top_6116_v1_0_to_bram2default:defaultZ8-3332h px
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2'
\axi_awaddr_reg[1] 2default:default2)
top_6116_v1_0_to_bram2default:defaultZ8-3332h px
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2'
\axi_awaddr_reg[0] 2default:default2)
top_6116_v1_0_to_bram2default:defaultZ8-3332h px
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2&
\axi_rresp_reg[1] 2default:default2)
top_6116_v1_0_to_bram2default:defaultZ8-3332h px
�
ESequential element (%s) is unused and will be removed from module %s.3332*oasys2&
\axi_rresp_reg[0] 2default:default2)
top_6116_v1_0_to_bram2default:defaultZ8-3332h px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
A
%s*synth2,
Start Area Optimization
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Area Optimization : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1245.840 ; gain = 336.535 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Parallel Area Optimization  : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1245.840 ; gain = 336.535 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
B
%s*synth2-

Report RTL Partitions: 
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
�
%s*synth2�
�Finished Parallel Synthesis Optimization  : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1245.840 ; gain = 336.535 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
C
%s*synth2.
Start Timing Optimization
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Timing Optimization : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1245.840 ; gain = 336.535 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
B
%s*synth2-

Report RTL Partitions: 
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
B
%s*synth2-
Start Technology Mapping
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Technology Mapping : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1245.840 ; gain = 336.535 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
B
%s*synth2-

Report RTL Partitions: 
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
<
%s*synth2'
Start IO Insertion
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
E
%s*synth20
Start Final Netlist Cleanup
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
H
%s*synth23
Finished Final Netlist Cleanup
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished IO Insertion : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1245.840 ; gain = 336.535 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
A
%s*synth2,

Report Check Netlist: 
2default:defaulth px
r
%s*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth px
r
%s*synth2]
I|      |Item              |Errors |Warnings |Status |Description       |
2default:defaulth px
r
%s*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth px
r
%s*synth2]
I|1     |multi_driven_nets |      0|        0|Passed |Multi driven nets |
2default:defaulth px
r
%s*synth2]
I+------+------------------+-------+---------+-------+------------------+
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
L
%s*synth27
#Start Renaming Generated Instances
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1245.840 ; gain = 336.535 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
B
%s*synth2-

Report RTL Partitions: 
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
+| |RTL Partition |Replication |Instances |
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
T
%s*synth2?
++-+--------------+------------+----------+
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
I
%s*synth24
 Start Rebuilding User Hierarchy
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1245.840 ; gain = 336.535 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Start Renaming Generated Ports : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1245.840 ; gain = 336.535 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1245.840 ; gain = 336.535 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
H
%s*synth23
Start Writing Synthesis Report
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
>
%s*synth2)

Report BlackBoxes: 
2default:defaulth px
G
%s*synth22
+-+--------------+----------+
2default:defaulth px
G
%s*synth22
| |BlackBox name |Instances |
2default:defaulth px
G
%s*synth22
+-+--------------+----------+
2default:defaulth px
G
%s*synth22
+-+--------------+----------+
2default:defaulth px
>
%s*synth2)

Report Cell Usage: 
2default:defaulth px
?
%s*synth2*
+------+-----+------+
2default:defaulth px
?
%s*synth2*
|      |Cell |Count |
2default:defaulth px
?
%s*synth2*
+------+-----+------+
2default:defaulth px
?
%s*synth2*
|1     |BUFG |     1|
2default:defaulth px
?
%s*synth2*
|2     |LUT1 |     1|
2default:defaulth px
?
%s*synth2*
|3     |LUT3 |     2|
2default:defaulth px
?
%s*synth2*
|4     |LUT4 |    22|
2default:defaulth px
?
%s*synth2*
|5     |LUT5 |     3|
2default:defaulth px
?
%s*synth2*
|6     |LUT6 |    32|
2default:defaulth px
?
%s*synth2*
|7     |FDRE |   169|
2default:defaulth px
?
%s*synth2*
|8     |IBUF |    47|
2default:defaulth px
?
%s*synth2*
|9     |OBUF |    41|
2default:defaulth px
?
%s*synth2*
+------+-----+------+
2default:defaulth px
B
%s*synth2-

Report Instance Areas: 
2default:defaulth px
K
%s*synth26
"+------+---------+-------+------+
2default:defaulth px
K
%s*synth26
"|      |Instance |Module |Cells |
2default:defaulth px
K
%s*synth26
"+------+---------+-------+------+
2default:defaulth px
K
%s*synth26
"|1     |top      |       |   318|
2default:defaulth px
K
%s*synth26
"+------+---------+-------+------+
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1245.840 ; gain = 336.535 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
{
%s*synth2f
R---------------------------------------------------------------------------------
2default:defaulth px
p
%s*synth2[
GSynthesis finished with 0 errors, 0 critical warnings and 20 warnings.
2default:defaulth px
�
%s*synth2�
�Synthesis Optimization Runtime : Time (s): cpu = 00:00:06 ; elapsed = 00:00:07 . Memory (MB): peak = 1245.840 ; gain = 220.016 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
�
%s*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:09 ; elapsed = 00:00:10 . Memory (MB): peak = 1245.840 ; gain = 336.535 ; free physical = 8787 ; free virtual = 21170
2default:defaulth px
?
 Translating synthesized netlist
350*projectZ1-571h px
c
-Analyzing %s Unisim elements for replacement
17*netlist2
472default:defaultZ29-17h px
g
2Unisim Transformation completed in %s CPU seconds
28*netlist2
02default:defaultZ29-28h px
H
)Preparing netlist for logic optimization
349*projectZ1-570h px
r
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px
{
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px
R
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
162default:default2
202default:default2
02default:default2
02default:defaultZ4-41h px
[
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px
�
r%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s ; free physical = %s ; free virtual = %s
480*common2"
synth_design: 2default:default2
00:00:082default:default2
00:00:082default:default2
1366.8632default:default2
349.0392default:default2
87202default:default2
211042default:defaultZ17-722h px
�
�report_utilization: Time (s): cpu = 00:00:00.02 ; elapsed = 00:00:00.09 . Memory (MB): peak = 1398.883 ; gain = 0.000 ; free physical = 8718 ; free virtual = 21102
*commonh px
}
Exiting %s at %s...
206*common2
Vivado2default:default2,
Mon Sep 19 13:04:40 20162default:defaultZ17-206h px