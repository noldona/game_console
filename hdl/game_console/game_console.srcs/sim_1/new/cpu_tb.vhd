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
	constant CLK_HZ: integer := 25178570;  -- 25.17857 MHz
	constant CLK_PERIOD: time := 1 sec / clk_hz;

	-------------------------------
	-- Components
	-------------------------------
	component cpu
		port (
			clk: in std_logic;
			rst: in std_logic;
			data: inout std_logic_vector(7 downto 0);
			addr: out std_logic_vector(15 downto 0);
			state: out t_Bus_States;
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
	signal clk: std_logic := '0';
	signal rst: std_logic := '0';
	signal data: std_logic_vector(7 downto 0) := BUS_HIGH_Z;
	signal addr: std_logic_vector(15 downto 0);
	signal state: t_Bus_States;
	signal rdy: std_logic;

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	UUT: cpu
		port map (
			clk => clk,
			rst => rst,
			data => data,
			addr => addr,
			state => state,
			rdy => rdy
		);

	-- Submodule Test Benches
	-- Commented out because CPU test interferes with below test benches
	-- DATA_PATH_UUT: data_path_tb;
	-- CONTROL_UNIT_UUT: control_unit_tb;

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

	CPU_TEST: process
		variable tst_addr: integer := 16#4020#;
	begin
		-- Test Reset State
		report "CPU Module: Reset Test: Begin" severity note;
			wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
			assert_equals(addr, x"0000", "CPU Module", "Reset Test", "addr");
			assert_equals(data, BUS_HIGH_Z, "CPU Module", "Reset Test", "data");
			assert_equals(state, OFF, "CPU Module", "Reset Test", "state");
			rst <= '1';  -- Take out of reset mode
			wait for CLK_PERIOD;  -- Wait 1 clock cycle before changing data
		report "CPU Module: Reset Test: End" severity note;

		report "CPU Module: Address Test: Begin" severity note;
			wait for CLK_PERIOD;  -- Wait till address is fully loaded
			assert_equals(to_integer(unsigned(addr)), tst_addr, "CPU Module", "Address Test", "addr");
			tst_addr := tst_addr + 1;
			wait for CLK_PERIOD * 4;  -- Wait till next address
			for i in 0 to 4 loop
				assert_equals(to_integer(unsigned(addr)), tst_addr, "CPU Module", "Address Test", "addr");
				tst_addr := tst_addr + 1;
				wait for CLK_PERIOD * 5;  -- Wait till next address
			end loop;
		report "CPU Module: Address Test: End" severity note;
		wait;
	end process;

end cpu_tb_arch;
