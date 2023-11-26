-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/25/2023 03:10:30 PM
-- Design Name: Input/Output Ports Test Bench
-- Module Name: io_tb - io_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the Input/Output Ports module
--
-- Dependencies:
-- 		Game Console Utilities
-- 		Input/Output ports
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


entity io_tb is
	--  port ( );
end io_tb;

architecture io_tb_arch of io_tb is
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
	component io
		generic (
			START_ADDRESS: integer := 16#0000#;
			IO_DIR: std_logic_vector(0 to 15)
		);
		port (
			clk : in std_logic;
			rst : in std_logic;
			state : in t_Bus_State;
			addr : in std_logic_vector (15 downto 0);
			data : inout std_logic_vector (7 downto 0);
			io_ports: inout t_Digital_IO(15 downto 0)(7 downto 0)
		);
	end component;

	-------------------------------
	-- Signals
	-------------------------------
	signal clk: std_logic := '0';
	signal rst: std_logic := '0';
	signal state: t_Bus_State := OFF;
	signal addr: std_logic_vector(15 downto 0) := x"0000";
	signal data: std_logic_vector(7 downto 0) := BUS_HIGH_Z;
	signal io_ports: t_Digital_IO(15 downto 0)(7 downto 0) := (others => BUS_HIGH_Z);

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	UUT: io
		generic map (
			START_ADDRESS => APU_REG_MIN,
			IO_DIR => x"0020"  -- Set Port 5 to output, the rest are inputs
		)
		port map (
			clk => clk,
			rst => rst,
			state => state,
			addr => addr,
			data => data,
			io_ports => io_ports
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

	IO_TEST: process
	begin
		-- Test Reset State
		report "I/O Reset Test Begin" severity note;
		wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
		assert data = BUS_HIGH_Z
			report "I/O Test: Reset Test - Invalid 'data' value, " &
				"Expected: 'ZZZZZZZZ' but got '" &
				to_hstring(data) &
				"'"
			severity error;
		rst <= '1';  -- Take out of reset mode
		report "I/O Reset Test End" severity note;

		-- Test Writing I/O
		report "I/O Writing I/O Test Begin" severity note;
		state <= WRITE;  -- Put in WRITE mode
		addr <= x"4005";  -- Set address to write to in I/O
		data <= x"FF";  -- Set data to write
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		data <= BUS_HIGH_Z;  -- Reset data for prepartion of the next assert
		state <= READ;  -- Put into READ mode
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be read
		assert io_ports(5) = x"FF"
			report "I/O Test: Writing I/O Test - Invalid 'data' value, " &
			"Expected: 'FF' but got '" &
			to_hstring(io_ports(5)) &
			"'"
			severity error;
		report "I/O Writing I/O Test End" severity note;

		-- Test Reading I/O
		report "I/O Reading I/O Test Begin" severity note;
		state <= READ;  -- Put into READ mode
		addr <= x"4004";  -- Set address to read from in I/O
		io_ports(4) <= x"AA";  -- Set data for I/O input
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be read
		assert data = x"AA"
			report "I/O Test: Reading I/O Test - Invalid 'data' value, " &
			"Expected: 'AA' but got '" &
			to_hstring(data) &
			"'"
			severity error;
		report "I/O Reading I/O Test End" severity note;
		wait;
	end process;

end io_tb_arch;
