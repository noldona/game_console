-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/29/2023 11:24:47 AM
-- Design Name: Central Processing Unit
-- Module Name: cpu - cpu_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is the main processor for the game console. It's
-- 		instruction set is based upon the MOS Technology's 6502 processor.
--
-- Dependencies:
-- 		Game Console Utilities
-- 		Data Path
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


entity cpu is
	port (
		clk: in std_logic;
		rst: in std_logic;
		data: inout std_logic_vector(7 downto 0);
		addr: out std_logic_vector(15 downto 0);
		state: out t_Bus_State;
		rdy: out std_logic
	);
end cpu;

architecture cpu_arch of cpu is
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
	component data_path
		port (
			clk: in std_logic;
			rst: in std_logic;
			data: inout std_logic_vector(7 downto 0);
			addr: out std_logic_vector(15 downto 0);
			state: in t_Bus_State;
			IR_Load: in std_logic;
			IR: out std_logic_vector(7 downto 0);
			MAR_Load: in std_logic;
			MAR_Byte: in std_logic;
			PC_Load: in std_logic;
			PC_Inc: in std_logic;
			PC_Byte: in std_logic;
			ADL_Load: in std_logic;
			ADH_Load: in std_logic;
			A_Load: in std_logic;
			B_Load: in std_logic;
			X_Load: in std_logic;
			Y_Load: in std_logic;
			ALU_Sel: in std_logic_vector(2 downto 0);
			Status_Result: out std_logic_vector(7 downto 0);
			Status_Load: in std_logic;
			Bus1_Sel: in std_logic_vector(2 downto 0);
			Bus2_Sel: in std_logic_vector(1 downto 0)
		);
	end component;

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
	signal IR_Load: std_logic;
	signal IR: std_logic_vector(7 downto 0);
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
	signal Status_Result: std_logic_vector(7 downto 0);
	signal Status_Load: std_logic;
	signal Bus1_Sel: std_logic_vector(2 downto 0);
	signal Bus2_Sel: std_logic_vector(1 downto 0);

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	CU_1: control_unit
		port map (
			clk => clk,
			rst => rst,
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
			ALU_Sel => ALU_Sel,
			Status_Result => Status_Result,
			Status_Load => Status_Load,
			Bus1_Sel => Bus1_Sel,
			Bus2_Sel => Bus2_Sel
		);

	DP_1: data_path
		port map (
			clk => clk,
			rst => rst,
			data => data,
			addr => addr,
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

end cpu_arch;
