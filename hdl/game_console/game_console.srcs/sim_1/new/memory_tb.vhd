-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/19/2023 03:55:39 PM
-- Design Name: Memory Test Bench
-- Module Name: memory_tb - memory_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the Memory module
--
-- Dependencies:
-- 		Game Console Utilities
-- 		Memory
-- 		Random Access Memory Test Bench
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


entity memory_tb is
	--  port ();
end memory_tb;

architecture memory_tb_arch of memory_tb is
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
	component memory
		port (
			clk: in std_logic;
			rst: in std_logic;
			data: inout std_logic_vector(7 downto 0);
			addr: in std_logic_vector(15 downto 0);
			state: in t_Bus_State;
			io: inout t_Digital_IO(0 to 15)(7 downto 0)
		);
	end component;

	component ram_tb
		-- port ();
	end component;

	-------------------------------
	-- Signals
	-------------------------------

begin
	-------------------------------
	-- Component Implementations
	-------------------------------

	-------------------------------
	-- Module Implementation
	-------------------------------
	-- TODO: Implement the Memory test bench

	RAM_UUT: ram_tb;

end memory_tb_arch;
