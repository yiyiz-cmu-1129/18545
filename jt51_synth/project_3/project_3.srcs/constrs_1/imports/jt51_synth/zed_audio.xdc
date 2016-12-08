# timing constraints
create_clock -period 10.000 -name clk_100 [get_ports clk_100]

set_false_path -from [get_clocks zed_audio_clk_48M] -to [get_clocks clk_100]
set_false_path -from [get_clocks clk_100] -to [get_clocks zed_audio_clk_48M]


# 100 mhz clock
set_property PACKAGE_PIN Y9 [get_ports clk_100]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100]

# 24 mhz clock to audio chip
set_property PACKAGE_PIN AB2 [get_ports AC_MCLK]
set_property IOSTANDARD LVCMOS33 [get_ports AC_MCLK]


#buttons
set_property PACKAGE_PIN P16 [get_ports {BTNC}];  # "BTNC"


# I2S transfers audio samples
# i2s bit clock to ADAU1761
set_property PACKAGE_PIN Y8 [get_ports AC_GPIO0]


# i2s bit clock from ADAU1761
set_property PACKAGE_PIN AA7 [get_ports AC_GPIO1]


# i2s bit clock from ADAU1761
set_property PACKAGE_PIN AA6 [get_ports AC_GPIO2]


# i2s l/r 48 khz toggling signal from ADAU1761 (sample clock)
set_property PACKAGE_PIN Y6 [get_ports AC_GPIO3]


set_property PACKAGE_PIN F22 [get_ports {SW0}];  # "SW0"
set_property PACKAGE_PIN G22 [get_ports {SW1}];  # "SW1"

set_property PACKAGE_PIN H22 [get_ports {SW2}];  # "SW2"
set_property PACKAGE_PIN F21 [get_ports {SW3}];  # "SW3"


# I2C Data Interface to ADAU1761 (for configuration)
set_property PACKAGE_PIN AB4 [get_ports AC_SCK]


set_property PACKAGE_PIN AB5 [get_ports AC_SDA]


set_property PACKAGE_PIN AB1 [get_ports AC_ADR0]


set_property PACKAGE_PIN Y5 [get_ports AC_ADR1]

# ----------------------------------------------------------------------------
# JA Pmod - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y11  [get_ports {JA1}];  # "JA1"
set_property PACKAGE_PIN AA8  [get_ports {JA10}];  # "JA10"
set_property PACKAGE_PIN AA11 [get_ports {JA2}];  # "JA2"
set_property PACKAGE_PIN Y10  [get_ports {JA3}];  # "JA3"
set_property PACKAGE_PIN AA9  [get_ports {JA4}];  # "JA4"
set_property PACKAGE_PIN AB11 [get_ports {JA7}];  # "JA7"
set_property PACKAGE_PIN AB10 [get_ports {JA8}];  # "JA8"
set_property PACKAGE_PIN AB9  [get_ports {JA9}];  # "JA9"

# ----------------------------------------------------------------------------
# JB Pmod - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN W12 [get_ports {JB1}];  # "JB1"
set_property PACKAGE_PIN V8 [get_ports {JB10}];  # "JB10"
set_property PACKAGE_PIN W11 [get_ports {JB2}];  # "JB2"
set_property PACKAGE_PIN V10 [get_ports {JB3}];  # "JB3"
set_property PACKAGE_PIN W8 [get_ports {JB4}];  # "JB4"
set_property PACKAGE_PIN V12 [get_ports {JB7}];  # "JB7"
set_property PACKAGE_PIN W10 [get_ports {JB8}];  # "JB8"
set_property PACKAGE_PIN V9 [get_ports {JB9}];  # "JB9"

# ----------------------------------------------------------------------------
# JC Pmod - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN AB6 [get_ports {JC1_N}];  # "JC1_N"
set_property PACKAGE_PIN AB7 [get_ports {JC1_P}];  # "JC1_P"
set_property PACKAGE_PIN AA4 [get_ports {JC2_N}];  # "JC2_N"
set_property PACKAGE_PIN Y4  [get_ports {JC2_P}];  # "JC2_P"
set_property PACKAGE_PIN T6  [get_ports {JC3_N}];  # "JC3_N"
set_property PACKAGE_PIN R6  [get_ports {JC3_P}];  # "JC3_P"
set_property PACKAGE_PIN U4  [get_ports {JC4_N}];  # "JC4_N"
set_property PACKAGE_PIN T4  [get_ports {JC4_P}];  # "JC4_P"

