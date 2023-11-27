-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/19/2023 03:55:39 PM
-- Design Name: Memory Mapper Test Bench
-- Module Name: memory_mapper_tb - memory_mapper_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the Memory Mapper module
--
-- Dependencies:
-- 		Game Console Utilities
-- 		Test Utilities
-- 		Memory Mapper
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
use WORK.TEST_UTILS.ALL;


entity memory_mapper_tb is
	--  port ();
end memory_mapper_tb;

architecture memory_mapper_tb_arch of memory_mapper_tb is
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
	component memory_mapper
		generic (
			OFFSET: integer := 0;
			X_MAX: integer := 16#640#;
			Y_MAX: integer := 16#480#;
			X_DIV: integer := 2;
			Y_DIV: integer := 2
		);
		port (
			clk: in std_logic;
			addr_x: in std_logic_vector(15 downto 0);
			addr_y: in std_logic_vector(15 downto 0);
			hblank: in std_logic;
			vblank: in std_logic;
			rdy: in std_logic;
			addr: out std_logic_vector(15 downto 0)
		);
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
	-- TODO: Implement the Memory Mapper test bench

end memory_mapper_tb_arch;
