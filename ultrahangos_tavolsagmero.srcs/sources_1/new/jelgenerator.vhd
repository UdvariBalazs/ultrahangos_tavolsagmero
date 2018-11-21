----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2018 07:21:43 AM
-- Design Name: 
-- Module Name: jelgenerator - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity jelgenerator is
    Port (  clk : in std_logic;
            start : in std_logic;
            reset : in std_logic );
end jelgenerator;

architecture Behavioral of jelgenerator is

type allapot_tipus is (RDY, INIT_A, CIKLUS_A, INIT_B, INIT_C, CIKLUS_B, INIT_D, SET);

signal akt_all, kov_all : allapot_tipus;

signal N : std_logic_vector(15 downto 0);
signal NK : std_logic_vector(15 downto 0);
signal i : std_logic_vector(15 downto 0);
signal A : std_logic;
signal RD : std_logic;

begin

    -- állapotregiszter megvalósítása
    AR : process(clk)
    begin
        if reset = '1' then
            akt_all <= RDY;
        elsif clk'event and clk = '1' then
            akt_all <= kov_all;
        end if;
    end process AR;
    
    -- következ? állapotlogika megvalósítása
    KAL : process(akt_all, start, i)          
    begin
        case akt_all is
            when RDY =>
                if start = '1' then
                    kov_all <= INIT_A;
                else
                    kov_all <= RDY;
                end if;
            when INIT_A =>
                kov_all <= CIKLUS_A;
            when CIKLUS_A =>
                if i > 0 then
                    kov_all <= CIKLUS_A;
                else
                    kov_all <= INIT_B;
                end if;
            when INIT_B =>
                kov_all <= INIT_C;
            when INIT_C =>
                
            when CIKLUS_B =>
            when INIT_D =>
            when SET =>
            end case;
    end process KAL; 

end Behavioral;
