-- (c) Copyright 1995-2016 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: user.org:user:WF68K10_TOP:1.0
-- IP Revision: 1

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT WF68K10_TOP_0
  PORT (
    CLK : IN STD_LOGIC;
    ADR_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    DATA_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    DATA_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    DATA_EN : OUT STD_LOGIC;
    BERRn : IN STD_LOGIC;
    RESET_INn : IN STD_LOGIC;
    RESET_OUT : OUT STD_LOGIC;
    HALT_INn : IN STD_LOGIC;
    HALT_OUTn : OUT STD_LOGIC;
    FC_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    AVECn : IN STD_LOGIC;
    IPLn : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    DTACKn : IN STD_LOGIC;
    ASn : OUT STD_LOGIC;
    RWn : OUT STD_LOGIC;
    RMCn : OUT STD_LOGIC;
    UDSn : OUT STD_LOGIC;
    LDSn : OUT STD_LOGIC;
    DBENn : OUT STD_LOGIC;
    BUS_EN : OUT STD_LOGIC;
    E : OUT STD_LOGIC;
    VMAn : OUT STD_LOGIC;
    VMA_EN : OUT STD_LOGIC;
    VPAn : IN STD_LOGIC;
    BRn : IN STD_LOGIC;
    BGn : OUT STD_LOGIC;
    BGACKn : IN STD_LOGIC;
    K6800n : IN STD_LOGIC
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : WF68K10_TOP_0
  PORT MAP (
    CLK => CLK,
    ADR_OUT => ADR_OUT,
    DATA_IN => DATA_IN,
    DATA_OUT => DATA_OUT,
    DATA_EN => DATA_EN,
    BERRn => BERRn,
    RESET_INn => RESET_INn,
    RESET_OUT => RESET_OUT,
    HALT_INn => HALT_INn,
    HALT_OUTn => HALT_OUTn,
    FC_OUT => FC_OUT,
    AVECn => AVECn,
    IPLn => IPLn,
    DTACKn => DTACKn,
    ASn => ASn,
    RWn => RWn,
    RMCn => RMCn,
    UDSn => UDSn,
    LDSn => LDSn,
    DBENn => DBENn,
    BUS_EN => BUS_EN,
    E => E,
    VMAn => VMAn,
    VMA_EN => VMA_EN,
    VPAn => VPAn,
    BRn => BRn,
    BGn => BGn,
    BGACKn => BGACKn,
    K6800n => K6800n
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

