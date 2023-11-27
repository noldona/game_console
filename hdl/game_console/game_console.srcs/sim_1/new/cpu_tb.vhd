-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/19/2023 03:55:39 PM
-- Design Name: Central Processing Unit Test Bench
-- Module Name: cpu_tb - cpu_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the Central Processing Unit module
--
-- Dependencies:
-- 		Game Console Utilities
-- 		Test Utilities
-- 		Central Processing Unit
-- 		Data Path Test Bench
--		Control Unit Test Bench
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


entity cpu_tb is
	--  port ();
end cpu_tb;

architecture cpu_tb_arch of cpu_tb is
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
	component cpu
		port (
			clk: in std_logic;
			rst: in std_logic;
			data: inout std_logic_vector(7 downto 0);
			addr: out std_logic_vector(15 downto 0);
			state: out t_Bus_State;
			rdy: out std_logic
		);
	end component;

	component data_path_tb
		-- port ();
	end component;

	component control_unit_tb
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
	-- TODO: Implement the Central Processing Unit test bench

	DATA_PATH_UUT: data_path_tb;
	CONTROL_UNIT_UUT: control_unit_tb;

end cpu_tb_arch;
