-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/19/2023 03:55:39 PM
-- Design Name: Control Unit Test Bench
-- Module Name: control_unit_tb - control_unit_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the Control Unit module
--
-- Dependencies:
-- 		Game Console Utilities
-- 		Test Utilities
-- 		Control Unit
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


entity control_unit_tb is
	--  port ();
end control_unit_tb;

architecture control_unit_tb_arch of control_unit_tb is
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
	component control_unit
		port (
			clk: in std_logic;
			rst: in std_logic;
			state: out t_Bus_States;
			IR_Load: out std_logic;
			IR: in std_logic_vector(7 downto 0);
			MAR_Load: out std_logic;
			MAR_Byte: out std_logic;
			PC_Load: out std_logic;
			PC_Inc: out std_logic;
			PC_Byte: out std_logic;
			ADL_Load: out std_logic;
			ADH_Load: out std_logic;
			A_Load: out std_logic;
			B_Load: out std_logic;
			X_Load: out std_logic;
			Y_Load: out std_logic;
			ALU_Sel: out std_logic_vector(2 downto 0);
			Status_Result: in std_logic_vector(7 downto 0);
			Status_Load: out std_logic;
			Bus1_Sel: out std_logic_vector(2 downto 0);
			Bus2_Sel: out std_logic_vector(1 downto 0)
		);
	end component;

	-------------------------------
	-- Signals
	-------------------------------
	signal clk: std_logic := '0';
	signal rst: std_logic := '0';
	signal state: t_Bus_States;
	signal IR_Load: std_logic;
	signal IR: std_logic_vector(7 downto 0) := x"00";
	signal MAR_Load: std_logic;
	signal MAR_Byte: std_logic;
	signal PC_Load: std_logic;
	signal PC_Inc: std_logic;
	signal PC_Byte: std_logic;
	signal ADL_Load: std_logic;
	signal ADH_Load: std_logic;
	signal A_Load: std_logic;
	signal B_Load: std_logic;
	signal X_Load: std_logic;
	signal Y_Load: std_logic;
	signal ALU_Sel: std_logic_vector(2 downto 0);
	signal Status_Result: std_logic_vector(7 downto 0) := x"00";
	signal Status_Load: std_logic;
	signal Bus1_Sel: std_logic_vector(2 downto 0);
	signal Bus2_Sel: std_logic_vector(1 downto 0);

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	UUT: control_unit
		port map (
			clk => clk,
			rst => rst,
			state => state,
			IR_Load => IR_Load,
			IR => IR,
			MAR_Load => MAR_Load,
			MAR_Byte => MAR_Byte,
			PC_Load => PC_Load,
			PC_Inc => PC_Inc,
			PC_Byte => PC_Byte,
			ADL_Load => ADL_Load,
			ADH_Load => ADH_Load,
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

	CONTROL_UNIT_TEST: process
		alias UUT_current_state is <<signal UUT.current_state: t_Control_States>>;
		alias UUT_next_state is <<signal UUT.next_state: t_Control_States>>;
	begin
		-- Test Reset State
		report "Control Unit Module: Reset Test: Begin" severity note;
			wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
			assert_equals(UUT_current_state, S_FETCH_0, "Control Unit Module", "Reset Test", "UUT_current_state");
			rst <= '1';  -- Take out of reset mode
			wait for CLK_PERIOD / 2;
		report "Control Unit Module: Reset Test: End" severity note;

		-- Opcode Fetch Test
		report "Control Unit Module: S_FETCH_0 Test: Begin" severity note;
			IR <= x"00";
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_FETCH_1, "Control Unit Module", "S_FETCH_0 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_FETCH_0 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_FETCH_0 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_FETCH_0 Test: End" severity note;

		report "Control Unit Module: S_FETCH_1 Test: Begin" severity note;
			IR <= x"00";
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_FETCH_2, "Control Unit Module", "S_FETCH_1 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_FETCH_1 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_FETCH_1 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_FETCH_1 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_FETCH_1 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_FETCH_1 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_FETCH_1 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_FETCH_1 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_FETCH_1 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_FETCH_1 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_FETCH_1 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_FETCH_1 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_FETCH_1 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_FETCH_1 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_FETCH_1 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_FETCH_1 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_FETCH_1 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_FETCH_1 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_FETCH_1 Test: End" severity note;

		report "Control Unit Module: S_FETCH_2 Test: Begin" severity note;
			IR <= x"00";
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_FETCH_3, "Control Unit Module", "S_FETCH_2 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_FETCH_2 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_FETCH_2 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_FETCH_2 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_FETCH_2 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_FETCH_2 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_FETCH_2 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_FETCH_2 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_FETCH_2 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_FETCH_2 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_FETCH_2 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_FETCH_2 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_FETCH_2 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_FETCH_2 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_FETCH_2 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_FETCH_2 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_FETCH_2 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_FETCH_2 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_FETCH_2 Test: End" severity note;

		report "Control Unit Module: S_FETCH_3 Test: Begin" severity note;
			IR <= x"00";
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_DECODE_4, "Control Unit Module", "S_FETCH_3 Test", "UUT_next_state");
			assert_equals(IR_Load, '1', "Control Unit Module", "S_FETCH_3 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_FETCH_3 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_FETCH_3 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_FETCH_3 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_FETCH_3 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_FETCH_3 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_FETCH_3 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_FETCH_3 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_FETCH_3 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_FETCH_3 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_FETCH_3 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_FETCH_3 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_FETCH_3 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_FETCH_3 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_FETCH_3 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_FETCH_3 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_FETCH_3 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_FETCH_3 Test: End" severity note;

		-- Opcode Decode Test
		report "Control Unit Module: S_DECODE_4 Test: Begin" severity note;
			IR <= x"00";
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_DECODE_4 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_DECODE_4 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_DECODE_4 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_DECODE_4 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_DECODE_4 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_DECODE_4 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_DECODE_4 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_DECODE_4 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_DECODE_4 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_DECODE_4 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_DECODE_4 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_DECODE_4 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_DECODE_4 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_DECODE_4 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_DECODE_4 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_DECODE_4 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_DECODE_4 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_DECODE_4 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_FETCH_4 Test: End" severity note;

		-- Load A (Immediate) Test
		report "Control Unit Module: S_LDA_IMM_5 Test: Begin" severity note;
			IR <= LDA_IMM;
			Status_Result <= x"00";
			wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
			assert_equals(UUT_next_state, S_LDA_IMM_6, "Control Unit Module", "S_LDA_IMM_5 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_IMM_5 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDA_IMM_5 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDA_IMM_5 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_IMM_5 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_IMM_5 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_IMM_5 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_IMM_5 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_IMM_5 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_IMM_5 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_IMM_5 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_IMM_5 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_IMM_5 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_IMM_5 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_IMM_5 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDA_IMM_5 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDA_IMM_5 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDA_IMM_5 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_IMM_5 Test: End" severity note;

		report "Control Unit Module: S_LDA_IMM_6 Test: Begin" severity note;
			IR <= LDA_IMM;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDA_IMM_7, "Control Unit Module", "S_LDA_IMM_6 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_IMM_6 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDA_IMM_6 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_LDA_IMM_6 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_IMM_6 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_IMM_6 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_IMM_6 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_IMM_6 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_IMM_6 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_IMM_6 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_IMM_6 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_IMM_6 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_IMM_6 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_IMM_6 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_IMM_6 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_LDA_IMM_6 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDA_IMM_6 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDA_IMM_6 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_IMM_6 Test: End" severity note;

		report "Control Unit Module: S_LDA_IMM_7 Test: Begin" severity note;
			IR <= LDA_IMM;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDA_IMM_8, "Control Unit Module", "S_LDA_IMM_7 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_IMM_7 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDA_IMM_7 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDA_IMM_7 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_IMM_7 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_LDA_IMM_7 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_IMM_7 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_IMM_7 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_IMM_7 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_IMM_7 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_IMM_7 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_IMM_7 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_IMM_7 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_IMM_7 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_IMM_7 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDA_IMM_7 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_LDA_IMM_7 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDA_IMM_7 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_IMM_7 Test: End" severity note;

		report "Control Unit Module: S_LDA_IMM_8 Test: Begin" severity note;
			IR <= LDA_IMM;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_LDA_IMM_8 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_IMM_8 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDA_IMM_8 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDA_IMM_8 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_IMM_8 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_IMM_8 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_IMM_8 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_IMM_8 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_IMM_8 Test", "ADH_Load");
			assert_equals(A_Load, '1', "Control Unit Module", "S_LDA_IMM_8 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_IMM_8 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_IMM_8 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_IMM_8 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_IMM_8 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_IMM_8 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDA_IMM_8 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_LDA_IMM_8 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_LDA_IMM_8 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_IMM_8 Test: End" severity note;

		-- Load A (Direct) Test
		report "Control Unit Module: S_LDA_DIR_5 Test: Begin" severity note;
			IR <= LDA_DIR;
			Status_Result <= x"00";
			wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
			assert_equals(UUT_next_state, S_LDA_DIR_6, "Control Unit Module", "S_LDA_DIR_5 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_DIR_5 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDA_DIR_5 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDA_DIR_5 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_DIR_5 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_DIR_5 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_DIR_5 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_DIR_5 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_DIR_5 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_DIR_5 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_DIR_5 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_DIR_5 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_DIR_5 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_DIR_5 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_DIR_5 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDA_DIR_5 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDA_DIR_5 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDA_DIR_5 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_DIR_5 Test: End" severity note;

		report "Control Unit Module: S_LDA_DIR_6 Test: Begin" severity note;
			IR <= LDA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDA_DIR_7, "Control Unit Module", "S_LDA_DIR_6 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_DIR_6 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDA_DIR_6 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_LDA_DIR_6 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_DIR_6 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_DIR_6 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_DIR_6 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_DIR_6 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_DIR_6 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_DIR_6 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_DIR_6 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_DIR_6 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_DIR_6 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_DIR_6 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_DIR_6 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_LDA_DIR_6 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDA_DIR_6 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDA_DIR_6 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_DIR_6 Test: End" severity note;

		report "Control Unit Module: S_LDA_DIR_7 Test: Begin" severity note;
			IR <= LDA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDA_DIR_8, "Control Unit Module", "S_LDA_DIR_7 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_DIR_7 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDA_DIR_7 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDA_DIR_7 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_DIR_7 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_LDA_DIR_7 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_DIR_7 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_DIR_7 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_DIR_7 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_DIR_7 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_DIR_7 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_DIR_7 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_DIR_7 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_DIR_7 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_DIR_7 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDA_DIR_7 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_LDA_DIR_7 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDA_DIR_7 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_DIR_7 Test: End" severity note;

		report "Control Unit Module: S_LDA_DIR_8 Test: Begin" severity note;
			IR <= LDA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDA_DIR_9, "Control Unit Module", "S_LDA_DIR_8 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_DIR_8 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDA_DIR_8 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDA_DIR_8 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_DIR_8 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_DIR_8 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_DIR_8 Test", "PC_Byte");
			assert_equals(ADL_Load, '1', "Control Unit Module", "S_LDA_DIR_8 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_DIR_8 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_DIR_8 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_DIR_8 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_DIR_8 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_DIR_8 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_DIR_8 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_DIR_8 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDA_DIR_8 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_LDA_DIR_8 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_LDA_DIR_8 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_DIR_8 Test: End" severity note;

		report "Control Unit Module: S_LDA_DIR_9 Test: Begin" severity note;
			IR <= LDA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDA_DIR_10, "Control Unit Module", "S_LDA_DIR_9 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_DIR_9 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDA_DIR_9 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDA_DIR_9 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_DIR_9 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_DIR_9 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_DIR_9 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_DIR_9 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_DIR_9 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_DIR_9 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_DIR_9 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_DIR_9 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_DIR_9 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_DIR_9 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_DIR_9 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDA_DIR_9 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDA_DIR_9 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDA_DIR_9 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_DIR_9 Test: End" severity note;

		report "Control Unit Module: S_LDA_DIR_10 Test: Begin" severity note;
			IR <= LDA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDA_DIR_11, "Control Unit Module", "S_LDA_DIR_10 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_DIR_10 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDA_DIR_10 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_LDA_DIR_10 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_DIR_10 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_DIR_10 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_DIR_10 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_DIR_10 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_DIR_10 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_DIR_10 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_DIR_10 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_DIR_10 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_DIR_10 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_DIR_10 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_DIR_10 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_LDA_DIR_10 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDA_DIR_10 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDA_DIR_10 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_DIR_10 Test: End" severity note;

		report "Control Unit Module: S_LDA_DIR_11 Test: Begin" severity note;
			IR <= LDA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDA_DIR_12, "Control Unit Module", "S_LDA_DIR_11 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_DIR_11 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDA_DIR_11 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDA_DIR_11 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_DIR_11 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_LDA_DIR_11 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_DIR_11 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_DIR_11 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_DIR_11 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_DIR_11 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_DIR_11 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_DIR_11 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_DIR_11 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_DIR_11 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_DIR_11 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDA_DIR_11 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_LDA_DIR_11 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDA_DIR_11 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_DIR_11 Test: End" severity note;

		report "Control Unit Module: S_LDA_DIR_12 Test: Begin" severity note;
			IR <= LDA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDA_DIR_13, "Control Unit Module", "S_LDA_DIR_12 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_DIR_12 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDA_DIR_12 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDA_DIR_12 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_DIR_12 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_DIR_12 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_DIR_12 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_DIR_12 Test", "ADL_Load");
			assert_equals(ADH_Load, '1', "Control Unit Module", "S_LDA_DIR_12 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_DIR_12 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_DIR_12 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_DIR_12 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_DIR_12 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_DIR_12 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_DIR_12 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDA_DIR_12 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_LDA_DIR_12 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_LDA_DIR_12 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_DIR_12 Test: End" severity note;

		report "Control Unit Module: S_LDA_DIR_13 Test: Begin" severity note;
			IR <= LDA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDA_DIR_14, "Control Unit Module", "S_LDA_DIR_13 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_DIR_13 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDA_DIR_13 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDA_DIR_13 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_DIR_13 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_DIR_13 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_DIR_13 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_DIR_13 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_DIR_13 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_DIR_13 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_DIR_13 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_DIR_13 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_DIR_13 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_DIR_13 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_DIR_13 Test", "Status_Load");
			assert_equals(Bus1_Sel, "100", "Control Unit Module", "S_LDA_DIR_13 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDA_DIR_13 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDA_DIR_13 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_DIR_13 Test: End" severity note;

		report "Control Unit Module: S_LDA_DIR_14 Test: Begin" severity note;
			IR <= LDA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDA_DIR_15, "Control Unit Module", "S_LDA_DIR_14 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_DIR_14 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDA_DIR_14 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_LDA_DIR_14 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_DIR_14 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_DIR_14 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_DIR_14 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_DIR_14 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_DIR_14 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_DIR_14 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_DIR_14 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_DIR_14 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_DIR_14 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_DIR_14 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_DIR_14 Test", "Status_Load");
			assert_equals(Bus1_Sel, "101", "Control Unit Module", "S_LDA_DIR_14 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDA_DIR_14 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDA_DIR_14 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_DIR_14 Test: End" severity note;

		report "Control Unit Module: S_LDA_DIR_15 Test: Begin" severity note;
			IR <= LDA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDA_DIR_16, "Control Unit Module", "S_LDA_DIR_15 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_DIR_15 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_DIR_15 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDA_DIR_15 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_LDA_DIR_15 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDA_DIR_15 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_DIR_15 Test: End" severity note;

		report "Control Unit Module: S_LDA_DIR_16 Test: Begin" severity note;
			IR <= LDA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_LDA_DIR_16 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDA_DIR_16 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDA_DIR_16 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDA_DIR_16 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDA_DIR_16 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDA_DIR_16 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDA_DIR_16 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDA_DIR_16 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDA_DIR_16 Test", "ADH_Load");
			assert_equals(A_Load, '1', "Control Unit Module", "S_LDA_DIR_16 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDA_DIR_16 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDA_DIR_16 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDA_DIR_16 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDA_DIR_16 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDA_DIR_16 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDA_DIR_16 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_LDA_DIR_16 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_LDA_DIR_16 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDA_DIR_16 Test: End" severity note;

		-- Store A (Direct) Test
		report "Control Unit Module: S_STA_DIR_5 Test: Begin" severity note;
			IR <= STA_DIR;
			Status_Result <= x"00";
			wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
			assert_equals(UUT_next_state, S_STA_DIR_6, "Control Unit Module", "S_STA_DIR_5 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STA_DIR_5 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_STA_DIR_5 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STA_DIR_5 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STA_DIR_5 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STA_DIR_5 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STA_DIR_5 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STA_DIR_5 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STA_DIR_5 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STA_DIR_5 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STA_DIR_5 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STA_DIR_5 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STA_DIR_5 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STA_DIR_5 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STA_DIR_5 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_STA_DIR_5 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STA_DIR_5 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STA_DIR_5 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STA_DIR_5 Test: End" severity note;

		report "Control Unit Module: S_STA_DIR_6 Test: Begin" severity note;
			IR <= STA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STA_DIR_7, "Control Unit Module", "S_STA_DIR_6 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STA_DIR_6 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_STA_DIR_6 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_STA_DIR_6 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STA_DIR_6 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STA_DIR_6 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STA_DIR_6 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STA_DIR_6 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STA_DIR_6 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STA_DIR_6 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STA_DIR_6 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STA_DIR_6 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STA_DIR_6 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STA_DIR_6 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STA_DIR_6 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_STA_DIR_6 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STA_DIR_6 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STA_DIR_6 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STA_DIR_6 Test: End" severity note;

		report "Control Unit Module: S_STA_DIR_7 Test: Begin" severity note;
			IR <= STA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STA_DIR_8, "Control Unit Module", "S_STA_DIR_7 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STA_DIR_7 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_STA_DIR_7 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STA_DIR_7 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STA_DIR_7 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_STA_DIR_7 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STA_DIR_7 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STA_DIR_7 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STA_DIR_7 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STA_DIR_7 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STA_DIR_7 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STA_DIR_7 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STA_DIR_7 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STA_DIR_7 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STA_DIR_7 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_STA_DIR_7 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_STA_DIR_7 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STA_DIR_7 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STA_DIR_7 Test: End" severity note;

		report "Control Unit Module: S_STA_DIR_8 Test: Begin" severity note;
			IR <= STA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STA_DIR_9, "Control Unit Module", "S_STA_DIR_8 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STA_DIR_8 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_STA_DIR_8 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STA_DIR_8 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STA_DIR_8 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STA_DIR_8 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STA_DIR_8 Test", "PC_Byte");
			assert_equals(ADL_Load, '1', "Control Unit Module", "S_STA_DIR_8 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STA_DIR_8 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STA_DIR_8 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STA_DIR_8 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STA_DIR_8 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STA_DIR_8 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STA_DIR_8 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STA_DIR_8 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_STA_DIR_8 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_STA_DIR_8 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_STA_DIR_8 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STA_DIR_8 Test: End" severity note;

		report "Control Unit Module: S_STA_DIR_9 Test: Begin" severity note;
			IR <= STA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STA_DIR_10, "Control Unit Module", "S_STA_DIR_9 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STA_DIR_9 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_STA_DIR_9 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STA_DIR_9 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STA_DIR_9 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STA_DIR_9 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STA_DIR_9 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STA_DIR_9 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STA_DIR_9 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STA_DIR_9 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STA_DIR_9 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STA_DIR_9 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STA_DIR_9 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STA_DIR_9 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STA_DIR_9 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_STA_DIR_9 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STA_DIR_9 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STA_DIR_9 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STA_DIR_9 Test: End" severity note;

		report "Control Unit Module: S_STA_DIR_10 Test: Begin" severity note;
			IR <= STA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STA_DIR_11, "Control Unit Module", "S_STA_DIR_10 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STA_DIR_10 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_STA_DIR_10 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_STA_DIR_10 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STA_DIR_10 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STA_DIR_10 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STA_DIR_10 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STA_DIR_10 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STA_DIR_10 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STA_DIR_10 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STA_DIR_10 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STA_DIR_10 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STA_DIR_10 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STA_DIR_10 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STA_DIR_10 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_STA_DIR_10 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STA_DIR_10 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STA_DIR_10 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STA_DIR_10 Test: End" severity note;

		report "Control Unit Module: S_STA_DIR_11 Test: Begin" severity note;
			IR <= STA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STA_DIR_12, "Control Unit Module", "S_STA_DIR_11 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STA_DIR_11 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_STA_DIR_11 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STA_DIR_11 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STA_DIR_11 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_STA_DIR_11 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STA_DIR_11 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STA_DIR_11 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STA_DIR_11 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STA_DIR_11 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STA_DIR_11 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STA_DIR_11 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STA_DIR_11 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STA_DIR_11 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STA_DIR_11 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_STA_DIR_11 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_STA_DIR_11 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STA_DIR_11 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STA_DIR_11 Test: End" severity note;

		report "Control Unit Module: S_STA_DIR_12 Test: Begin" severity note;
			IR <= STA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STA_DIR_13, "Control Unit Module", "S_STA_DIR_12 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STA_DIR_12 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_STA_DIR_12 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STA_DIR_12 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STA_DIR_12 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STA_DIR_12 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STA_DIR_12 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STA_DIR_12 Test", "ADL_Load");
			assert_equals(ADH_Load, '1', "Control Unit Module", "S_STA_DIR_12 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STA_DIR_12 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STA_DIR_12 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STA_DIR_12 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STA_DIR_12 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STA_DIR_12 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STA_DIR_12 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_STA_DIR_12 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_STA_DIR_12 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_STA_DIR_12 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STA_DIR_12 Test: End" severity note;

		report "Control Unit Module: S_STA_DIR_13 Test: Begin" severity note;
			IR <= STA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STA_DIR_14, "Control Unit Module", "S_STA_DIR_13 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STA_DIR_13 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_STA_DIR_13 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STA_DIR_13 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STA_DIR_13 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STA_DIR_13 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STA_DIR_13 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STA_DIR_13 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STA_DIR_13 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STA_DIR_13 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STA_DIR_13 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STA_DIR_13 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STA_DIR_13 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STA_DIR_13 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STA_DIR_13 Test", "Status_Load");
			assert_equals(Bus1_Sel, "100", "Control Unit Module", "S_STA_DIR_13 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STA_DIR_13 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STA_DIR_13 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STA_DIR_13 Test: End" severity note;

		report "Control Unit Module: S_STA_DIR_14 Test: Begin" severity note;
			IR <= STA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STA_DIR_15, "Control Unit Module", "S_STA_DIR_14 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STA_DIR_14 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_STA_DIR_14 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_STA_DIR_14 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STA_DIR_14 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STA_DIR_14 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STA_DIR_14 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STA_DIR_14 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STA_DIR_14 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STA_DIR_14 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STA_DIR_14 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STA_DIR_14 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STA_DIR_14 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STA_DIR_14 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STA_DIR_14 Test", "Status_Load");
			assert_equals(Bus1_Sel, "101", "Control Unit Module", "S_STA_DIR_14 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STA_DIR_14 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STA_DIR_14 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STA_DIR_14 Test: End" severity note;

		report "Control Unit Module: S_STA_DIR_15 Test: Begin" severity note;
			IR <= STA_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_STA_DIR_15 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STA_DIR_15 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_STA_DIR_15 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STA_DIR_15 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STA_DIR_15 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STA_DIR_15 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STA_DIR_15 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STA_DIR_15 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STA_DIR_15 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STA_DIR_15 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STA_DIR_15 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STA_DIR_15 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STA_DIR_15 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STA_DIR_15 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STA_DIR_15 Test", "Status_Load");
			assert_equals(Bus1_Sel, "010", "Control Unit Module", "S_STA_DIR_15 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STA_DIR_15 Test", "Bus2_Sel");
			assert_equals(state, WRITE, "Control Unit Module", "S_STA_DIR_15 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STA_DIR_15 Test: End" severity note;

		-- Load B (Immediate) Test
		report "Control Unit Module: S_LDB_IMM_5 Test: Begin" severity note;
			IR <= LDB_IMM;
			Status_Result <= x"00";
			wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
			assert_equals(UUT_next_state, S_LDB_IMM_6, "Control Unit Module", "S_LDB_IMM_5 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_IMM_5 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDB_IMM_5 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDB_IMM_5 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_IMM_5 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_IMM_5 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_IMM_5 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_IMM_5 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_IMM_5 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_IMM_5 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_IMM_5 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_IMM_5 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_IMM_5 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_IMM_5 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_IMM_5 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDB_IMM_5 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDB_IMM_5 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDB_IMM_5 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_IMM_5 Test: End" severity note;

		report "Control Unit Module: S_LDB_IMM_6 Test: Begin" severity note;
			IR <= LDB_IMM;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDB_IMM_7, "Control Unit Module", "S_LDB_IMM_6 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_IMM_6 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDB_IMM_6 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_LDB_IMM_6 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_IMM_6 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_IMM_6 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_IMM_6 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_IMM_6 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_IMM_6 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_IMM_6 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_IMM_6 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_IMM_6 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_IMM_6 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_IMM_6 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_IMM_6 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_LDB_IMM_6 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDB_IMM_6 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDB_IMM_6 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_IMM_6 Test: End" severity note;

		report "Control Unit Module: S_LDB_IMM_7 Test: Begin" severity note;
			IR <= LDB_IMM;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDB_IMM_8, "Control Unit Module", "S_LDB_IMM_7 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_IMM_7 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDB_IMM_7 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDB_IMM_7 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_IMM_7 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_LDB_IMM_7 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_IMM_7 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_IMM_7 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_IMM_7 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_IMM_7 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_IMM_7 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_IMM_7 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_IMM_7 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_IMM_7 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_IMM_7 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDB_IMM_7 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_LDB_IMM_7 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDB_IMM_7 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_IMM_7 Test: End" severity note;

		report "Control Unit Module: S_LDB_IMM_8 Test: Begin" severity note;
			IR <= LDB_IMM;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_LDB_IMM_8 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_IMM_8 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDB_IMM_8 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDB_IMM_8 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_IMM_8 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_IMM_8 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_IMM_8 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_IMM_8 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_IMM_8 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_IMM_8 Test", "A_Load");
			assert_equals(B_Load, '1', "Control Unit Module", "S_LDB_IMM_8 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_IMM_8 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_IMM_8 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_IMM_8 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_IMM_8 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDB_IMM_8 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_LDB_IMM_8 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_LDB_IMM_8 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_IMM_8 Test: End" severity note;

		-- Load B (Direct) Test
		report "Control Unit Module: S_LDB_DIR_5 Test: Begin" severity note;
			IR <= LDB_DIR;
			Status_Result <= x"00";
			wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
			assert_equals(UUT_next_state, S_LDB_DIR_6, "Control Unit Module", "S_LDB_DIR_5 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_DIR_5 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDB_DIR_5 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDB_DIR_5 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_DIR_5 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_DIR_5 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_DIR_5 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_DIR_5 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_DIR_5 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_DIR_5 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_DIR_5 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_DIR_5 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_DIR_5 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_DIR_5 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_DIR_5 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDB_DIR_5 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDB_DIR_5 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDB_DIR_5 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_DIR_5 Test: End" severity note;

		report "Control Unit Module: S_LDB_DIR_6 Test: Begin" severity note;
			IR <= LDB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDB_DIR_7, "Control Unit Module", "S_LDB_DIR_6 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_DIR_6 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDB_DIR_6 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_LDB_DIR_6 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_DIR_6 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_DIR_6 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_DIR_6 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_DIR_6 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_DIR_6 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_DIR_6 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_DIR_6 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_DIR_6 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_DIR_6 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_DIR_6 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_DIR_6 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_LDB_DIR_6 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDB_DIR_6 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDB_DIR_6 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_DIR_6 Test: End" severity note;

		report "Control Unit Module: S_LDB_DIR_7 Test: Begin" severity note;
			IR <= LDB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDB_DIR_8, "Control Unit Module", "S_LDB_DIR_7 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_DIR_7 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDB_DIR_7 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDB_DIR_7 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_DIR_7 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_LDB_DIR_7 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_DIR_7 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_DIR_7 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_DIR_7 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_DIR_7 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_DIR_7 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_DIR_7 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_DIR_7 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_DIR_7 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_DIR_7 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDB_DIR_7 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_LDB_DIR_7 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDB_DIR_7 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_DIR_7 Test: End" severity note;

		report "Control Unit Module: S_LDB_DIR_8 Test: Begin" severity note;
			IR <= LDB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDB_DIR_9, "Control Unit Module", "S_LDB_DIR_8 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_DIR_8 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDB_DIR_8 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDB_DIR_8 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_DIR_8 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_DIR_8 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_DIR_8 Test", "PC_Byte");
			assert_equals(ADL_Load, '1', "Control Unit Module", "S_LDB_DIR_8 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_DIR_8 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_DIR_8 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_DIR_8 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_DIR_8 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_DIR_8 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_DIR_8 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_DIR_8 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDB_DIR_8 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_LDB_DIR_8 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_LDB_DIR_8 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_DIR_8 Test: End" severity note;

		report "Control Unit Module: S_LDB_DIR_9 Test: Begin" severity note;
			IR <= LDB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDB_DIR_10, "Control Unit Module", "S_LDB_DIR_9 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_DIR_9 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDB_DIR_9 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDB_DIR_9 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_DIR_9 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_DIR_9 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_DIR_9 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_DIR_9 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_DIR_9 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_DIR_9 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_DIR_9 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_DIR_9 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_DIR_9 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_DIR_9 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_DIR_9 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDB_DIR_9 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDB_DIR_9 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDB_DIR_9 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_DIR_9 Test: End" severity note;

		report "Control Unit Module: S_LDB_DIR_10 Test: Begin" severity note;
			IR <= LDB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDB_DIR_11, "Control Unit Module", "S_LDB_DIR_10 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_DIR_10 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDB_DIR_10 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_LDB_DIR_10 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_DIR_10 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_DIR_10 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_DIR_10 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_DIR_10 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_DIR_10 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_DIR_10 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_DIR_10 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_DIR_10 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_DIR_10 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_DIR_10 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_DIR_10 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_LDB_DIR_10 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDB_DIR_10 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDB_DIR_10 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_DIR_10 Test: End" severity note;

		report "Control Unit Module: S_LDB_DIR_11 Test: Begin" severity note;
			IR <= LDB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDB_DIR_12, "Control Unit Module", "S_LDB_DIR_11 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_DIR_11 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDB_DIR_11 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDB_DIR_11 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_DIR_11 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_LDB_DIR_11 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_DIR_11 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_DIR_11 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_DIR_11 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_DIR_11 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_DIR_11 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_DIR_11 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_DIR_11 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_DIR_11 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_DIR_11 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDB_DIR_11 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_LDB_DIR_11 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDB_DIR_11 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_DIR_11 Test: End" severity note;

		report "Control Unit Module: S_LDB_DIR_12 Test: Begin" severity note;
			IR <= LDB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDB_DIR_13, "Control Unit Module", "S_LDB_DIR_12 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_DIR_12 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDB_DIR_12 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDB_DIR_12 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_DIR_12 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_DIR_12 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_DIR_12 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_DIR_12 Test", "ADL_Load");
			assert_equals(ADH_Load, '1', "Control Unit Module", "S_LDB_DIR_12 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_DIR_12 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_DIR_12 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_DIR_12 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_DIR_12 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_DIR_12 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_DIR_12 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDB_DIR_12 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_LDB_DIR_12 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_LDB_DIR_12 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_DIR_12 Test: End" severity note;

		report "Control Unit Module: S_LDB_DIR_13 Test: Begin" severity note;
			IR <= LDB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDB_DIR_14, "Control Unit Module", "S_LDB_DIR_13 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_DIR_13 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDB_DIR_13 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDB_DIR_13 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_DIR_13 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_DIR_13 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_DIR_13 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_DIR_13 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_DIR_13 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_DIR_13 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_DIR_13 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_DIR_13 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_DIR_13 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_DIR_13 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_DIR_13 Test", "Status_Load");
			assert_equals(Bus1_Sel, "100", "Control Unit Module", "S_LDB_DIR_13 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDB_DIR_13 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDB_DIR_13 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_DIR_13 Test: End" severity note;

		report "Control Unit Module: S_LDB_DIR_14 Test: Begin" severity note;
			IR <= LDB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDB_DIR_15, "Control Unit Module", "S_LDB_DIR_14 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_DIR_14 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_LDB_DIR_14 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_LDB_DIR_14 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_DIR_14 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_DIR_14 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_DIR_14 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_DIR_14 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_DIR_14 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_DIR_14 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_DIR_14 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_DIR_14 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_DIR_14 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_DIR_14 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_DIR_14 Test", "Status_Load");
			assert_equals(Bus1_Sel, "101", "Control Unit Module", "S_LDB_DIR_14 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_LDB_DIR_14 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDB_DIR_14 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_DIR_14 Test: End" severity note;

		report "Control Unit Module: S_LDB_DIR_15 Test: Begin" severity note;
			IR <= LDB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_LDB_DIR_16, "Control Unit Module", "S_LDB_DIR_15 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_DIR_15 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_DIR_15 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDB_DIR_15 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_LDB_DIR_15 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_LDB_DIR_15 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_DIR_15 Test: End" severity note;

		report "Control Unit Module: S_LDB_DIR_16 Test: Begin" severity note;
			IR <= LDB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_LDB_DIR_16 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_LDB_DIR_16 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_LDB_DIR_16 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_LDB_DIR_16 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_LDB_DIR_16 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_LDB_DIR_16 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_LDB_DIR_16 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_LDB_DIR_16 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_LDB_DIR_16 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_LDB_DIR_16 Test", "A_Load");
			assert_equals(B_Load, '1', "Control Unit Module", "S_LDB_DIR_16 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_LDB_DIR_16 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_LDB_DIR_16 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_LDB_DIR_16 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_LDB_DIR_16 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_LDB_DIR_16 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_LDB_DIR_16 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_LDB_DIR_16 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_LDB_DIR_16 Test: End" severity note;

		-- Store B (Direct) Test
		report "Control Unit Module: S_STB_DIR_5 Test: Begin" severity note;
			IR <= STB_DIR;
			Status_Result <= x"00";
			wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
			assert_equals(UUT_next_state, S_STB_DIR_6, "Control Unit Module", "S_STB_DIR_5 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STB_DIR_5 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_STB_DIR_5 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STB_DIR_5 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STB_DIR_5 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STB_DIR_5 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STB_DIR_5 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STB_DIR_5 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STB_DIR_5 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STB_DIR_5 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STB_DIR_5 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STB_DIR_5 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STB_DIR_5 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STB_DIR_5 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STB_DIR_5 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_STB_DIR_5 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STB_DIR_5 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STB_DIR_5 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STB_DIR_5 Test: End" severity note;

		report "Control Unit Module: S_STB_DIR_6 Test: Begin" severity note;
			IR <= STB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STB_DIR_7, "Control Unit Module", "S_STB_DIR_6 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STB_DIR_6 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_STB_DIR_6 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_STB_DIR_6 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STB_DIR_6 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STB_DIR_6 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STB_DIR_6 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STB_DIR_6 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STB_DIR_6 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STB_DIR_6 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STB_DIR_6 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STB_DIR_6 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STB_DIR_6 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STB_DIR_6 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STB_DIR_6 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_STB_DIR_6 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STB_DIR_6 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STB_DIR_6 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STB_DIR_6 Test: End" severity note;

		report "Control Unit Module: S_STB_DIR_7 Test: Begin" severity note;
			IR <= STB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STB_DIR_8, "Control Unit Module", "S_STB_DIR_7 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STB_DIR_7 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_STB_DIR_7 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STB_DIR_7 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STB_DIR_7 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_STB_DIR_7 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STB_DIR_7 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STB_DIR_7 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STB_DIR_7 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STB_DIR_7 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STB_DIR_7 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STB_DIR_7 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STB_DIR_7 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STB_DIR_7 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STB_DIR_7 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_STB_DIR_7 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_STB_DIR_7 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STB_DIR_7 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STB_DIR_7 Test: End" severity note;

		report "Control Unit Module: S_STB_DIR_8 Test: Begin" severity note;
			IR <= STB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STB_DIR_9, "Control Unit Module", "S_STB_DIR_8 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STB_DIR_8 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_STB_DIR_8 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STB_DIR_8 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STB_DIR_8 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STB_DIR_8 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STB_DIR_8 Test", "PC_Byte");
			assert_equals(ADL_Load, '1', "Control Unit Module", "S_STB_DIR_8 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STB_DIR_8 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STB_DIR_8 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STB_DIR_8 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STB_DIR_8 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STB_DIR_8 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STB_DIR_8 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STB_DIR_8 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_STB_DIR_8 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_STB_DIR_8 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_STB_DIR_8 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STB_DIR_8 Test: End" severity note;

		report "Control Unit Module: S_STB_DIR_9 Test: Begin" severity note;
			IR <= STB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STB_DIR_10, "Control Unit Module", "S_STB_DIR_9 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STB_DIR_9 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_STB_DIR_9 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STB_DIR_9 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STB_DIR_9 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STB_DIR_9 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STB_DIR_9 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STB_DIR_9 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STB_DIR_9 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STB_DIR_9 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STB_DIR_9 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STB_DIR_9 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STB_DIR_9 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STB_DIR_9 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STB_DIR_9 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_STB_DIR_9 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STB_DIR_9 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STB_DIR_9 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STB_DIR_9 Test: End" severity note;

		report "Control Unit Module: S_STB_DIR_10 Test: Begin" severity note;
			IR <= STB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STB_DIR_11, "Control Unit Module", "S_STB_DIR_10 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STB_DIR_10 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_STB_DIR_10 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_STB_DIR_10 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STB_DIR_10 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STB_DIR_10 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STB_DIR_10 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STB_DIR_10 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STB_DIR_10 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STB_DIR_10 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STB_DIR_10 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STB_DIR_10 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STB_DIR_10 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STB_DIR_10 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STB_DIR_10 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_STB_DIR_10 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STB_DIR_10 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STB_DIR_10 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STB_DIR_10 Test: End" severity note;

		report "Control Unit Module: S_STB_DIR_11 Test: Begin" severity note;
			IR <= STB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STB_DIR_12, "Control Unit Module", "S_STB_DIR_11 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STB_DIR_11 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_STB_DIR_11 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STB_DIR_11 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STB_DIR_11 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_STB_DIR_11 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STB_DIR_11 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STB_DIR_11 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STB_DIR_11 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STB_DIR_11 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STB_DIR_11 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STB_DIR_11 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STB_DIR_11 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STB_DIR_11 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STB_DIR_11 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_STB_DIR_11 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_STB_DIR_11 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STB_DIR_11 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STB_DIR_11 Test: End" severity note;

		report "Control Unit Module: S_STB_DIR_12 Test: Begin" severity note;
			IR <= STB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STB_DIR_13, "Control Unit Module", "S_STB_DIR_12 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STB_DIR_12 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_STB_DIR_12 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STB_DIR_12 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STB_DIR_12 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STB_DIR_12 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STB_DIR_12 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STB_DIR_12 Test", "ADL_Load");
			assert_equals(ADH_Load, '1', "Control Unit Module", "S_STB_DIR_12 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STB_DIR_12 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STB_DIR_12 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STB_DIR_12 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STB_DIR_12 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STB_DIR_12 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STB_DIR_12 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_STB_DIR_12 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_STB_DIR_12 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_STB_DIR_12 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STB_DIR_12 Test: End" severity note;

		report "Control Unit Module: S_STB_DIR_13 Test: Begin" severity note;
			IR <= STB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STB_DIR_14, "Control Unit Module", "S_STB_DIR_13 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STB_DIR_13 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_STB_DIR_13 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STB_DIR_13 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STB_DIR_13 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STB_DIR_13 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STB_DIR_13 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STB_DIR_13 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STB_DIR_13 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STB_DIR_13 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STB_DIR_13 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STB_DIR_13 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STB_DIR_13 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STB_DIR_13 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STB_DIR_13 Test", "Status_Load");
			assert_equals(Bus1_Sel, "100", "Control Unit Module", "S_STB_DIR_13 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STB_DIR_13 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STB_DIR_13 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STB_DIR_13 Test: End" severity note;

		report "Control Unit Module: S_STB_DIR_14 Test: Begin" severity note;
			IR <= STB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_STB_DIR_15, "Control Unit Module", "S_STB_DIR_14 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STB_DIR_14 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_STB_DIR_14 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_STB_DIR_14 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STB_DIR_14 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STB_DIR_14 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STB_DIR_14 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STB_DIR_14 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STB_DIR_14 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STB_DIR_14 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STB_DIR_14 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STB_DIR_14 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STB_DIR_14 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STB_DIR_14 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STB_DIR_14 Test", "Status_Load");
			assert_equals(Bus1_Sel, "101", "Control Unit Module", "S_STB_DIR_14 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STB_DIR_14 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_STB_DIR_14 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STB_DIR_14 Test: End" severity note;

		report "Control Unit Module: S_STB_DIR_15 Test: Begin" severity note;
			IR <= STB_DIR;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_STB_DIR_15 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_STB_DIR_15 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_STB_DIR_15 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_STB_DIR_15 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_STB_DIR_15 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_STB_DIR_15 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_STB_DIR_15 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_STB_DIR_15 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_STB_DIR_15 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_STB_DIR_15 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_STB_DIR_15 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_STB_DIR_15 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_STB_DIR_15 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_STB_DIR_15 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_STB_DIR_15 Test", "Status_Load");
			assert_equals(Bus1_Sel, "011", "Control Unit Module", "S_STB_DIR_15 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_STB_DIR_15 Test", "Bus2_Sel");
			assert_equals(state, WRITE, "Control Unit Module", "S_STB_DIR_15 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_STB_DIR_15 Test: End" severity note;

		-- Addition Test
		report "Control Unit Module: S_ADD_AB_DIR_5 Test: Begin" severity note;
			IR <= ADD_AB;
			Status_Result <= x"00";
			wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
			assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_FETCH_0 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADH_Load");
			assert_equals(A_Load, '1', "Control Unit Module", "S_FETCH_0 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "ALU_Sel");
			assert_equals(Status_Load, '1', "Control Unit Module", "S_FETCH_0 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_FETCH_0 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_FETCH_0 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_ADD_AB_DIR_5 Test: End" severity note;

		-- TODO: Implement these instructions
		-- -- Subtraction Test
		-- report "Control Unit Module: S_SUB_AB_5 Test: Begin" severity note;
		-- 	IR <= SUB_AB;
		-- 	Status_Result <= x"00";
		-- 	wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
		-- 	assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_FETCH_0 Test", "UUT_next_state");
		-- 	assert_equals(IR_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	assert_equals(MAR_Load, '1', "Control Unit Module", "S_FETCH_0 Test", "MAR_Load");
		-- 	assert_equals(MAR_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "MAR_Byte");
		-- 	assert_equals(PC_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Load");
		-- 	assert_equals(PC_Inc, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Inc");
		-- 	assert_equals(PC_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Byte");
		-- 	assert_equals(ADL_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADL_Load");
		-- 	assert_equals(ADH_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADH_Load");
		-- 	assert_equals(A_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "A_Load");
		-- 	assert_equals(B_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "B_Load");
		-- 	assert_equals(X_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "X_Load");
		-- 	assert_equals(Y_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Y_Load");
		-- 	assert_equals(ALU_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "ALU_Sel");
		-- 	assert_equals(Status_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Status_Load");
		-- 	assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "Bus1_Sel");
		-- 	assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_FETCH_0 Test", "Bus2_Sel");
		-- 	assert_equals(state, READ, "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		-- report "Control Unit Module: S_SUB_AB_5 Test: End" severity note;

		-- -- AND Test
		-- report "Control Unit Module: S_AND_AB_5 Test: Begin" severity note;
		-- 	IR <= AND_AB;
		-- 	Status_Result <= x"00";
		-- 	wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
		-- 	assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_FETCH_0 Test", "UUT_next_state");
		-- 	assert_equals(IR_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	assert_equals(MAR_Load, '1', "Control Unit Module", "S_FETCH_0 Test", "MAR_Load");
		-- 	assert_equals(MAR_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "MAR_Byte");
		-- 	assert_equals(PC_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Load");
		-- 	assert_equals(PC_Inc, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Inc");
		-- 	assert_equals(PC_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Byte");
		-- 	assert_equals(ADL_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADL_Load");
		-- 	assert_equals(ADH_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADH_Load");
		-- 	assert_equals(A_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "A_Load");
		-- 	assert_equals(B_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "B_Load");
		-- 	assert_equals(X_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "X_Load");
		-- 	assert_equals(Y_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Y_Load");
		-- 	assert_equals(ALU_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "ALU_Sel");
		-- 	assert_equals(Status_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Status_Load");
		-- 	assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "Bus1_Sel");
		-- 	assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_FETCH_0 Test", "Bus2_Sel");
		-- 	assert_equals(state, READ, "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		-- report "Control Unit Module: S_AND_AB_5 Test: End" severity note;

		-- -- OR Test
		-- report "Control Unit Module: S_OR_AB_5 Test: Begin" severity note;
		-- 	IR <= OR_AB;
		-- 	Status_Result <= x"00";
		-- 	wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
		-- 	assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_FETCH_0 Test", "UUT_next_state");
		-- 	assert_equals(IR_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	assert_equals(MAR_Load, '1', "Control Unit Module", "S_FETCH_0 Test", "MAR_Load");
		-- 	assert_equals(MAR_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "MAR_Byte");
		-- 	assert_equals(PC_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Load");
		-- 	assert_equals(PC_Inc, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Inc");
		-- 	assert_equals(PC_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Byte");
		-- 	assert_equals(ADL_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADL_Load");
		-- 	assert_equals(ADH_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADH_Load");
		-- 	assert_equals(A_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "A_Load");
		-- 	assert_equals(B_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "B_Load");
		-- 	assert_equals(X_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "X_Load");
		-- 	assert_equals(Y_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Y_Load");
		-- 	assert_equals(ALU_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "ALU_Sel");
		-- 	assert_equals(Status_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Status_Load");
		-- 	assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "Bus1_Sel");
		-- 	assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_FETCH_0 Test", "Bus2_Sel");
		-- 	assert_equals(state, READ, "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		-- report "Control Unit Module: S_OR_AB_5 Test: End" severity note;

		-- -- Increment A Test
		-- report "Control Unit Module: S_INCA_5 Test: Begin" severity note;
		-- 	IR <= INCA;
		-- 	Status_Result <= x"00";
		-- 	wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
		-- 	assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_FETCH_0 Test", "UUT_next_state");
		-- 	assert_equals(IR_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	assert_equals(MAR_Load, '1', "Control Unit Module", "S_FETCH_0 Test", "MAR_Load");
		-- 	assert_equals(MAR_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "MAR_Byte");
		-- 	assert_equals(PC_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Load");
		-- 	assert_equals(PC_Inc, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Inc");
		-- 	assert_equals(PC_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Byte");
		-- 	assert_equals(ADL_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADL_Load");
		-- 	assert_equals(ADH_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADH_Load");
		-- 	assert_equals(A_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "A_Load");
		-- 	assert_equals(B_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "B_Load");
		-- 	assert_equals(X_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "X_Load");
		-- 	assert_equals(Y_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Y_Load");
		-- 	assert_equals(ALU_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "ALU_Sel");
		-- 	assert_equals(Status_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Status_Load");
		-- 	assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "Bus1_Sel");
		-- 	assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_FETCH_0 Test", "Bus2_Sel");
		-- 	assert_equals(state, READ, "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		-- report "Control Unit Module: S_INCA_5 Test: End" severity note;

		-- -- Decrement A Test
		-- report "Control Unit Module: S_DECA_5 Test: Begin" severity note;
		-- 	IR <= DECA;
		-- 	Status_Result <= x"00";
		-- 	wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
		-- 	assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_FETCH_0 Test", "UUT_next_state");
		-- 	assert_equals(IR_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	assert_equals(MAR_Load, '1', "Control Unit Module", "S_FETCH_0 Test", "MAR_Load");
		-- 	assert_equals(MAR_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "MAR_Byte");
		-- 	assert_equals(PC_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Load");
		-- 	assert_equals(PC_Inc, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Inc");
		-- 	assert_equals(PC_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Byte");
		-- 	assert_equals(ADL_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADL_Load");
		-- 	assert_equals(ADH_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADH_Load");
		-- 	assert_equals(A_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "A_Load");
		-- 	assert_equals(B_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "B_Load");
		-- 	assert_equals(X_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "X_Load");
		-- 	assert_equals(Y_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Y_Load");
		-- 	assert_equals(ALU_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "ALU_Sel");
		-- 	assert_equals(Status_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Status_Load");
		-- 	assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "Bus1_Sel");
		-- 	assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_FETCH_0 Test", "Bus2_Sel");
		-- 	assert_equals(state, READ, "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		-- report "Control Unit Module: S_DECA_5 Test: End" severity note;

		-- -- Increment B Test
		-- report "Control Unit Module: S_INCB_5 Test: Begin" severity note;
		-- 	IR <= INCB;
		-- 	Status_Result <= x"00";
		-- 	wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
		-- 	assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_FETCH_0 Test", "UUT_next_state");
		-- 	assert_equals(IR_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	assert_equals(MAR_Load, '1', "Control Unit Module", "S_FETCH_0 Test", "MAR_Load");
		-- 	assert_equals(MAR_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "MAR_Byte");
		-- 	assert_equals(PC_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Load");
		-- 	assert_equals(PC_Inc, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Inc");
		-- 	assert_equals(PC_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Byte");
		-- 	assert_equals(ADL_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADL_Load");
		-- 	assert_equals(ADH_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADH_Load");
		-- 	assert_equals(A_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "A_Load");
		-- 	assert_equals(B_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "B_Load");
		-- 	assert_equals(X_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "X_Load");
		-- 	assert_equals(Y_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Y_Load");
		-- 	assert_equals(ALU_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "ALU_Sel");
		-- 	assert_equals(Status_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Status_Load");
		-- 	assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "Bus1_Sel");
		-- 	assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_FETCH_0 Test", "Bus2_Sel");
		-- 	assert_equals(state, READ, "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		-- report "Control Unit Module: S_INCB_5 Test: End" severity note;

		-- -- Decrement B Test
		-- report "Control Unit Module: S_DECB_5 Test: Begin" severity note;
		-- 	IR <= DECB;
		-- 	Status_Result <= x"00";
		-- 	wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
		-- 	assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_FETCH_0 Test", "UUT_next_state");
		-- 	assert_equals(IR_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	assert_equals(MAR_Load, '1', "Control Unit Module", "S_FETCH_0 Test", "MAR_Load");
		-- 	assert_equals(MAR_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "MAR_Byte");
		-- 	assert_equals(PC_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Load");
		-- 	assert_equals(PC_Inc, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Inc");
		-- 	assert_equals(PC_Byte, '0', "Control Unit Module", "S_FETCH_0 Test", "PC_Byte");
		-- 	assert_equals(ADL_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADL_Load");
		-- 	assert_equals(ADH_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "ADH_Load");
		-- 	assert_equals(A_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "A_Load");
		-- 	assert_equals(B_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "B_Load");
		-- 	assert_equals(X_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "X_Load");
		-- 	assert_equals(Y_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Y_Load");
		-- 	assert_equals(ALU_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "ALU_Sel");
		-- 	assert_equals(Status_Load, '0', "Control Unit Module", "S_FETCH_0 Test", "Status_Load");
		-- 	assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_FETCH_0 Test", "Bus1_Sel");
		-- 	assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_FETCH_0 Test", "Bus2_Sel");
		-- 	assert_equals(state, READ, "Control Unit Module", "S_FETCH_0 Test", "IR_Load");
		-- 	wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		-- report "Control Unit Module: S_DECB_5 Test: End" severity note;

		-- Branch Always Test
		report "Control Unit Module: S_BRA_5 Test: Begin" severity note;
			IR <= BRA;
			Status_Result <= x"00";
			wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
			assert_equals(UUT_next_state, S_BRA_6, "Control Unit Module", "S_BRA_5 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BRA_5 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_BRA_5 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BRA_5 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BRA_5 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BRA_5 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BRA_5 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BRA_5 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BRA_5 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BRA_5 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BRA_5 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BRA_5 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BRA_5 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BRA_5 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BRA_5 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BRA_5 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_BRA_5 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BRA_5 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BRA_5 Test: End" severity note;

		report "Control Unit Module: S_BRA_6 Test: Begin" severity note;
			IR <= BRA;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_BRA_7, "Control Unit Module", "S_BRA_6 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BRA_6 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_BRA_6 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_BRA_6 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BRA_6 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BRA_6 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BRA_6 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BRA_6 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BRA_6 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BRA_6 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BRA_6 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BRA_6 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BRA_6 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BRA_6 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BRA_6 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_BRA_6 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_BRA_6 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BRA_6 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BRA_6 Test: End" severity note;

		report "Control Unit Module: S_BRA_7 Test: Begin" severity note;
			IR <= BRA;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_BRA_8, "Control Unit Module", "S_BRA_7 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BRA_7 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BRA_7 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BRA_7 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BRA_7 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_BRA_7 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BRA_7 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BRA_7 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BRA_7 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BRA_7 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BRA_7 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BRA_7 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BRA_7 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BRA_7 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BRA_7 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BRA_7 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_BRA_7 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BRA_7 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BRA_7 Test: End" severity note;

		report "Control Unit Module: S_BRA_8 Test: Begin" severity note;
			IR <= BRA;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_BRA_9, "Control Unit Module", "S_BRA_8 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BRA_8 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BRA_8 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BRA_8 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BRA_8 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BRA_8 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BRA_8 Test", "PC_Byte");
			assert_equals(ADL_Load, '1', "Control Unit Module", "S_BRA_8 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BRA_8 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BRA_8 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BRA_8 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BRA_8 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BRA_8 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BRA_8 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BRA_8 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BRA_8 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_BRA_8 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_BRA_8 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BRA_8 Test: End" severity note;

		report "Control Unit Module: S_BRA_9 Test: Begin" severity note;
			IR <= BRA;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_BRA_10, "Control Unit Module", "S_BRA_9 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BRA_9 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_BRA_9 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BRA_9 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BRA_9 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BRA_9 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BRA_9 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BRA_9 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BRA_9 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BRA_9 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BRA_9 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BRA_9 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BRA_9 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BRA_9 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BRA_9 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BRA_9 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_BRA_9 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BRA_9 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BRA_9 Test: End" severity note;

		report "Control Unit Module: S_BRA_10 Test: Begin" severity note;
			IR <= BRA;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_BRA_11, "Control Unit Module", "S_BRA_10 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BRA_10 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_BRA_10 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_BRA_10 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BRA_10 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BRA_10 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BRA_10 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BRA_10 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BRA_10 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BRA_10 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BRA_10 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BRA_10 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BRA_10 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BRA_10 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BRA_10 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_BRA_10 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_BRA_10 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BRA_10 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BRA_10 Test: End" severity note;

		report "Control Unit Module: S_BRA_11 Test: Begin" severity note;
			IR <= BRA;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_BRA_12, "Control Unit Module", "S_BRA_11 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BRA_11 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BRA_11 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BRA_11 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BRA_11 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BRA_11 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BRA_11 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BRA_11 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BRA_11 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BRA_11 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BRA_11 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BRA_11 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BRA_11 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BRA_11 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BRA_11 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BRA_11 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_BRA_11 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BRA_11 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BRA_11 Test: End" severity note;

		report "Control Unit Module: S_BRA_12 Test: Begin" severity note;
			IR <= BRA;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_BRA_13, "Control Unit Module", "S_BRA_12 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BRA_12 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BRA_12 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BRA_12 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BRA_12 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BRA_12 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BRA_12 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BRA_12 Test", "ADL_Load");
			assert_equals(ADH_Load, '1', "Control Unit Module", "S_BRA_12 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BRA_12 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BRA_12 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BRA_12 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BRA_12 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BRA_12 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BRA_12 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BRA_12 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_BRA_12 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_BRA_12 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BRA_12 Test: End" severity note;

		report "Control Unit Module: S_BRA_13 Test: Begin" severity note;
			IR <= BRA;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_BRA_14, "Control Unit Module", "S_BRA_13 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BRA_13 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BRA_13 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BRA_13 Test", "MAR_Byte");
			assert_equals(PC_Load, '1', "Control Unit Module", "S_BRA_13 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BRA_13 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BRA_13 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BRA_13 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BRA_13 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BRA_13 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BRA_13 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BRA_13 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BRA_13 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BRA_13 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BRA_13 Test", "Status_Load");
			assert_equals(Bus1_Sel, "100", "Control Unit Module", "S_BRA_13 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_BRA_13 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BRA_13 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BRA_13 Test: End" severity note;

		report "Control Unit Module: S_BRA_14 Test: Begin" severity note;
			IR <= BRA;
			Status_Result <= x"00";
			assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_BRA_14 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BRA_14 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BRA_14 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BRA_14 Test", "MAR_Byte");
			assert_equals(PC_Load, '1', "Control Unit Module", "S_BRA_14 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BRA_14 Test", "PC_Inc");
			assert_equals(PC_Byte, '1', "Control Unit Module", "S_BRA_14 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BRA_14 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BRA_14 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BRA_14 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BRA_14 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BRA_14 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BRA_14 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BRA_14 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BRA_14 Test", "Status_Load");
			assert_equals(Bus1_Sel, "101", "Control Unit Module", "S_BRA_14 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_BRA_14 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BRA_14 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BRA_14 Test: End" severity note;

		-- TODO: Implement steps for other branching commands

		-- Branch Equals Test
		report "Control Unit Module: S_BEQ_5 Test: Begin" severity note;
			IR <= BEQ;
			Status_Result <= x"04";
			wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
			assert_equals(UUT_next_state, S_BEQ_6, "Control Unit Module", "S_BEQ_5 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BEQ_5 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_BEQ_5 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BEQ_5 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BEQ_5 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BEQ_5 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BEQ_5 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BEQ_5 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BEQ_5 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BEQ_5 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BEQ_5 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BEQ_5 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BEQ_5 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BEQ_5 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BEQ_5 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BEQ_5 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_BEQ_5 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BEQ_5 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BEQ_5 Test: End" severity note;

		report "Control Unit Module: S_BEQ_6 Test: Begin" severity note;
			IR <= BEQ;
			Status_Result <= x"04";
			assert_equals(UUT_next_state, S_BEQ_7, "Control Unit Module", "S_BEQ_6 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BEQ_6 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_BEQ_6 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_BEQ_6 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BEQ_6 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BEQ_6 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BEQ_6 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BEQ_6 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BEQ_6 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BEQ_6 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BEQ_6 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BEQ_6 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BEQ_6 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BEQ_6 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BEQ_6 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_BEQ_6 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_BEQ_6 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BEQ_6 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BEQ_6 Test: End" severity note;

		report "Control Unit Module: S_BEQ_7 Test: Begin" severity note;
			IR <= BEQ;
			Status_Result <= x"04";
			assert_equals(UUT_next_state, S_BEQ_8, "Control Unit Module", "S_BEQ_7 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BEQ_7 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BEQ_7 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BEQ_7 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BEQ_7 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_BEQ_7 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BEQ_7 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BEQ_7 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BEQ_7 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BEQ_7 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BEQ_7 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BEQ_7 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BEQ_7 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BEQ_7 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BEQ_7 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BEQ_7 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_BEQ_7 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BEQ_7 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BEQ_7 Test: End" severity note;

		report "Control Unit Module: S_BEQ_8 Test: Begin" severity note;
			IR <= BEQ;
			Status_Result <= x"04";
			assert_equals(UUT_next_state, S_BEQ_9, "Control Unit Module", "S_BEQ_8 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BEQ_8 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BEQ_8 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BEQ_8 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BEQ_8 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BEQ_8 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BEQ_8 Test", "PC_Byte");
			assert_equals(ADL_Load, '1', "Control Unit Module", "S_BEQ_8 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BEQ_8 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BEQ_8 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BEQ_8 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BEQ_8 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BEQ_8 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BEQ_8 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BEQ_8 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BEQ_8 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_BEQ_8 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_BEQ_8 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BEQ_8 Test: End" severity note;

		report "Control Unit Module: S_BEQ_9 Test: Begin" severity note;
			IR <= BEQ;
			Status_Result <= x"04";
			assert_equals(UUT_next_state, S_BEQ_10, "Control Unit Module", "S_BEQ_9 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BEQ_9 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_BEQ_9 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BEQ_9 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BEQ_9 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BEQ_9 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BEQ_9 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BEQ_9 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BEQ_9 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BEQ_9 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BEQ_9 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BEQ_9 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BEQ_9 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BEQ_9 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BEQ_9 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BEQ_9 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_BEQ_9 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BEQ_9 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BEQ_9 Test: End" severity note;

		report "Control Unit Module: S_BEQ_10 Test: Begin" severity note;
			IR <= BEQ;
			Status_Result <= x"04";
			assert_equals(UUT_next_state, S_BEQ_11, "Control Unit Module", "S_BEQ_10 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BEQ_10 Test", "IR_Load");
			assert_equals(MAR_Load, '1', "Control Unit Module", "S_BEQ_10 Test", "MAR_Load");
			assert_equals(MAR_Byte, '1', "Control Unit Module", "S_BEQ_10 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BEQ_10 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BEQ_10 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BEQ_10 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BEQ_10 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BEQ_10 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BEQ_10 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BEQ_10 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BEQ_10 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BEQ_10 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BEQ_10 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BEQ_10 Test", "Status_Load");
			assert_equals(Bus1_Sel, "001", "Control Unit Module", "S_BEQ_10 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_BEQ_10 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BEQ_10 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BEQ_10 Test: End" severity note;

		report "Control Unit Module: S_BEQ_11 Test: Begin" severity note;
			IR <= BEQ;
			Status_Result <= x"04";
			assert_equals(UUT_next_state, S_BEQ_12, "Control Unit Module", "S_BEQ_11 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BEQ_11 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BEQ_11 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BEQ_11 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BEQ_11 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BEQ_11 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BEQ_11 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BEQ_11 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BEQ_11 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BEQ_11 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BEQ_11 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BEQ_11 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BEQ_11 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BEQ_11 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BEQ_11 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BEQ_11 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_BEQ_11 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BEQ_11 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BEQ_11 Test: End" severity note;

		report "Control Unit Module: S_BEQ_12 Test: Begin" severity note;
			IR <= BEQ;
			Status_Result <= x"04";
			assert_equals(UUT_next_state, S_BEQ_13, "Control Unit Module", "S_BEQ_12 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BEQ_12 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BEQ_12 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BEQ_12 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BEQ_12 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BEQ_12 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BEQ_12 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BEQ_12 Test", "ADL_Load");
			assert_equals(ADH_Load, '1', "Control Unit Module", "S_BEQ_12 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BEQ_12 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BEQ_12 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BEQ_12 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BEQ_12 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BEQ_12 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BEQ_12 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BEQ_12 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "10", "Control Unit Module", "S_BEQ_12 Test", "Bus2_Sel");
			assert_equals(state, READ, "Control Unit Module", "S_BEQ_12 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BEQ_12 Test: End" severity note;

		report "Control Unit Module: S_BEQ_13 Test: Begin" severity note;
			IR <= BEQ;
			Status_Result <= x"04";
			assert_equals(UUT_next_state, S_BEQ_14, "Control Unit Module", "S_BEQ_13 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BEQ_13 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BEQ_13 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BEQ_13 Test", "MAR_Byte");
			assert_equals(PC_Load, '1', "Control Unit Module", "S_BEQ_13 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BEQ_13 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BEQ_13 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BEQ_13 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BEQ_13 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BEQ_13 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BEQ_13 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BEQ_13 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BEQ_13 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BEQ_13 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BEQ_13 Test", "Status_Load");
			assert_equals(Bus1_Sel, "100", "Control Unit Module", "S_BEQ_13 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_BEQ_13 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BEQ_13 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BEQ_13 Test: End" severity note;

		report "Control Unit Module: S_BEQ_14 Test: Begin" severity note;
			IR <= BEQ;
			Status_Result <= x"04";
			assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_BEQ_14 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BEQ_14 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BEQ_14 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BEQ_14 Test", "MAR_Byte");
			assert_equals(PC_Load, '1', "Control Unit Module", "S_BEQ_14 Test", "PC_Load");
			assert_equals(PC_Inc, '0', "Control Unit Module", "S_BEQ_14 Test", "PC_Inc");
			assert_equals(PC_Byte, '1', "Control Unit Module", "S_BEQ_14 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BEQ_14 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BEQ_14 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BEQ_14 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BEQ_14 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BEQ_14 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BEQ_14 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BEQ_14 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BEQ_14 Test", "Status_Load");
			assert_equals(Bus1_Sel, "101", "Control Unit Module", "S_BEQ_14 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "01", "Control Unit Module", "S_BEQ_14 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BEQ_14 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BEQ_14 Test: End" severity note;

		report "Control Unit Module: S_BEQ_15 Test: Begin" severity note;
			IR <= BEQ;
			Status_Result <= x"00";
			wait for CLK_PERIOD * 5;  -- Process Fetch and Decode
			assert_equals(UUT_next_state, S_FETCH_0, "Control Unit Module", "S_BEQ_15 Test", "UUT_next_state");
			assert_equals(IR_Load, '0', "Control Unit Module", "S_BEQ_15 Test", "IR_Load");
			assert_equals(MAR_Load, '0', "Control Unit Module", "S_BEQ_15 Test", "MAR_Load");
			assert_equals(MAR_Byte, '0', "Control Unit Module", "S_BEQ_15 Test", "MAR_Byte");
			assert_equals(PC_Load, '0', "Control Unit Module", "S_BEQ_15 Test", "PC_Load");
			assert_equals(PC_Inc, '1', "Control Unit Module", "S_BEQ_15 Test", "PC_Inc");
			assert_equals(PC_Byte, '0', "Control Unit Module", "S_BEQ_15 Test", "PC_Byte");
			assert_equals(ADL_Load, '0', "Control Unit Module", "S_BEQ_15 Test", "ADL_Load");
			assert_equals(ADH_Load, '0', "Control Unit Module", "S_BEQ_15 Test", "ADH_Load");
			assert_equals(A_Load, '0', "Control Unit Module", "S_BEQ_15 Test", "A_Load");
			assert_equals(B_Load, '0', "Control Unit Module", "S_BEQ_15 Test", "B_Load");
			assert_equals(X_Load, '0', "Control Unit Module", "S_BEQ_15 Test", "X_Load");
			assert_equals(Y_Load, '0', "Control Unit Module", "S_BEQ_15 Test", "Y_Load");
			assert_equals(ALU_Sel, "000", "Control Unit Module", "S_BEQ_15 Test", "ALU_Sel");
			assert_equals(Status_Load, '0', "Control Unit Module", "S_BEQ_15 Test", "Status_Load");
			assert_equals(Bus1_Sel, "000", "Control Unit Module", "S_BEQ_15 Test", "Bus1_Sel");
			assert_equals(Bus2_Sel, "00", "Control Unit Module", "S_BEQ_15 Test", "Bus2_Sel");
			assert_equals(state, OFF, "Control Unit Module", "S_BEQ_15 Test", "IR_Load");
			wait for CLK_PERIOD;  -- Wait for 1 clock cycle
		report "Control Unit Module: S_BEQ_15 Test: End" severity note;

		wait;
	end process;

end control_unit_tb_arch;
