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
	constant CLK_HZ: integer := 25178570;  -- 12.17857 MHz
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
		report "Sync Counter Reset Test Begin" severity note;
		wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
		assert sync = '1'
			report "Sync Counter Test: Reset Test - Invalid 'sync' value, " &
			"Expected: '1' but got '" &
			std_logic'image(sync) &
			"'"
			severity error;
		assert blank = '1'
			report "Sync Counter Test: Reset Test - Invalid 'blank' value, " &
			"Expected: '1' but got '" &
			std_logic'image(blank) &
			"'"
			severity error;
		rst <= '1';  -- Take out of reset mode
		report "Sync Counter Reset Test End" severity note;

		-- Test Blank State
		report "Sync Counter Blank Test Beging" severity note;
		wait for CLK_PERIOD;  -- Wait 1 clock cycle
		assert blank = '0'
			report "Sync Counter Test: Blank Test - Invalid 'blank' value, " &
			"Expected: '0' but got '" &
			std_logic'image(blank) &
			"'"
			severity error;
		-- wait for 1 after active area
		wait for (CLK_PERIOD * (SYNC_VALS.active - 6));
		assert blank = '1'
			report "Sync Counter Test: Blank Test - Invalid 'blank' value, " &
			"Expected: '1' but got '" &
			std_logic'image(blank) &
			"'"
			severity error;
		report "Sync Counter Blank Test End" severity note;

		-- Test Sync State
		report "Sync Counter Sync Test Beging" severity note;
		assert sync = '1'
			report "Sync Counter Test: Sync Test - Invalid 'sync' value, " &
			"Expected: '1' but got '" &
			std_logic'image(sync) &
			"'"
			severity error;
		-- wait for 1 after active area
		wait for (CLK_PERIOD * SYNC_VALS.front_porch);
		assert sync = '0'
			report "Sync Counter Test: Sync Test - Invalid 'sync' value, " &
			"Expected: '0' but got '" &
			std_logic'image(sync) &
			"'"
			severity error;
		-- wait till after the sync pulse
		wait for (CLK_PERIOD * SYNC_VALS.sync_pulse);
		assert sync = '1'
			report "Sync Counter Test: Sync Test - Invalid 'sync' value, " &
			"Expected: '1' but got '" &
			std_logic'image(sync) &
			"'"
			severity error;
		report "Sync Counter Sync Test End" severity note;
		wait;
	end process;

end sync_counter_tb_arch;
