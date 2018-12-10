----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2018 01:31:24 PM
-- Design Name: 
-- Module Name: konvolucios_modul - Behavioral
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

entity konvolucios_modul is
    generic (RSZ : natural :=32); -- regiszterek szama

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
end konvolucios_modul;

architecture Behavioral of konvolucios_modul is

signal s0 : std_logic_vector(RSZ-1 downto 0);
signal s1 : std_logic_vector(RSZ-1 downto 0);
signal s2 : std_logic_vector(RSZ-1 downto 0);
signal xor_gate : std_logic_vector(RSZ-1 downto 0) ;

begin
    ciklus0 : for i in 0 to RSZ-1 generate
         if_1 : if i=0 generate
            reg_0 : process(clk, Reset0)
            begin
                if clk'event and clk='1' then
                    if Reset0='1' then
                        s0(i) <= '0';
                    elsif CESIN='1' then
                        s0(i) <= SIN;
                        
                    end if;
                end if;
            end process;
         end generate; 
    
        if_i : if i>0 generate
            reg_i : process(clk, Reset0)
            begin
                if clk'event and clk='1' then
                    if Reset0='0' then
                        s0(i) <= '0';
                    elsif CESIN='1' then
                        s0(i) <= s0(i-1);
                    end if;
                end if;
            end process;
        end generate;
    end generate;
    SOUT <= s0(RSZ-1);
    ------------------ ciklus0 vege
    
    ciklus1 : for i in 0 to RSZ-1 generate
         if_1 : if i=0 generate
            reg_0 : process(clk, Reset1)
            begin
                if clk'event and clk='1' then
                    if Reset1='1' then
                        s1(i) <= '0';
                    elsif CEESIN='1' then
                        s1(i) <= ESIN;
                    end if;
                end if;
            end process;
        end generate;          
    
        if_i : if i>0 generate
            reg_i : process(clk, Reset1)
            begin
                if clk'event and clk='1' then
                    if Reset1='1' then
                        s1(i) <= '0';
                    elsif CEESIN='1' then
                        s1(i) <= s1(i-1);
                    end if;
                end if;
            end process;
        end generate;
    end generate;   
    ESOUT <= s1(RSZ-1);    
    ------------------ ciklus1 vege
    
    -- a vagy kapukat is egy for generate-be beletenni 
end Behavioral;
