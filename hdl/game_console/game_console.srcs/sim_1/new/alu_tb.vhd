-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/19/2023 03:55:39 PM
-- Design Name: Arithmetic Logic Unit Test Bench
-- Module Name: alu_tb - alu_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the Arithmetic Logic Unit module
--
-- Dependencies:
-- 		Arithmetic Logic Unit
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


entity alu_tb is
	--  port ();
end alu_tb;

architecture alu_tb_arch of alu_tb is
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
	component alu
		port (
			a: in std_logic_vector(7 downto 0);
			b: in std_logic_vector(7 downto 0);
			sel: in std_logic_vector(2 downto 0);
			result: out std_logic_vector(7 downto 0);
			status: out std_logic_vector(7 downto 0)
		);
	end component;

	-------------------------------
	-- Signals
	-------------------------------
	signal a: std_logic_vector(7 downto 0) := BUS_HIGH_Z;
	signal b: std_logic_vector(7 downto 0) := BUS_HIGH_Z;
	signal sel: std_logic_vector(2 downto 0) := "000";
	signal result: std_logic_vector(7 downto 0);
	signal status: std_logic_vector(7 downto 0) := x"00";

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	UUT: alu
		port map (
			a => a,
			b => b,
			sel => sel,
			result => result,
			status => status
		);

	-------------------------------
	-- Module Implementation
	-------------------------------
	ALU_TEST: process
	begin
		-- Test Addition
		report "ALU Addition Test Begin" severity note;
		a <= x"02";  -- +2
		b <= x"03";  -- +2
		sel <= "000";  -- Addition
		wait for 1ns;  -- Wait for ALU to process
		assert result = x"05"  -- +5
			report "ALU Test: Addition Test - Invalid 'result' value, " &
				"Expected: '05' but got '" &
				to_hstring(result) &
				"'"
			severity error;
		assert status = x"00"  -- N = 0, Z = 0, V = 0, C = 0
			report "ALU Test: Addition Test - Invalid 'status' value, " &
				"Expected: '00' but got '" &
				to_hstring(status) &
				"'"
			severity error;
		report "ALU Addition Test End" severity note;

		-- Test Negative Flag
		report "ALU Negative Test Begin" severity note;
		a <= x"02";  -- +2
		b <= x"FD";  -- -3
		sel <= "000";  -- Addition
		wait for 1ns;  -- Wait for ALU to process
		assert result = x"FF"  -- -1
			report "ALU Test: Negative Test - Invalid 'result' value, " &
				"Expected: 'FF' but got '" &
				to_hstring(result) &
				"'"
			severity error;
		assert status = x"08"  -- N = 1, Z = 0, V = 0, C = 0
			report "ALU Test: Negative Test - Invalid 'status' value, " &
				"Expected: '08' but got '" &
				to_hstring(status) &
				"'"
			severity error;
		report "ALU Negative Test End" severity note;

		-- Test Zero Flag
		report "ALU Zero Test Begin" severity note;
		a <= x"00";  -- 0
		b <= x"00";  -- 0
		sel <= "000";  -- Addition
		wait for 1ns;  -- Wait for ALU to process
		assert result = x"00"  -- 0
			report "ALU Test: Zero Test - Invalid 'result' value, " &
				"Expected: '00' but got '" &
				to_hstring(result) &
				"'"
			severity error;
		assert status = x"04"  -- N = 0, Z = 1, V = 0, C = 0
			report "ALU Test: Zero Test - Invalid 'status' value, " &
				"Expected: '04' but got '" &
				to_hstring(status) &
				"'"
			severity error;
		report "ALU Zero Test End" severity note;

		-- Test Overflow Flag
		report "ALU Overflow Test Begin" severity note;
		a <= x"01";  -- +1
		b <= x"7F";  -- +127
		sel <= "000";  -- Addition
		wait for 1ns;  -- Wait for ALU to process
		assert result = x"80"  -- -128
			report "ALU Test: Overflow Test - Invalid 'result' value, " &
				"Expected: '80' but got '" &
				to_hstring(result) &
				"'"
			severity error;
		assert status = x"0A"  -- N = 1, Z = 0, V = 1, C = 0
			report "ALU Test: Overflow Test - Invalid 'status' value, " &
				"Expected: '0A' but got '" &
				to_hstring(status) &
				"'"
			severity error;
		report "ALU Overflow Test End" severity note;

		-- Test Carry Flag
		report "ALU Carry Test Begin" severity note;
		a <= x"FF";  -- +255
		b <= x"01";  -- +1
		sel <= "000";  -- Addition
		wait for 1ns;  -- Wait for ALU to process
		assert result = x"00"  -- 0
			report "ALU Test: Carry Test - Invalid 'result' value, " &
				"Expected: '05' but got '" &
				to_hstring(result) &
				"'"
			severity error;
		assert status = x"05" -- N = 0, Z = 1, V = 0, C = 1
			report "ALU Test: Carry Test - Invalid 'status' value, " &
				"Expected: '05' but got '" &
				to_hstring(status) &
				"'"
			severity error;
		report "ALU Carry Test End" severity note;
		wait;
	end process;

end alu_tb_arch;
