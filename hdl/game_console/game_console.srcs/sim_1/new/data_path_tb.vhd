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
-- 		Test Utilities
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
use WORK.TEST_UTILS.ALL;


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
		report "Data Path Module: Reset Test: Begin" severity note;
		wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
		assert_equals(IR, x"00", "Data Path Module", "Reset Test", "IR");
		assert_equals(UUT_A, x"00", "Data Path Module", "Reset Test", "UUT_A");
		assert_equals(UUT_B, x"00", "Data Path Module", "Reset Test", "UUT_B");
		assert_equals(UUT_X, x"00", "Data Path Module", "Reset Test", "UUT_X");
		assert_equals(UUT_Y, x"00", "Data Path Module", "Reset Test", "UUT_Y");
		-- TODO: Implement Stack Pointer
		-- assert_equals(UUT_SP, x"00", "Data Path Module", "Reset Test", "UUT_SP");
		-- TODO: Change this to use reset vector x"FFFC"-x"FFFD"
		assert_equals(UUT_PC, x"4020", "Data Path Module", "Reset Test", "UUT_PC");
		assert_equals(UUT_MAR, x"0000", "Data Path Module", "Reset Test", "UUT_MAR");
		rst <= '1';  -- Take out of reset mode
		wait for CLK_PERIOD;  -- Wait 1 clock cycle before changing data
		report "Data Path Module: Reset Test: End" severity note;

		-- Test Loading Instruction Register
		report "Data Path Module: Load Instruction Register Test: Begin" severity note;
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
		assert_equals(IR, x"FF", "Data Path Module", "Load Instruction Register Test", "IR");
		report "Data Path Module: Load Instruction Register Test: End" severity note;

		-- Test Loading A Register
		report "Data Path Module: Load A Register Test: Begin" severity note;
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
		assert_equals(UUT_A, x"01", "Data Path Module", "Load A Register Test", "UUT_A");
		report "Data Path Module: Load A Register Test: End" severity note;

		-- Test Loading B Register
		report "Data Path Module: Load B Register Test: Begin" severity note;
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
		assert_equals(UUT_B, x"7F", "Data Path Module", "Load B Register Test", "UUT_B");
		report "Data Path Module: Load B Register Test: End" severity note;

		-- Test Loading X Register
		report "Data Path Module: Load X Register Test: Begin" severity note;
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
		assert_equals(UUT_X, x"FC", "Data Path Module", "Load X Register Test", "UUT_X");
		report "Data Path Module: Load X Register Test: End" severity note;

		-- Test Loading Y Register
		report "Data Path Module: Load Y Register Test: Begin" severity note;
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
		assert_equals(UUT_Y, x"FB", "Data Path Module", "Load Y Register Test", "UUT_Y");
		report "Data Path Module: Load Y Register Test: End" severity note;

		-- Test Loading MAR Register
		report "Data Path Module: Load MAR Register Test: Begin" severity note;
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
		assert_equals(UUT_MAR, x"02CB", "Data Path Module", "Load MAR Register Test", "UUT_MAR");
		report "Data Path Module: Load MAR Register Test: End" severity note;

		-- Test Loading PC Register
		report "Data Path Module: Load PC Register Test: Begin" severity note;
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
		assert_equals(UUT_PC, x"03AD", "Data Path Module", "Load PC Register Test", "UUT_PC");
		report "Data Path Module: Load PC Register Test: End" severity note;

		-- Test Incrementing PC Register
		report "Data Path Module: Increment PC Register Test: Begin" severity note;
		-- Set the data
		data <= BUS_HIGH_Z;  -- Set data to write
		IR_Load <= '0';
		MAR_Load <= '0';
		MAR_Byte <= '0';  -- 0 = Low Byte, 1 = High Byte
		PC_Load <= '0';
		PC_Inc <= '1';
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
		assert_equals(UUT_PC, x"03AE", "Data Path Module", "Increment PC Register Test", "UUT_PC");
		report "Data Path Module: Increment PC Register Test: End" severity note;

		-- Test ALU
		report "Data Path Module: ALU Test: Begin" severity note;
		-- Using the values previous set in A (01) and B (7F)
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
		assert_equals(UUT_A, x"80", "Data Path Module", "ALU Test", "UUT_A");
		-- N = 1, Z = 0, V = 1, C = 0
		assert_equals(Status_Result, x"0A", "Data Path Module", "ALU Test", "Status_Result");
		report "Data Path Module: ALU Test: End" severity note;
		wait;
	end process;

end data_path_tb_arch;
