-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/29/2023 11:24:47 AM
-- Design Name: Arithmetic Logic Unit
-- Module Name: alu - alu_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This module handles all of the math and logic cacluations for
-- 		the processor.
--
-- Dependencies: None
--
-- Revision: 0.1.0
-- Revision 0.1.0 - File Created
-- Additional Comments:
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use WORK.CONSOLE_UTILS.ALL;


entity alu is
	port (
		a: in std_logic_vector(7 downto 0);
		b: in std_logic_vector(7 downto 0);
		sel: in std_logic_vector(2 downto 0);
		result: out std_logic_vector(7 downto 0);
		status: out std_logic_vector(7 downto 0)
	);
end alu;

architecture alu_arch of alu is
	-------------------------------
	-- Functions
	-------------------------------

	-------------------------------
	-- Types
	-------------------------------

	-------------------------------
	-- Constants
	-------------------------------

	-------------------------------
	-- Components
	-------------------------------

	-------------------------------
	-- Signals
	-------------------------------

begin
	-------------------------------
	-- Component Implementations
	-------------------------------

	-------------------------------
	-- Module Implementation
	------------------------------
	-- TODO: Updated this to use the 6502 status flags
	ALU_PROC: process (a, b, sel)
		variable sum_uns: unsigned (8 downto 0);
	begin
		case sel is
			-- Addition
			when "000" =>
				-- Produce the sum
				sum_uns := unsigned('0' & a) + unsigned('0' & b);
				result <= std_logic_vector(sum_uns(7 downto 0));

				-- Set the negative flag
				status(3) <= sum_uns(7);

				-- Set the zero flag
				if (sum_uns(7 downto 0) = x"00") then
					status(2) <= '1';
				else
					status(2) <= '0';
				end if;

				-- Set the overflow flag
				if ((a(7) = '0' and b(7) = '0' and sum_uns(7) = '1') or
						(a(7) = '1' and b(7) = '1' and sum_uns(7) = '0')) then
					status(1) <= '1';
				else
					status(1) <= '0';
				end if;

				-- Set the carry flag
				status(0) <= sum_uns(8);

			-- TODO: Implement Subtract
			-- TODO: Implement And
			-- TODO: Implement OR
			-- TODO: Implement Increment
			-- TODO: Implement Decrement

			when others =>
				result <= "ZZZZZZZZ";
				status <= "ZZZZZZZZ";
		end case;
	end process;

end alu_arch;
