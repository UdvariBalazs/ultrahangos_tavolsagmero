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
            reset : in std_logic;
            dx : in std_logic_vector(6 downto 0);
            N_in : in std_logic_vector(15 downto 0); -- megadja hany hullamot (impulzust kuldok ki)
            NK_in : in std_logic_vector(15 downto 0); -- megadja egy impulzus periodusat alap orajelben (T = NK_in * 10 ns; ha clk = 100MHz)
            A_out : out std_logic;
            RD_out : out std_logic );
            
end jelgenerator;

architecture Behavioral of jelgenerator is

type allapot_tipus is (RDY, INIT_A, CIKLUS_A, INIT_B, INIT_C, CIKLUS_B, INIT_D, SET);

signal akt_all, kov_all : allapot_tipus;

signal N, N_NEXT : std_logic_vector(15 downto 0);
signal NK, NK_NEXT : std_logic_vector(15 downto 0);
signal i, i_NEXT : std_logic_vector(15 downto 0);
signal A, A_NEXT : std_logic;
signal RD, RD_NEXT : std_logic;

begin

    -- állapotregiszter megvalósítása
    AR : process(clk, reset)
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
                kov_all <= CIKLUS_B;
            when CIKLUS_B =>
                if i > 0 then
                    kov_all <= CIKLUS_B;
                else
                    kov_all <= INIT_D;
                end if;
            when INIT_D =>
                kov_all <= SET;
            when SET =>
                kov_all <= RDY;
        end case;
    end process KAL; 
    
    --kapcsolóhálozatok megvalósítása with select when utasítással és az elvégzend? m?veletek megvalósítása.
    with akt_all select
        N_NEXT <= N_in when RDY,
            N_in when INIT_A,
            N when CIKLUS_A,
            N-1 when INIT_B,
            N_in when INIT_C,
            N when CIKLUS_B,
            N-1 when INIT_D,
            (others=>'0') when SET;
            
    with akt_all select
        NK_NEXT <= NK_in when RDY,
            NK_in when INIT_A,
            NK when CIKLUS_A,
            NK-dx when INIT_B,
            NK when INIT_C,
            NK when CIKLUS_B,
            NK+dx when INIT_D,
            (others=>'0') when SET;
            
    with akt_all select
        i_NEXT <= i when RDY, 
            NK when INIT_A,
            i-1 when CIKLUS_A,
            NK when INIT_B,
            i when INIT_C,
            i-1 when CIKLUS_B,
            NK when INIT_D,
            i when SET;
            
    with akt_all select
        A_NEXT <= '0' when RDY, 
            '1' when INIT_A,
            A when CIKLUS_A,
            not A when INIT_B,
            A when INIT_C, -- A vagy not A
            A when CIKLUS_B, -- biztos A
            not A when INIT_D, -- biztos not A
            '0' when SET;  

    with akt_all select
        RD_NEXT <= '0' when RDY, 
            '0' when INIT_A,
            '0' when CIKLUS_A,
            '0' when INIT_B,
            '0' when INIT_C,
            '0' when CIKLUS_B,
            '0' when INIT_D,
            '1' when SET;
    
    --adatregiszterek megvalósítása
    ADAT_R : process(clk, reset)
    begin
        if clk'event and clk='1' then
            N <= N_NEXT;
            NK <= NK_NEXT;
            i <= i_NEXT;
            A <= A_NEXT;
            RD <= RD_NEXT;
        end if;
    end process ADAT_R;
    
    A_out <= A;
    RD_out <= RD;

end Behavioral;
