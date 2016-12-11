README

The following are the folders that are important
6502 - contains the 6502 and its testbench
68010_vhdl - contains the video_microprocessor and the VHDL for the 68010
Graphics - contains the entire graphics subsystem and the cartridge
integration - contains the systemclock
jt51_synth - contains files needed for the YM2151
lib - contains all the small chips used in the pcb schematic
POKEY - contains the code for the pokey
roms - contains the hex dumps for all of the roms in the system
synthesis - contains the project of our demo
trackball - contains the leta chip and the trackball logic
VGA - contains vga testcode
YM2151 - contains the YM2151
zedboard_audio - contains vivado files needed for our project


How to simulate
export VCS_HOME="/usr/local/synopsys/L-Foundation/2016.06/vcs_mx_vL-2016.06/
alias vhdlannew="/usr/local/synopsys/L-Foundation/2016.06/vcs_mx_vL-2016.06/bin/vhdlan"
alias vlogannew="/usr/local/synopsys/L-Foundation/2016.06/vcs_mx_vL-2016.06/bin/vlogan"
alias vcsnew="/usr/local/synopsys/L-Foundation/2016.06/vcs_mx_vL-2016.06/bin/vcs"

Then you will go into the Graphics folder and do
vlogannew -systemverilog testbench_graphics
vhdlannew -f list.txt
vcsnew testbench

that will correctly simulate


How to pull up our demo
Open vivado
Open Project3 from synthesis
That should contain all the files needed