# ----------------------------------------------------------------------------
# JA Pmod - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN W7 [get_ports {JD1_N}];  # "JD1_N"
set_property PACKAGE_PIN V7 [get_ports {JD1_P}];  # "JD1_P"
set_property PACKAGE_PIN V4 [get_ports {JD2_N}];  # "JD2_N"
set_property PACKAGE_PIN V5 [get_ports {JD2_P}];  # "JD2_P"
set_property PACKAGE_PIN W5 [get_ports {JD3_N}];  # "JD3_N"
set_property PACKAGE_PIN W6 [get_ports {JD3_P}];  # "JD3_P"
set_property PACKAGE_PIN U5 [get_ports {JD4_N}];  # "JD4_N"
set_property PACKAGE_PIN U6 [get_ports {JD4_P}];  # "JD4_P"


# ----------------------------------------------------------------------------
# User LEDs - Bank 33
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN T22 [get_ports {LD0}];  # "LD0"
set_property PACKAGE_PIN T21 [get_ports {LD1}];  # "LD1"
set_property PACKAGE_PIN U22 [get_ports {LD2}];  # "LD2"
set_property PACKAGE_PIN U21 [get_ports {LD3}];  # "LD3"
set_property PACKAGE_PIN V22 [get_ports {LD4}];  # "LD4"
set_property PACKAGE_PIN W22 [get_ports {LD5}];  # "LD5"
set_property PACKAGE_PIN U19 [get_ports {LD6}];  # "LD6"
set_property PACKAGE_PIN U14 [get_ports {LD7}];  # "LD7"

# ----------------------------------------------------------------------------
# VGA Output - Bank 33
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y21  [get_ports {VGA_B1}];  # "VGA-B1"
set_property PACKAGE_PIN Y20  [get_ports {VGA_B2}];  # "VGA-B2"
set_property PACKAGE_PIN AB20 [get_ports {VGA_B3}];  # "VGA-B3"
set_property PACKAGE_PIN AB19 [get_ports {VGA_B4}];  # "VGA-B4"
set_property PACKAGE_PIN AB22 [get_ports {VGA_G1}];  # "VGA-G1"
set_property PACKAGE_PIN AA22 [get_ports {VGA_G2}];  # "VGA-G2"
set_property PACKAGE_PIN AB21 [get_ports {VGA_G3}];  # "VGA-G3"
set_property PACKAGE_PIN AA21 [get_ports {VGA_G4}];  # "VGA-G4"
set_property PACKAGE_PIN AA19 [get_ports {VGA_HS}];  # "VGA-HS"
set_property PACKAGE_PIN V20  [get_ports {VGA_R1}];  # "VGA-R1"
set_property PACKAGE_PIN U20  [get_ports {VGA_R2}];  # "VGA-R2"
set_property PACKAGE_PIN V19  [get_ports {VGA_R3}];  # "VGA-R3"
set_property PACKAGE_PIN V18  [get_ports {VGA_R4}];  # "VGA-R4"
set_property PACKAGE_PIN Y19  [get_ports {VGA_VS}];  # "VGA-VS"

set_property IOSTANDARD LVCMOS33 [get_ports AC_GPIO0]
set_property IOSTANDARD LVCMOS33 [get_ports AC_GPIO1]
set_property IOSTANDARD LVCMOS33 [get_ports AC_GPIO2]
set_property IOSTANDARD LVCMOS33 [get_ports AC_GPIO3]
set_property IOSTANDARD LVCMOS33 [get_ports AC_SCK]
set_property IOSTANDARD LVCMOS33 [get_ports AC_SDA]
set_property IOSTANDARD LVCMOS33 [get_ports AC_ADR0]
set_property IOSTANDARD LVCMOS33 [get_ports AC_ADR1]


#stuff for things
# Note that the bank voltage for IO Bank 33 is fixed to 3.3V on ZedBoard. 
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 33]];

# Set the bank voltage for IO Bank 34 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 34]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];

# Set the bank voltage for IO Bank 35 to 1.8V by default.
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];
# set_property IOSTANDARD LVCMOS25 [get_ports -of_objects [get_iobanks 35]];
set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];

# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard. 
set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];



