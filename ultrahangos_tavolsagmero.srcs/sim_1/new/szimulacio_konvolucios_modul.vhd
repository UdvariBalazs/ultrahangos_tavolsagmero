----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/19/2018 12:44:26 PM
-- Design Name: 
-- Module Name: szimulacio_konvolucios_modul - Behavioral
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

entity szimulacio_konvolucios_modul is
--  Port ( );
end szimulacio_konvolucios_modul;

architecture Behavioral of szimulacio_konvolucios_modul is
component konvolucios_modul

    Port ( clk : in STD_LOGIC;
        SIN : in STD_LOGIC;
        CESIN : in STD_LOGIC;
        Reset0 : in STD_LOGIC;
        ESIN : in STD_LOGIC;
        CEESIN : in STD_LOGIC;
        Reset1 : in STD_LOGIC;
        CESET : in STD_LOGIC;
        CESUM : in STD_LOGIC;
        
        SOUT : out STD_LOGIC;
        ESOUT : out STD_LOGIC;
        SUMOUT : out STD_LOGIC_VECTOR (6 downto 0) );

        -- Inputs
        signal clk : STD_LOGIC;
        signal SIN : STD_LOGIC;
        signal CESIN : STD_LOGIC;
        signal Reset0 : STD_LOGIC;
        signal ESIN : STD_LOGIC;
        signal CEESIN : STD_LOGIC;
        signal Reset1 : STD_LOGIC;
        signal CESET : STD_LOGIC;
        signal CESUM : STD_LOGIC:
        
        -- Outputs
        signal SOUT : STD_LOGIC;
        signal ESOUT : STD_LOGIC;
        signal SUMOUT : STD_LOGIC_VECTOR (6 downto 0);
        
        -- Orajel periodusanak meghatarozasa      
        constant clk_period : time := 10 ns;
        
begin
    -- UUT inicializalasa
    uut : konvolucios_modul port map (
    );

end Behavioral;
