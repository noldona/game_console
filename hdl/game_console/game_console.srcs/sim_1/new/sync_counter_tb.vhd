-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/19/2023 03:55:39 PM
-- Design Name: Sync Counter Test Bench
-- Module Name: sync_counter_tb - sync_counter_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the Sync Counter module
--
-- Dependencies:
-- 		VGA Types
-- 		Game Console Utilities
-- 		Sync Counter
--
-- Revision: 0.1.0
-- Revision 0.1.0 - File Created
-- Additional Comments:
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use WORK.VGA_TYPES.ALL;
use WORK.CONSOLE_UTILS.ALL;


entity sync_counter_tb is
	--  port ();
end sync_counter_tb;

architecture sync_counter_tb_arch of sync_counter_tb is
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
	component sync_counter
		generic (
			resolution: t_VGA := SVGA_800_600_60;
			dir: std_logic := '0'  -- '0' = Horizontal, '1' = Vertical
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			sync: out std_logic;
			blank: out std_logic;
			addr: out std_logic_vector(15 downto 0);
			carry: out std_logic
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
	-- TODO: Implement the Sync Counter test bench

end sync_counter_tb_arch;
