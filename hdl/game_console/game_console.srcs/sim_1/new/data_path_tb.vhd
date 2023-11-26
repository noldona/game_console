-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/19/2023 03:55:39 PM
-- Design Name: Data Path Test Bench
-- Module Name: data_path_tb - data_path_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the Data Path module
--
-- Dependencies:
-- 		Game Console Utilities
-- 		Data Path
-- 		Arithmetic Logic Unit Test Bench
-- 		Register Test Bench
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


entity data_path_tb is
	--  port ();
end data_path_tb;

architecture data_path_tb_arch of data_path_tb is
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
	constant CLK_PERIOD: time := 1 sec / clk_hz;

	-------------------------------
	-- Components
	-------------------------------
	component data_path
		port (
			clk: in std_logic;
			rst: in std_logic;
			data: inout std_logic_vector(7 downto 0);
			addr: out std_logic_vector(15 downto 0);
			IR_Load: in std_logic;
			IR: out std_logic_vector(7 downto 0);
			MAR_Load: in std_logic;
			MAR_Byte: in std_logic;
			PC_Load: in std_logic;
			PC_Inc: in std_logic;
			PC_Byte: in std_logic;
			A_Load: in std_logic;
			B_Load: in std_logic;
			X_Load: in std_logic;
			Y_Load: in std_logic;
			ALU_Sel: in std_logic_vector(2 downto 0);
			Status_Result: out std_logic_vector(7 downto 0);
			Status_Load: in std_logic;
			Bus1_Sel: in std_logic_vector(1 downto 0);
			Bus2_Sel: in std_logic_vector(1 downto 0)
		);
	end component;

	component alu_tb
		-- port ();
	end component;

	component reg_tb
		-- port ();
	end component;

	-------------------------------
	-- Signals
	-------------------------------
	signal clk: std_logic := '0';
	signal rst: std_logic := '0';
	signal data: std_logic_vector(7 downto 0) := BUS_HIGH_Z;
	signal addr: std_logic_vector(15 downto 0) := x"0000";
	signal IR_Load: std_logic := '0';
	signal IR: std_logic_vector(7 downto 0);
	signal MAR_Load: std_logic := '0';
	signal MAR_Byte: std_logic := '0';
	signal PC_Load: std_logic := '0';
	signal PC_Inc: std_logic := '0';
	signal PC_Byte: std_logic := '0';
	signal A_Load: std_logic := '0';
	signal B_Load: std_logic := '0';
	signal X_Load: std_logic := '0';
	signal Y_Load: std_logic := '0';
	signal ALU_Sel: std_logic_vector(2 downto 0) := "000";
	signal Status_Result: std_logic_vector(7 downto 0);
	signal Status_Load: std_logic := '0';
	signal Bus1_Sel: std_logic_vector(1 downto 0) := "00";
	signal Bus2_Sel: std_logic_vector(1 downto 0) := "00";

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	UUT: data_path
		port map (
			clk => clk,
			rst => rst,
			data => data,
			addr => addr,
			IR_Load => IR_Load,
			IR => IR,
			MAR_Load => MAR_Load,
			MAR_Byte => MAR_Byte,
			PC_Load => PC_Load,
			PC_Inc => PC_Inc,
			PC_Byte => PC_Byte,
			A_Load => A_Load,
			B_Load => B_Load,
			X_Load => X_Load,
			Y_Load => Y_Load,
			ALU_Sel => ALU_Sel,
			Status_Result => Status_Result,
			Status_Load => Status_Load,
			Bus1_Sel => Bus1_Sel,
			Bus2_Sel => Bus2_Sel
		);

	-- Submodule Test Benches
	ALU_UUT: alu_tb;
	REG_UUT: reg_tb;

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

	DATA_PATH_TEST: process
		alias UUT_A is <<signal UUT.A: std_logic_vector(7 downto 0)>>;
		alias UUT_B is <<signal UUT.B: std_logic_vector(7 downto 0)>>;
		alias UUT_X is <<signal UUT.X: std_logic_vector(7 downto 0)>>;
		alias UUT_Y is <<signal UUT.Y: std_logic_vector(7 downto 0)>>;
		alias UUT_SP is <<signal UUT.SP: std_logic_vector(7 downto 0)>>;
		alias UUT_PC is <<signal UUT.PC: std_logic_vector(15 downto 0)>>;
		alias UUT_MAR is <<signal UUT.MAR: std_logic_vector(15 downto 0)>>;
	begin
		-- Test Reset State
		report "Data Path Reset Test Begin" severity note;
		wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
		assert IR = x"00"
			report "Data Path Test: Reset Test - Invalid 'IR' value, " &
				"Expected: '00' but got '" &
				to_hstring(IR) &
				"'"
			severity error;
		assert UUT_A = x"00"
			report "Data Path Test: Reset Test - Invalid 'UUT_A' value, " &
				"Expected: '00' but got '" &
				to_hstring(UUT_A) &
				"'"
			severity error;
		assert UUT_B = x"00"
			report "Data Path Test: Reset Test - Invalid 'UUT_B' value, " &
				"Expected: '00' but got '" &
				to_hstring(UUT_B) &
				"'"
			severity error;
		assert UUT_X = x"00"
			report "Data Path Test: Reset Test - Invalid 'UUT_X' value, " &
				"Expected: '00' but got '" &
				to_hstring(UUT_X) &
				"'"
			severity error;
		assert UUT_Y = x"00"
			report "Data Path Test: Reset Test - Invalid 'UUT_Y' value, " &
				"Expected: '00' but got '" &
				to_hstring(UUT_Y) &
				"'"
			severity error;
		-- TODO: Implement Stack Pointer
		-- assert UUT_SP = x"00"
		-- 	report "Data Path Test: Reset Test - Invalid 'UUT_SP' value, " &
		-- 		"Expected: '00' but got '" &
		-- 		to_hstring(UUT_SP) &
		-- 		"'"
		-- 	severity error;
		assert UUT_PC = x"4020"  -- TODO: Change this to use reset vector x"FFFC"-x"FFFD"
			report "Data Path Test: Reset Test - Invalid 'UUT_PC' value, " &
				"Expected: '00' but got '" &
				to_hstring(UUT_PC) &
				"'"
			severity error;
		assert UUT_MAR = x"0000"
			report "Data Path Test: Reset Test - Invalid 'UUT_MAR' value, " &
				"Expected: '00' but got '" &
				to_hstring(UUT_MAR) &
				"'"
			severity error;
		rst <= '1';  -- Take out of reset mode
		wait for CLK_PERIOD;  -- Wait 1 clock cycle before changing data
		report "Data Path Reset Test End" severity note;

		-- Test Loading Instruction Register
		report "Data Path Load Instruction Register Test Begin" severity note;
		-- Set the data
		data <= x"FF";  -- Set data to write
		IR_Load <= '1';
		MAR_Load <= '0';
		MAR_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		PC_Load <= '0';
		PC_Inc <= '0';
		PC_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		A_Load <= '0';
		B_Load <= '0';
		X_Load <= '0';
		Y_Load <= '0';
		ALU_Sel <= "000";  -- 000 = Addition
		Status_Load <= '0';
		Bus1_Sel <= "00";  -- "00" = PC Low Byte, "01" = PC High Byte, "10" = A, "11" = B
		Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Data Bus
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		assert IR = x"FF"
			report "Data Path Test: Load Instruction Register Test - Invalid 'IR' value, " &
			"Expected: 'FF' but got '" &
			to_hstring(IR) &
			"'"
			severity error;
		report "Data Path Load Instruction Register Test End" severity note;

		-- Test Loading A Register
		report "Data Path Load A Register Test Begin" severity note;
		-- Set the data
		data <= x"01";  -- Set data to write
		IR_Load <= '0';
		MAR_Load <= '0';
		MAR_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		PC_Load <= '0';
		PC_Inc <= '0';
		PC_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		A_Load <= '1';
		B_Load <= '0';
		X_Load <= '0';
		Y_Load <= '0';
		ALU_Sel <= "000";  -- 000 = Addition
		Status_Load <= '0';
		Bus1_Sel <= "00";  -- "00" = PC Low Byte, "01" = PC High Byte, "10" = A, "11" = B
		Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Data Bus
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		assert UUT_A = x"01"
			report "Data Path Test: Load A Register Test - Invalid 'UUT_A' value, " &
			"Expected: '01' but got '" &
			to_hstring(UUT_A) &
			"'"
			severity error;
		report "Data Path Load A Register Test End" severity note;

		-- Test Loading B Register
		report "Data Path Load B Register Test Begin" severity note;
		-- Set the data
		data <= x"7F";  -- Set data to write
		IR_Load <= '0';
		MAR_Load <= '0';
		MAR_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		PC_Load <= '0';
		PC_Inc <= '0';
		PC_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		A_Load <= '0';
		B_Load <= '1';
		X_Load <= '0';
		Y_Load <= '0';
		ALU_Sel <= "000";  -- 000 = Addition
		Status_Load <= '0';
		Bus1_Sel <= "00";  -- "00" = PC Low Byte, "01" = PC High Byte, "10" = A, "11" = B
		Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Data Bus
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		assert UUT_B = x"7F"
			report "Data Path Test: Load B Register Test - Invalid 'UUT_B' value, " &
			"Expected: '7F' but got '" &
			to_hstring(UUT_B) &
			"'"
			severity error;
		report "Data Path Load B Register Test End" severity note;

		-- Test Loading X Register
		report "Data Path Load X Register Test Begin" severity note;
		-- Set the data
		data <= x"FC";  -- Set data to write
		IR_Load <= '0';
		MAR_Load <= '0';
		MAR_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		PC_Load <= '0';
		PC_Inc <= '0';
		PC_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		A_Load <= '0';
		B_Load <= '0';
		X_Load <= '1';
		Y_Load <= '0';
		ALU_Sel <= "000";  -- 000 = Addition
		Status_Load <= '0';
		Bus1_Sel <= "00";  -- "00" = PC Low Byte, "01" = PC High Byte, "10" = A, "11" = B
		Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Data Bus
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		assert UUT_X = x"FC"
			report "Data Path Test: Load X Register Test - Invalid 'UUT_X' value, " &
			"Expected: 'FC' but got '" &
			to_hstring(UUT_X) &
			"'"
			severity error;
		report "Data Path Load X Register Test End" severity note;

		-- Test Loading Y Register
		report "Data Path Load Y Register Test Begin" severity note;
		-- Set the data
		data <= x"FB";  -- Set data to write
		IR_Load <= '0';
		MAR_Load <= '0';
		MAR_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		PC_Load <= '0';
		PC_Inc <= '0';
		PC_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		A_Load <= '0';
		B_Load <= '0';
		X_Load <= '0';
		Y_Load <= '1';
		ALU_Sel <= "000";  -- 000 = Addition
		Status_Load <= '0';
		Bus1_Sel <= "00";  -- "00" = PC Low Byte, "01" = PC High Byte, "10" = A, "11" = B
		Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Data Bus
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		assert UUT_Y = x"FB"
			report "Data Path Test: Load Y Register Test - Invalid 'UUT_Y' value, " &
			"Expected: 'FB' but got '" &
			to_hstring(UUT_Y) &
			"'"
			severity error;
		report "Data Path Load Y Register Test End" severity note;

		-- Test Loading MAR Register
		report "Data Path Load MAR Register Test Begin" severity note;
		-- Set the data
		data <= x"CB";  -- Set data to write
		IR_Load <= '0';
		MAR_Load <= '1';
		MAR_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		PC_Load <= '0';
		PC_Inc <= '0';
		PC_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		A_Load <= '0';
		B_Load <= '0';
		X_Load <= '0';
		Y_Load <= '0';
		ALU_Sel <= "000";  -- 000 = Addition
		Status_Load <= '0';
		Bus1_Sel <= "00";  -- "00" = PC Low Byte, "01" = PC High Byte, "10" = A, "11" = B
		Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Data Bus
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		data <= x"02";  -- Set data to write
		IR_Load <= '0';
		MAR_Load <= '1';
		MAR_Byte <= '1';  -- 0 = Low Byte, 1 = High Byte
		PC_Load <= '0';
		PC_Inc <= '0';
		PC_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		A_Load <= '0';
		B_Load <= '0';
		X_Load <= '0';
		Y_Load <= '0';
		ALU_Sel <= "000";  -- 000 = Addition
		Status_Load <= '0';
		Bus1_Sel <= "00";  -- "00" = PC Low Byte, "01" = PC High Byte, "10" = A, "11" = B
		Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Data Bus
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		assert UUT_MAR = x"02CB"
			report "Data Path Test: Load MAR Register Test - Invalid 'UUT_MAR' value, " &
			"Expected: '02CCB' but got '" &
			to_hstring(UUT_MAR) &
			"'"
			severity error;
		report "Data Path Load MAR Register Test End" severity note;

		-- Test Loading PC Register
		report "Data Path Load PC Register Test Begin" severity note;
		-- Set the data
		data <= x"AD";  -- Set data to write
		IR_Load <= '0';
		MAR_Load <= '0';
		MAR_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		PC_Load <= '1';
		PC_Inc <= '0';
		PC_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		A_Load <= '0';
		B_Load <= '0';
		X_Load <= '0';
		Y_Load <= '0';
		ALU_Sel <= "000";  -- 000 = Addition
		Status_Load <= '0';
		Bus1_Sel <= "00";  -- "00" = PC Low Byte, "01" = PC High Byte, "10" = A, "11" = B
		Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Data Bus
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		data <= x"03";  -- Set data to write
		IR_Load <= '0';
		MAR_Load <= '0';
		MAR_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		PC_Load <= '1';
		PC_Inc <= '0';
		PC_Byte <= '1';  -- 0 = Low Byte, 1 = High Byte
		A_Load <= '0';
		B_Load <= '0';
		X_Load <= '0';
		Y_Load <= '0';
		ALU_Sel <= "000";  -- 000 = Addition
		Status_Load <= '0';
		Bus1_Sel <= "00";  -- "00" = PC Low Byte, "01" = PC High Byte, "10" = A, "11" = B
		Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Data Bus
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		assert UUT_PC = x"03AD"
			report "Data Path Test: Load PC Register Test - Invalid 'UUT_PC' value, " &
			"Expected: 'FB' but got '" &
			to_hstring(UUT_PC) &
			"'"
			severity error;
		report "Data Path Load PC Register Test End" severity note;

		-- Test ALU
		report "Data Path ALU Test Begin" severity note;
		-- Using the values previous set in A (01) and B (7F)
		wait for CLK_PERIOD;  -- Wait 1 clock cycle to separate PC update and ALU Test
		-- Set the data
		data <= x"AD";  -- Set data to write
		IR_Load <= '0';
		MAR_Load <= '0';
		MAR_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		PC_Load <= '0';
		PC_Inc <= '0';
		PC_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		A_Load <= '1';
		B_Load <= '0';
		X_Load <= '0';
		Y_Load <= '0';
		ALU_Sel <= "000";  -- 000 = Addition
		Status_Load <= '1';
		Bus1_Sel <= "10";  -- "00" = PC Low Byte, "01" = PC High Byte, "10" = A, "11" = B
		Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Data Bus
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		IR_Load <= '0';
		MAR_Load <= '0';
		MAR_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		PC_Load <= '0';
		PC_Inc <= '0';
		PC_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		A_Load <= '0';
		B_Load <= '0';
		X_Load <= '0';
		Y_Load <= '0';
		ALU_Sel <= "111";  -- 000 = Addition
		Status_Load <= '0';
		Bus1_Sel <= "10";  -- "00" = PC Low Byte, "01" = PC High Byte, "10" = A, "11" = B
		Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Data Bus
		assert UUT_A = x"80"  -- -128
			report "Data Path Test: ALU Test - Invalid 'UUT_A' value, " &
				"Expected: '80' but got '" &
				to_hstring(UUT_A) &
				"'"
			severity error;
		assert Status_Result = x"0A"  -- N = 1, Z = 0, V = 1, C = 0
			report "Data Path Test: ALU Test - Invalid 'Status_Result' value, " &
				"Expected: '0A' but got '" &
				to_hstring(Status_Result) &
				"'"
			severity error;
		report "Data Path ALU Test End" severity note;
		wait;
	end process;

end data_path_tb_arch;
