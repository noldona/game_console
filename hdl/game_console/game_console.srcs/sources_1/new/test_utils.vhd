-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/26/2023 08:05:36 PM
-- Design Name: Test Utilities
-- Module Name: test_utils - Behavioral
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This defines some utilities for use in the test benches
--
-- Dependencies:
-- 		Game Console Utilities
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


package test_utils is
	-----------------------------------------------
	-- Type Definitions
	-----------------------------------------------

	-----------------------------------------------
	-- Constant Definitions
	-----------------------------------------------

	-----------------------------------------------
	-- Function Definitions
	-----------------------------------------------
	function to_string(N: t_States) return string;
	function to_string(N: t_Bus_State) return string;

	-----------------------------------------------
	-- Procedure Definitions
	-----------------------------------------------
	procedure assert_equals(var: in t_States; should: in t_States; module_name: string; test_name: string; var_name: string);
	procedure assert_equals(var: in t_Bus_State; should: in t_Bus_State; module_name: string; test_name: string; var_name: string);
	procedure assert_equals(var: in std_logic_vector; should: in std_logic_vector; module_name: string; test_name: string; var_name: string);
	procedure assert_equals(var: in std_logic; should: in std_logic; module_name: string; test_name: string; var_name: string);

end package;

package body test_utils is
	-------------------------------
	-- Functions
	-------------------------------
	function to_string(N: t_States) return string is
	begin
		case (N) is
			-- Opcode Fetch states
			when S_FETCH_0 =>
				return "S_FETCH_0";
			when S_FETCH_1 =>
				return "S_FETCH_1";
			when S_FETCH_2 =>
				return "S_FETCH_2";
			when S_FETCH_3 =>
				return "S_FETCH_3";
			-- Opcode Decode state
			when S_DECODE_4 =>
				return "S_DECODE_4";
			-- Load A (Immediate) states
			when S_LDA_IMM_5 =>
				return "S_LDA_IMM_5";
			when S_LDA_IMM_6 =>
				return "S_LDA_IMM_6";
			when S_LDA_IMM_7 =>
				return "S_LDA_IMM_7";
			when S_LDA_IMM_8 =>
				return "S_LDA_IMM_8";
			-- Load A (Direct) states
			when S_LDA_DIR_5 =>
				return "S_LDA_DIR_5";
			when S_LDA_DIR_6 =>
				return "S_LDA_DIR_6";
			when S_LDA_DIR_7 =>
				return "S_LDA_DIR_7";
			when S_LDA_DIR_8 =>
				return "S_LDA_DIR_8";
			when S_LDA_DIR_9 =>
				return "S_LDA_DIR_9";
			when S_LDA_DIR_10 =>
				return "S_LDA_DIR_10";
			when S_LDA_DIR_11 =>
				return "S_LDA_DIR_11";
			when S_LDA_DIR_12 =>
				return "S_LDA_DIR_12";
			when S_LDA_DIR_13 =>
				return "S_LDA_DIR_13";
			when S_LDA_DIR_14 =>
				return "S_LDA_DIR_14";
			when S_LDA_DIR_15 =>
				return "S_LDA_DIR_15";
			when S_LDA_DIR_16 =>
				return "S_LDA_DIR_16";
			-- Store A (Direct) states
			when S_STA_DIR_5 =>
				return "S_STA_DIR_5";
			when S_STA_DIR_6 =>
				return "S_STA_DIR_6";
			when S_STA_DIR_7 =>
				return "S_STA_DIR_7";
			when S_STA_DIR_8 =>
				return "S_STA_DIR_8";
			when S_STA_DIR_9 =>
				return "S_STA_DIR_9";
			when S_STA_DIR_10 =>
				return "S_STA_DIR_10";
			when S_STA_DIR_11 =>
				return "S_STA_DIR_11";
			when S_STA_DIR_12 =>
				return "S_STA_DIR_12";
			when S_STA_DIR_13 =>
				return "S_STA_DIR_13";
			when S_STA_DIR_14 =>
				return "S_STA_DIR_14";
			when S_STA_DIR_15 =>
				return "S_STA_DIR_15";
			-- Load B (Immediate) states
			when S_LDB_IMM_5 =>
				return "S_LDB_IMM_5";
			when S_LDB_IMM_6 =>
				return "S_LDB_IMM_6";
			when S_LDB_IMM_7 =>
				return "S_LDB_IMM_7";
			when S_LDB_IMM_8 =>
				return "S_LDB_IMM_8";
			-- Load B (Direct) states
			when S_LDB_DIR_5 =>
				return "S_LDB_DIR_5";
			when S_LDB_DIR_6 =>
				return "S_LDB_DIR_6";
			when S_LDB_DIR_7 =>
				return "S_LDB_DIR_7";
			when S_LDB_DIR_8 =>
				return "S_LDB_DIR_8";
			when S_LDB_DIR_9 =>
				return "S_LDB_DIR_9";
			when S_LDB_DIR_10 =>
				return "S_LDB_DIR_10";
			when S_LDB_DIR_11 =>
				return "S_LDB_DIR_11";
			when S_LDB_DIR_12 =>
				return "S_LDB_DIR_12";
			when S_LDB_DIR_13 =>
				return "S_LDB_DIR_13";
			when S_LDB_DIR_14 =>
				return "S_LDB_DIR_14";
			when S_LDB_DIR_15 =>
				return "S_LDB_DIR_15";
			when S_LDB_DIR_16 =>
				return "S_LDB_DIR_16";
			-- Store B (Direct) states
			when S_STB_DIR_5 =>
				return "S_STB_DIR_5";
			when S_STB_DIR_6 =>
				return "S_STB_DIR_6";
			when S_STB_DIR_7 =>
				return "S_STB_DIR_7";
			when S_STB_DIR_8 =>
				return "S_STB_DIR_8";
			when S_STB_DIR_9 =>
				return "S_STB_DIR_9";
			when S_STB_DIR_10 =>
				return "S_STB_DIR_10";
			when S_STB_DIR_11 =>
				return "S_STB_DIR_11";
			when S_STB_DIR_12 =>
				return "S_STB_DIR_12";
			when S_STB_DIR_13 =>
				return "S_STB_DIR_13";
			when S_STB_DIR_14 =>
				return "S_STB_DIR_14";
			when S_STB_DIR_15 =>
				return "S_STB_DIR_15";
			-- A <= A + B
			when S_ADD_AB_5 =>
				return "S_ADD_AB_5";
			-- A <= A - B
			when S_SUB_AB_5 =>
				return "S_SUB_AB_5";
			-- A <= A & B
			when S_AND_AB_5 =>
				return "S_AND_AB_5";
			-- A <= A | B
			when S_OR_AB_5 =>
				return "S_OR_AB_5";
			-- A <= A + 1
			when S_INCA_5 =>
				return "S_INCA_5";
			-- A <= A - 1
			when S_DECA_5 =>
				return "S_DECA_5";
			-- B <= B + 1
			when S_INCB_5 =>
				return "S_INCB_5";
			-- B <= B - 1
			when S_DECB_5 =>
				return "S_DECB_5";
			-- Branch Always
			when S_BRA_5 =>
				return "S_BRA_5";
			when S_BRA_6 =>
				return "S_BRA_6";
			when S_BRA_7 =>
				return "S_BRA_7";
			when S_BRA_8 =>
				return "S_BRA_8";
			when S_BRA_9 =>
				return "S_BRA_9";
			when S_BRA_10 =>
				return "S_BRA_10";
			when S_BRA_11 =>
				return "S_BRA_11";
			when S_BRA_12 =>
				return "S_BRA_12";
			when S_BRA_13 =>
				return "S_BRA_13";
			when S_BRA_14 =>
				return "S_BRA_14";
			-- Branch if Z = 1
			when S_BEQ_5 =>
				return "S_BEQ_5";
			when S_BEQ_6 =>
				return "S_BEQ_6";
			when S_BEQ_7 =>
				return "S_BEQ_7";
			when S_BEQ_8 =>
				return "S_BEQ_8";
			when S_BEQ_9 =>
				return "S_BEQ_9";
			when S_BEQ_10 =>
				return "S_BEQ_10";
			when S_BEQ_11 =>
				return "S_BEQ_11";
			when S_BEQ_12 =>
				return "S_BEQ_12";
			when S_BEQ_13 =>
				return "S_BEQ_13";
			when S_BEQ_14 =>
				return "S_BEQ_14";
			when S_BEQ_15 =>
				return "S_BEQ_15";
			when others =>
				return "";
		end case ;
	end to_string;

	function to_string(N: t_Bus_State) return string is
	begin
		case (N) is
			when OFF =>
				return "OFF";
			when READ =>
				return "READ";
			when WRITE =>
				return "WRITE";
			when others =>
				return "";
		end case ;
	end to_string;

	-------------------------------
	-- Procedures
	-------------------------------
	procedure assert_equals(var: in t_States; should: in t_States; module_name: string; test_name: string; var_name: string) is
	begin
		assert var = should
			report module_name & ": " & test_name & " - " &
				"Invalid '" & var_name & "' value, " &
				"Expected: '" & to_string(should) & "' " &
				"but got '" & to_string(var) & "'"
			severity error;
	end procedure assert_equals;

	procedure assert_equals(var: in t_Bus_State; should: in t_Bus_State; module_name: string; test_name: string; var_name: string) is
		begin
			assert var = should
				report module_name & ": " & test_name & " - " &
					"Invalid '" & var_name & "' value, " &
					"Expected: '" & to_string(should) & "' " &
					"but got '" & to_string(var) & "'"
				severity error;
		end procedure assert_equals;

	procedure assert_equals(var: in std_logic_vector; should: in std_logic_vector; module_name: string; test_name: string; var_name: string) is
	begin
		assert var = should
			report module_name & ": " & test_name & " - " &
				"Invalid '" & var_name & "' value, " &
				"Expected: '" & to_hstring(should) & "' " &
				"but got '" & to_hstring(var) & "'"
			severity error;
	end procedure assert_equals;

	procedure assert_equals(var: in std_logic; should: in std_logic; module_name: string; test_name: string; var_name: string) is
	begin
		assert var = should
			report module_name & ": " & test_name & " - " &
				"Invalid '" & var_name & "' value, " &
				"Expected: " & std_logic'image(should) & " " &
				"but got " & std_logic'image(var) & ""
			severity error;
	end procedure assert_equals;

end package body test_utils;
