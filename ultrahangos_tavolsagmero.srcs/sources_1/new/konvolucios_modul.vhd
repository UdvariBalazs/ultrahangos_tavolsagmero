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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
    
    signal s0 : std_logic_vector(RSZ-1 downto 0); -- elso sor D taroloinak kimenete
    signal s1 : std_logic_vector(RSZ-1 downto 0); -- masodik sor D taroloinak kimenete
    
    signal not_xor_gate_out : std_logic_vector(RSZ-1 downto 0); -- tagadott kizaro vagy kapuk kimenetei
    
    signal mux_out : std_logic_vector(RSZ-1 downto 0); -- multiplexerek kimenetei
    signal mux_s : std_logic_vector(RSZ-1 downto 0); -- multiplexerek szelekcios bitjei
    
    signal s2 : std_logic_vector(RSZ-1 downto 0); -- harmadik sor D taroloinak kimenetei
    signal s2_seged : std_logic_vector(5 downto 0);
    signal or_gate : std_logic; -- a vagy kaupu bemenetei CESET es CESUM
    
    signal sumout_signal : std_logic_vector(6 downto 0);

begin
    ciklus0 : for i in 0 to RSZ-1 generate -- elso sor D taroloinak kigeneralasa
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
                    if Reset0='1' then
                        s0(i) <= '0';
                    elsif CESIN='1' then
                        s0(i) <= s0(i-1);
                    end if;
                end if;
            end process;
        end generate;
    end generate;
    ------------------ ciklus0 vege
    SOUT <= s0(RSZ-1);
    
    ciklus1 : for i in 0 to RSZ-1 generate -- masodik sor D taroloinak kigeneralasa
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
    ------------------ ciklus1 vege
    ESOUT <= s1(RSZ-1);    
    
    ciklus2 : for i in 0 to RSZ-1 generate -- tagadott kizaro vagy kapuk kigeneralasa
       if_i : if i >= 0 generate
            not_xor_gate_out(i) <= not (s0(i) xor s1(i));
       end generate;
    end generate;
    ---------------- ciklus2 vege 
      
      
    ciklus3 : for i in 0 to RSZ-1 generate -- harmadik sor multiplexereinek kigeneralasa
        if_1 : if i = 0 generate
            mux_1 : process(not_xor_gate_out(i), CESET)
            begin
               case (not CESET) is
                   when '0' => mux_out(i) <= not_xor_gate_out(i);
                   when '1' => mux_out(i) <= '0';
               end case;
            end process;
        end generate;
        
        if_i : if i > 0 generate
            reg_i : process(clk, CESET, CESUM)
            begin
                if clk'event and clk='1' then
                    if or_gate='1' then
                        s2(i) <= mux_out(i);
                    end if;
                end if;
            end process;
        end generate;
    end generate;
    ---------------- ciklus3 vege
    
    or_gate <= CESET or CESUM;
    ciklus4 : for i in 0 to RSZ-1 generate -- harmadik D taroloinak kigeneralasa
        if_1 : if i = 0 generate
            reg_1 : process(clk, CESET, CESUM)
            begin
                if clk'event and clk='1' then
                    if or_gate='1' then
                        s2(i) <= mux_out(i);
                    end if;
                end if;
            end process;
        end generate;
    
        if_i : if i > 0 generate
            mux_i : process(not_xor_gate_out(i), mux_out(i-1), CESET)
            begin
                case (not CESET) is
                    when '0' => mux_out(i) <= not_xor_gate_out(i); 
                    when '1' => mux_out(i) <= s2(i-1);
                end case;
            end process;
        end generate;
    end generate;
    ---------------- ciklus4 vege
    
    sum : process(clk, CESET, CESUM)
    begin
        if clk'event and clk='1' then
            if CESET='1' then
                sumout_signal <= "0000000";
            elsif CESUM='1' then
                sumout_signal <= sumout_signal + s2(RSZ-1);
            end if;
        end if;
    end process;
    
    SUMOUT <= sumout_signal;
     
end Behavioral;
