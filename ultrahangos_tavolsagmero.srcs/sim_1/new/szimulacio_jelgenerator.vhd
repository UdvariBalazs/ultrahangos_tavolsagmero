----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2018 04:05:40 PM
-- Design Name: 
-- Module Name: szimulacio_jelgenerator - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity szimulacio_jelgenerator is
--  Port ( );
end szimulacio_jelgenerator;

architecture Behavioral of szimulacio_jelgenerator is

    component jelgenerator
        Port (  clk : in std_logic;
                start : in std_logic;
                reset : in std_logic;
                dx : in std_logic_vector(6 downto 0);
                N_in : in std_logic_vector(15 downto 0);
                NK_in : in std_logic_vector(15 downto 0);
                A_out : out std_logic;
                RD_out : out std_logic );
    end component;

    --az elegységek összekapcsolásához szükséges jelek (vezetékek)
    
    -- Bemenetek
    signal clk : std_logic;
    signal start : std_logic;
    signal reset : std_logic;
    signal dx : std_logic_vector(5 downto 0);
    signal N_in : std_logic_vector(15 downto 0);
    signal NK_in : std_logic_vector(15 downto 0);
    
    -- Kimenetek
    signal A_out : std_logic;
    signal RD_out : std_logic;
              
    -- Orajel periodusanak meghatarozasa      
    constant clk_period : time := 10 ns;
    
begin

    -- UUT inicializalasa
    uut : projekt port map (
        clk => clk,
        start => start, 
        reset => reset,
        dx => dx,
        N_in => N_in,
        NK_in => NK_in,
        A_out => A_out, 
        RD_out => RD_out );
        
    -- Orajel processzus meghatarozasa
    clk_process :process 
    begin  
        clk <= '0'; 
        wait for clk_period/2; 
        clk <= '1';  
        wait for clk_period/2;    
    end process; 

    -- Stimulus processzus
    stim_proc: process
    begin
    	-- reset allapot 100 ns-ig   
        reset<='1'; 
        start<='0';
        wait for 100 ns;  
        
        start <= '1'; 
        reset <= '0';
        dx <= "000010";
        N_in <= "0000010010100110"; --   1190
        NK_in <= "0000011111010000"; -- 20000
        wait for clk_period;
        
    wait;
    end process;
    
end Behavioral;
