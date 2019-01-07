----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/19/2018 12:09:14 PM
-- Design Name: 
-- Module Name: teljes_konvolucios_modul - Behavioral
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

entity teljes_konvolucios_modul is
    generic (MSZ : natural :=32); -- modulok szama
    
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

end teljes_konvolucios_modul;

architecture Behavioral of teljes_konvolucios_modul is

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
    end component;
    
    signal sout_signal : std_logic_vector(MSZ-1 downto 0);
    signal esout_signal : std_logic_vector(MSZ-1 downto 0);
    signal sumout_signal : std_logic_vector(((MSZ-1)*7 + 6) downto 0);
    
    signal mux_out : std_logic_vector(((MSZ-1)*7 + 6) downto 0);
    signal d_tarolo_out : std_logic_vector(((MSZ-1)*7 + 6) downto 0);
    signal ACC : std_logic_vector(6 downto 0) := "0000000";

begin
    teljes_konvolucios_ciklus : for i in 0 to MSZ-1 generate
    
        elso_modul : if i = 0 generate ---------------------------
            modul_1 : konvolucios_modul port map(clk => clk, 
                                                 SIN => SIN, 
                                                 CESIN => CESIN,
                                                 Reset0 => Reset0, 
                                                 ESIN => ESIN,
                                                 CEESIN => CEESIN, 
                                                 Reset1 => Reset1, 
                                                 CESET => CESET, 
                                                 CESUM => CESUM, 
                                                 SOUT => sout_signal(i), 
                                                 ESOUT => esout_signal(i), 
                                                 SUMOUT => sumout_signal(6 downto 0) );
                    
            mux_1 : process(CESET, sumout_signal(6 downto 0))
            begin
                --mux_out(6 downto 0) <= sumout_signal(6 downto 0); 
                --SUMOUT <= mux_out(6 downto 0); 
                case CESET is
                    when '0' => mux_out(6 downto 0) <= "0000000";
                    when '1' => mux_out(6 downto 0) <= sumout_signal(6 downto 0); 
                end case;
            end process;
            
            d_tarolo_1 : process(clk, CESET, CESUM, mux_out(6 downto 0))
            begin
                if clk'event and clk='1' then
                    if CESET='1' or CESUM='1' then
                        d_tarolo_out(6 downto 0) <= mux_out(6 downto 0);
                    end if;
                end if;
            end process;
        end generate elso_modul; ---------------------------
        
        i_edik_modul : if i > 0 and i < MSZ-1 generate ---------------------------
            modul_i : konvolucios_modul port map(clk => clk, 
                                                 SIN => sout_signal(i-1), 
                                                 CESIN => CESIN,
                                                 Reset0 => Reset0, 
                                                 ESIN => esout_signal(i-1),
                                                 CEESIN => CEESIN, 
                                                 Reset1 => Reset1, 
                                                 CESET => CESET, 
                                                 CESUM => CESUM, 
                                                 SOUT => sout_signal(i), 
                                                 ESOUT => esout_signal(i), 
                                                 SUMOUT => sumout_signal(6+i*7 downto i*7) );
                  
            mux_i : process(CESET, d_tarolo_out(6+(i-1)*7 downto (i-1)*7), sumout_signal(6+i*7 downto i*7))
            begin
                case CESET is
                    when '0' => mux_out(6+i*7 downto i*7) <= d_tarolo_out(6+(i-1)*7 downto (i-1)*7);
                    when '1' => mux_out(6+i*7 downto i*7) <= sumout_signal(6+i*7 downto i*7);
                end case;
            end process;
            
            d_tarolo_i : process(clk, CESET, CESUM, mux_out(6+i*7 downto i*7))
            begin
                if clk'event and clk='1' then
                    if CESET='1' or CESUM='1' then
                        d_tarolo_out(6+i*7 downto i*7) <= mux_out(6+i*7 downto i*7);
                    end if;
                end if;
            end process;                   
            
        end generate i_edik_modul; ---------------------------
        
        harminckettedik_modul : if i = MSZ-1 generate ---------------------------
            modul_32 : konvolucios_modul port map(clk => clk, 
                                                 SIN => sout_signal(i-1), 
                                                 CESIN => CESIN,
                                                 Reset0 => Reset0, 
                                                 ESIN => esout_signal(i-1),
                                                 CEESIN => CEESIN, 
                                                 Reset1 => Reset1, 
                                                 CESET => CESET, 
                                                 CESUM => CESUM, 
                                                 SOUT => sout_signal(i), 
                                                 ESOUT => esout_signal(i), 
                                                 SUMOUT => sumout_signal(6+i*7 downto i*7) );
                    
            mux_32 : process(CESET, d_tarolo_out(6+(i-1)*7 downto (i-1)*7), sumout_signal(6+i*7 downto i*7))
            begin
                case CESET is
                    when '0' => mux_out(6+i*7 downto i*7) <= d_tarolo_out(6+(i-1)*7 downto (i-1)*7);
                    when '1' => mux_out(6+i*7 downto i*7) <= sumout_signal(6+i*7 downto i*7);
                end case;
            end process;
            
            d_tarolo_32 : process(clk, CESET, CESUM, mux_out(6+i*7 downto i*7))
            begin
                if clk'event and clk='1' then
                    if CESET='1' or CESUM='1' then
                        d_tarolo_out(6+i*7 downto i*7) <= mux_out(6+i*7 downto i*7);
                    end if;
                end if;
            end process;
            
            ACC <= ACC + d_tarolo_out(6+i*7 downto i*7);
            
        end generate harminckettedik_modul; ---------------------------

    SOUT <= sout_signal(MSZ-1);
    ESOUT <= esout_signal(MSZ-1);
    SUMOUT <= ACC;

    end generate teljes_konvolucios_ciklus;

end Behavioral;