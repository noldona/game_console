-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/19/2023 03:55:39 PM
-- Design Name: Register Test Bench
-- Module Name: reg_tb - reg_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the Register module
--
-- Dependencies:
-- 		Game Console Utilities
-- 		Register
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


entity reg_tb is
	--  port ();
end reg_tb;

architecture reg_tb_arch of reg_tb is
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
	component reg
		port (
			clk: in std_logic;
			rst: in std_logic;
			load: in std_logic;
			data_rx: in std_logic_vector(7 downto 0);
			data_tx: out std_logic_vector(7 downto 0)
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
	-- TODO: Implement the Register test bench

end reg_tb_arch;
