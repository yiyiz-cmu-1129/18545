library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity audio_helper is
    Port ( clk_100      : in    STD_LOGIC;                      -- 100 mhz input clock from top level logic
           clk_100_buffered : out   STD_LOGIC
    );
end audio_helper;

architecture Behavioral of audio_helper is 
begin
    BUFG_inst : BUFG
    port map (
       O => clk_100_buffered,   -- 1-bit output: Clock output
       I => clk_100             -- 1-bit input: Clock input
    );  
    
end Behavioral;    
