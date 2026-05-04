----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2026 10:50:12 PM
-- Design Name: 
-- Module Name: sevenseg_decoder_tb - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevenseg_decoder_tb is
end sevenseg_decoder_tb;

architecture test_bench of sevenseg_decoder_tb is
    component sevenseg_decoder is
        Port(
            i_Hex : in STD_LOGIC_VECTOR (3 downto 0);
            o_seg_n : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component sevenseg_decoder;
    
    signal w_hex : STD_LOGIC_VECTOR (3 downto 0):= x"0";
    signal w_seg : STD_LOGIC_VECTOR (6 downto 0):= "0000000";
begin

       sevenseg_decoder_uut : sevenseg_decoder
       port map(
            i_Hex => w_hex,
            o_seg_n => w_seg
       ); 

       test_process : process
        begin
        w_hex <= x"0"; wait for 10 ns;
            assert (w_seg = "1000000") report "zero not displayed" severity failure;
        w_hex <= x"1"; wait for 10 ns;
            assert (w_seg = "1111001") report "one not displayed" severity failure;
        w_hex <= x"2"; wait for 10 ns;
            assert (w_seg = "0100100") report "two not displayed" severity failure;
        w_hex <= x"3"; wait for 10 ns;
            assert (w_seg = "0110000") report "three not displayed" severity failure;
        w_hex <= x"4"; wait for 10 ns;
            assert (w_seg = "0011001") report "4 not displayed" severity failure;
        w_hex <= x"5"; wait for 10 ns;
            assert (w_seg = "0010010") report "5 not displayed" severity failure;
        w_hex <= x"6"; wait for 10 ns;
            assert (w_seg = "0000010") report "6 not displayed" severity failure;
        w_hex <= x"7"; wait for 10 ns;
            assert (w_seg = "1111000") report "7 not displayed" severity failure;
        w_hex <= x"8"; wait for 10 ns;
            assert (w_seg = "0000000") report "8 not displayed" severity failure;
        w_hex <= x"9"; wait for 10 ns;
            assert (w_seg = "0011000") report "9 not displayed" severity failure;
        w_hex <= x"A"; wait for 10 ns;
            assert (w_seg = "0001000") report "A not displayed" severity failure;
        w_hex <= x"B"; wait for 10 ns;
            assert (w_seg = "0000011") report "B not displayed" severity failure;
        w_hex <= x"C"; wait for 10 ns;
            assert (w_seg = "0100111") report "C not displayed" severity failure;
        w_hex <= x"D"; wait for 10 ns;
            assert (w_seg = "0100001") report "D not displayed" severity failure;
        w_hex <= x"E"; wait for 10 ns;
            assert (w_seg = "0000110") report "E not displayed" severity failure;
        w_hex <= x"F"; wait for 10 ns;
            assert (w_seg = "0001110") report "F not displayed" severity failure;
           wait;
    end process;
end test_bench;
