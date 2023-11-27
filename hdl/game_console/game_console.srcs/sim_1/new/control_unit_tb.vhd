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
	constant CLK_HZ: integer := 25178570;  -- 12.17857 MHz
	constant CLK_PERIOD: time := 1 sec / clk_hz;

	-------------------------------
	-- Components
	-------------------------------
	component control_unit
		port (
			clk: in std_logic;
			rst: in std_logic;
			state: out t_Bus_State;
			IR_Load: out std_logic;
			IR: in std_logic_vector(7 downto 0);
			MAR_Load: out std_logic;
			MAR_Byte: out std_logic;
			PC_Load: out std_logic;
			PC_Inc: out std_logic;
			PC_Byte: out std_logic;
			A_Load: out std_logic;
			B_Load: out std_logic;
			X_Load: out std_logic;
			Y_Load: out std_logic;
			ALU_Sel: out std_logic_vector(2 downto 0);
			Status_Result: in std_logic_vector(7 downto 0);
			Status_Load: out std_logic;
			Bus1_Sel: out std_logic_vector(1 downto 0);
			Bus2_Sel: out std_logic_vector(1 downto 0)
		);
	end component;

	-------------------------------
	-- Signals
	-------------------------------
	signal clk: std_logic := '0';
	signal rst: std_logic := '0';
	signal state: t_Bus_State;
	signal IR_Load: std_logic;
	signal IR: std_logic_vector(7 downto 0) := BUS_HIGH_Z;
	signal MAR_Load: std_logic;
	signal MAR_Byte: std_logic;
	signal PC_Load: std_logic;
	signal PC_Inc: std_logic;
	signal PC_Byte: std_logic;
	signal A_Load: std_logic;
	signal B_Load: std_logic;
	signal X_Load: std_logic;
	signal Y_Load: std_logic;
	signal ALU_Sel: std_logic_vector(2 downto 0);
	signal Status_Result: std_logic_vector(7 downto 0) := BUS_HIGH_Z;
	signal Status_Load: std_logic;
	signal Bus1_Sel: std_logic_vector(1 downto 0);
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
		alias UUT_current_state is <<signal UUT.current_state: t_States>>;
		alias UUT_next_state is <<signal UUT.next_state: t_States>>;
	begin
		-- Test Reset State
		report "Control Unit Module: Reset Test: Begin" severity note;
		wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
		assert_equals(UUT_current_state, S_FETCH_0, "Control Unit Module", "Reset Test", "UUT_current_state");
		rst <= '1';  -- Take out of reset mode
		wait for CLK_PERIOD;  -- Wait 1 clock cycle before changing data
		report "Control Unit Module: Reset Test: End" severity note;
		wait;
	end process;

end control_unit_tb_arch;
