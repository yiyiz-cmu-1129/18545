# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z020clg484-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.cache/wt [current_project]
set_property parent.project_path /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
read_verilog {
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/sin_lut.vh
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/phinc_lut.vh
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/exp_lut.vh
}
read_verilog -library xil_defaultlib -sv {
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_top.sv
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/trackball_top.sv
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/chip_interface.sv
}
read_verilog -library xil_defaultlib {
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_sum_op.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_sintable.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_sh2.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_sh.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_reg.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_pm.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_phinc_rom.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_noise_lfsr.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_lin2exp.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_lfo_lfsr.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_exptable.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_exp2lin.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_timers.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_phasegen.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_op.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_noise.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_mmr.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_lfo.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_envelope.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51_acc.v
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/jt51.v
}
read_vhdl -library xil_defaultlib {
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/hdl/adau1761_configuraiton_data.vhd
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/hdl/i3c2.vhd
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/hdl/i2s_data_interface.vhd
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/hdl/i2c.vhd
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/hdl/ADAU1761_interface.vhd
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/leta.vhdl
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/hdl/clocking.vhd
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/hdl/adau1761_izedboard.vhd
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/hdl/audio_top.vhd
  /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/sources_1/imports/jt51_synth/audio_helper.vhd
}
read_xdc /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/constrs_1/imports/jt51_synth/zed_audio.xdc
set_property used_in_implementation false [get_files /afs/ece.cmu.edu/usr/yiyiz/Private/MM545/YM2151/trunk/jt51_synth/project_3/project_3.srcs/constrs_1/imports/jt51_synth/zed_audio.xdc]

synth_design -top chip_interface -part xc7z020clg484-1
write_checkpoint -noxdef chip_interface.dcp
catch { report_utilization -file chip_interface_utilization_synth.rpt -pb chip_interface_utilization_synth.pb }