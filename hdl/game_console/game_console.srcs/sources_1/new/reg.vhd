-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/12/2023 12:30:19 PM
-- Design Name: Register
-- Module Name: reg - reg_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a simple 8-bit register
--
-- Dependencies:
-- 		Game Console Utilities
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


-- TODO: Update this to support larger than 8 bits
entity reg is
	generic (
		SIZE: integer := 8
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		load: in std_logic;
		data_rx: in std_logic_vector(SIZE - 1 downto 0);
		data_tx: out std_logic_vector(SIZE - 1 downto 0)
	);
end reg;

architecture reg_arch of reg is
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
	signal data: std_logic_vector(SIZE - 1 downto 0);

begin
	-------------------------------
	-- Component Implementations
	-------------------------------

	-------------------------------
	-- Module Implementation
	-------------------------------
	data_tx <= data;

	REG_PROC: process (clk, rst)
	begin
		if (rst = '0') then
			data <= (others => '0');
		elsif (rising_edge(clk)) then
			if (load = '1') then
				data <= data_rx;
			end if;
		end if;
	end process;

end reg_arch;
