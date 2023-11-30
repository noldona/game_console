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
-- 		Test Utilities
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
use WORK.TEST_UTILS.ALL;


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
	constant CLK_HZ: integer := 25178570;  -- 25.17857 MHz
	constant CLK_PERIOD: time := 1 sec / CLK_HZ;
	constant SYNC_VALS: t_Sync := VGA_640_480_60.hsync;

	-------------------------------
	-- Components
	-------------------------------
	component sync_counter
		generic (
			RESOLUTION: t_VGA := VGA_640_480_60;
			DIR: std_logic := '0'  -- '0' = Horizontal, '1' = Vertical
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
	signal clk: std_logic := '0';
	signal rst: std_logic := '0';
	signal sync: std_logic;
	signal blank: std_logic;
	signal addr: std_logic_vector(15 downto 0);
	signal carry: std_logic;


begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	UUT: sync_counter
		generic map (
			RESOLUTION => VGA_640_480_60,
			DIR => '0'
		)
		port map (
			clk => clk,
			rst => rst,
			sync => sync,
			blank => blank,
			addr => addr,
			carry => carry
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

	SYNC_COUNTER_TEST: process
	begin
		-- Test Reset State
		report "Sync Counter Module: Reset Test: Begin" severity note;
			wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
			assert_equals(sync, '1', "Sync Counter Test", "Reset Test", "sync");
			assert_equals(blank, '1', "Sync Counter Test", "Reset Test", "blank");
			rst <= '1';  -- Take out of reset mode
			wait for CLK_PERIOD;  -- Wait 1 clock cycle before changing data
		report "Sync Counter Module: Reset Test: End" severity note;

		-- Test Blank State
		report "Sync Counter Module: Blank Test: Begin" severity note;
			assert_equals(blank, '0', "Sync Counter Test", "Blank Test", "blank");
			-- wait for 1 after active area
			wait for (CLK_PERIOD * (SYNC_VALS.active - 6));
			assert_equals(blank, '1', "Sync Counter Test", "Blank Test", "blank");
		report "Sync Counter Module: Blank Test: End" severity note;

		-- Test Sync State
		report "Sync Counter Module: Sync Test: Begin" severity note;
			assert_equals(sync, '1', "Sync Counter Test", "Sync Test", "sync");
			-- wait for 1 after active area
			wait for (CLK_PERIOD * SYNC_VALS.front_porch);
			assert_equals(sync, '0', "Sync Counter Test", "Sync Test", "sync");
			-- wait till after the sync pulse
			wait for (CLK_PERIOD * SYNC_VALS.sync_pulse);
			assert_equals(sync, '1', "Sync Counter Test", "Sync Test", "sync");
		report "Sync Counter Module: Sync Test: End" severity note;

		wait;
	end process;

end sync_counter_tb_arch;
