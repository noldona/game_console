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
-- 		Test Utilities
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
use WORK.TEST_UTILS.ALL;


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
	constant CLK_HZ: integer := 25178570;  -- 25.17857 MHz
	constant CLK_PERIOD: time := 1 sec / clk_hz;

	-------------------------------
	-- Components
	-------------------------------
	component memory
		generic (
			IO_DIR: std_logic_vector(15 downto 0) := x"0000"
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			data: inout std_logic_vector(7 downto 0);
			addr: in std_logic_vector(15 downto 0);
			state: in t_Bus_States;
			io_ports: inout t_Digital_IO(15 downto 0)(7 downto 0)
		);
	end component;

	component ram_tb
		-- port ();
	end component;

	component io_tb
		-- port ();
	end component;

	-------------------------------
	-- Signals
	-------------------------------
	signal clk: std_logic := '0';
	signal rst: std_logic := '0';
	signal data: std_logic_vector(7 downto 0) := BUS_HIGH_Z;
	signal addr: std_logic_vector(15 downto 0) := x"0000";
	signal state: t_Bus_States := OFF;
	signal io_ports: t_Digital_IO(15 downto 0)(7 downto 0) := (others => BUS_HIGH_Z);

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	UUT: memory
		generic map (
			IO_DIR => x"0020"  -- I/O Bit 5 as output
		)
		port map (
			clk => clk,
			rst => rst,
			data => data,
			addr => addr,
			state => state,
			io_ports => io_ports
		);

	-- Submodule Test Benches
	RAM_UUT: ram_tb;
	IO_UUT: io_tb;

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

	MEMORY_TEST: process
	begin
		-- Test Reset State
		report "Memory Module: Reset Test: Begin" severity note;
			wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
			assert_equals(data, BUS_HIGH_Z, "Memory Module", "Reset Test", "data");
			rst <= '1';  -- Take out of reset mode
			wait for CLK_PERIOD;  -- Wait 1 clock cycle before changing data
		report "Memory Module: Reset Test: End" severity note;

		-- Test Writing/Reading Working RAM
		report "Memory Module: Write/Read Working RAM Test: Begin" severity note;
			-- Set the data
			state <= WRITE;  -- Put in WRITE mode
			addr <= x"01AA";  -- Set address to write to in Working RAM
			data <= x"FF";  -- Set data to write
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
			data <= BUS_HIGH_Z;  -- Reset data for prepartion of the next assert
			state <= READ;  -- Put into READ mode
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be read
			assert_equals(data, x"FF", "Memory Module", "Write/Read Working RAM Test", "data");
		report "Memory Module: Write/Read Working RAM Test: End" severity note;

		-- Test Writing/Reading Program ROM
		report "Memory Module: Write/Read Program ROM Test: Begin" severity note;
			-- Set the data
			state <= WRITE;  -- Put in WRITE mode
			addr <= x"41A8";  -- Set address to write to in Program ROM
			data <= x"FF";  -- Set data to write
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
			data <= BUS_HIGH_Z;  -- Reset data for prepartion of the next assert
			state <= READ;  -- Put into READ mode
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be read
			assert_equals(data, x"88", "Memory Module", "Write/Read Program ROM Test", "data");
		report "Memory Module: Write/Read Program ROM Test: End" severity note;

		-- Test Writing I/O
		report "Memory Module: Writing I/O Test: Begin" severity note;
			state <= WRITE;  -- Put in WRITE mode
			addr <= x"4005";  -- Set address to write to in I/O
			data <= BUS_HIGH_Z;
			wait for CLK_PERIOD;
			data <= x"FF";  -- Set data to write
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
			data <= BUS_HIGH_Z;  -- Reset data for prepartion of the next assert
			state <= READ;  -- Put into READ mode
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be read
			assert_equals(io_ports(5), x"FF", "Memory Module", "Writing I/O Test", "io_ports(5)");
		report "Memory Module: Writing I/O Test: End" severity note;

		-- Test Reading I/O
		report "Memory Module: Reading I/O Test: Begin" severity note;
			state <= READ;  -- Put into READ mode
			addr <= x"4004";  -- Set address to read from in I/O
			io_ports(4) <= x"AA";  -- Set data for I/O input
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be read
			assert_equals(data, x"AA", "Memory Module", "Reading I/O Test", "data");
		report "Memory Module: Reading I/O Test: End" severity note;

		wait;
	end process;

end memory_tb_arch;
