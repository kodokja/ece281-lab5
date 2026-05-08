----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0) := "000";
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is
    component ripple_adder is
    port(
        A   : in std_logic_vector(7 downto 0);
        B   : in std_logic_vector(7 downto 0);
        Cin : in std_logic;
        S   : out std_logic_vector(7 downto 0);
        Cout: out std_logic
        );
    end component ripple_adder;
    
    signal w_op : STD_LOGIC := '0';
    signal w_B : STD_LOGIC_VECTOR(7 downto 0);
    signal w_AND : STD_LOGIC_VECTOR(7 downto 0);
    signal w_OR : STD_LOGIC_VECTOR(7 downto 0);
    signal w_Result : STD_LOGIC_VECTOR(7 downto 0);
    signal w_end_Result : STD_LOGIC_VECTOR(7 downto 0);
    signal w_CV : STD_LOGIC;
begin

    w_op <= '1' when (i_op = "001") else '0';
    
    w_B <= (not i_B) when (i_op = "001") else i_B;
    
    with i_op select
    w_end_Result <=  w_AND when "010",
                 w_OR when "011",
                 w_Result when others;
                 
    w_AND <= i_A and i_B;
    w_OR <= i_A or i_B;
    
    ripple_adderAdd : ripple_adder
        port map(
            A => i_A,
            B => w_B,
            S => w_Result,
            Cin => w_op,
            Cout => w_CV
        );
                 
    o_flags(3) <= w_end_Result(7); 
    o_flags(2) <= '1' when (w_end_Result = x"00") else '0';
    o_flags(1) <= w_CV when (i_op(2 downto 1) = "00") else '0';
    o_flags(0) <= ((i_A(7) xnor w_B(7)) and (i_A(7) xor w_end_Result(7))) when (i_op(2 downto 1) = "00") else '0';
    
    o_result <= w_end_Result;

end Behavioral;

