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
-- 		Test Utilities
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
use WORK.TEST_UTILS.ALL;


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
	constant CLK_HZ: integer := 25178570;  -- 12.17857 MHz
	constant CLK_PERIOD: time := 1 sec / CLK_HZ;

	-------------------------------
	-- Components
	-------------------------------
	component reg
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
	end component;

	-------------------------------
	-- Signals
	-------------------------------
	signal clk: std_logic := '0';
	signal rst: std_logic := '0';
	signal load: std_logic := '0';
	signal data_rx: std_logic_vector(15 downto 0);
	signal data_tx: std_logic_vector(15 downto 0);

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	UUT: reg
		generic map (
			SIZE => 16
		)
		port map (
			clk => clk,
			rst => rst,
			load => load,
			data_rx => data_rx,
			data_tx => data_tx
		);

	-------------------------------
	-- Module Implementation
	-------------------------------
	CLK_PROC: process
	begin
		wait for CLK_PERIOD / 2;
		if (clk = '1') then
			clk <= '0';
		else
			clk <= '1';
		end if;
	end process;

	REG_TEST: process
	begin
		-- Test Reset State
		report "Register Module: Reset Test: Begin" severity note;
		wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
		assert_equals(data_tx, x"0000", "Register Test", "Reset Test", "data_tx");
		rst <= '1';  -- Take out of reset mode
		wait for CLK_PERIOD;  -- Wait 1 clock cycle before changing data
		report "Register Module: Reset Test: End" severity note;

		-- Test Loading
		report "Register Module: Load Test: Begin" severity note;
		-- Set the data
		load <= '1';
		data_rx <= x"FFFF";
		assert_equals(data_tx, x"0000", "Register Test", "Load Test: Preload", "data_tx");
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be loaded
		assert_equals(data_tx, x"FFFF", "Register Test", "Reset Test: Postload", "data_tx");
		report "Register Module: Load Test: End" severity note;
		wait;
	end process;

end reg_tb_arch;
