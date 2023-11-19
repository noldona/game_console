-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/19/2023 03:55:39 PM
-- Design Name: Random Access Memory Test bench
-- Module Name: ram_tb - ram_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the Random Accesss Memory module
--
-- Dependencies:
-- 		Game Console Utilities
-- 		Random Access Memory
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


entity ram_tb is
	--  port ();
end ram_tb;

architecture ram_tb_arch of ram_tb is
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
	component ram
		generic (
			START_ADDRESS: integer := 16#0000#;
			END_ADDRESS: integer := 16#FFFFF#;
			INIT_FILE: string := "";
			READ_ONLY: std_logic := '0'  -- 0: RAM, 1: ROM
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			state: in t_Bus_State;
			addr: in std_logic_vector(15 downto 0);
			data: inout std_logic_vector(7 downto 0)
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
	-- TODO: Implement the Random Access Memory test bench

end ram_tb_arch;
