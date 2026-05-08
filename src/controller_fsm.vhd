----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:42:49 PM
-- Design Name: 
-- Module Name: controller_fsm - FSM
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

entity controller_fsm is
    Port ( clk : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture FSM of controller_fsm is
    signal f_Q : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    signal f_Q_next : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    signal f_adv_reg : std_logic;
    
begin
    f_Q_next(0) <= i_reset or (i_adv and f_Q(3) and not f_Q(2) and not f_Q(1) and not f_Q(0)) or (not i_adv and not f_Q(3) and not f_Q(2) and not f_Q(1) and f_Q(0));
    f_Q_next(1) <= (i_adv and not f_Q(3) and not f_Q(2) and not f_Q(1) and f_Q(0)) or (not i_adv and not f_Q(3) and not f_Q(2) and f_Q(1) and not f_Q(0));
    f_Q_next(2) <= (i_adv and not f_Q(3) and not f_Q(2) and f_Q(1) and not f_Q(0)) or (not i_adv and not f_Q(3) and f_Q(2) and not f_Q(1) and not f_Q(0));
    f_Q_next(3) <= (i_adv and not f_Q(3) and f_Q(2) and not f_Q(1) and not f_Q(0)) or (not i_adv and f_Q(3) and not f_Q(2) and not f_Q(1) and not f_Q(0));
    
    o_cycle(0) <= f_Q(0);
    o_cycle(1) <= f_Q(1);
    o_cycle(2) <= f_Q(2);
    o_cycle(3) <= f_Q(3);
    
    
    process(clk)
    begin
    if rising_edge(clk) then
        if i_reset = '1' then
            f_Q <= "0001";
        elsif (i_adv = '1') then 
            f_Q <= f_Q_next;
        end if;
    end if;
end process;        
end FSM;
