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
			PC_Load: out std_logic;
			PC_Inc: out std_logic;
			A_Load: out std_logic;
			B_Load: out std_logic;
			ALU_Sel: out std_logic_vector(2 downto 0);
			CCR_Result: in std_logic_vector(3 downto 0);
			CCR_Load: out std_logic;
			Bus1_Sel: out std_logic_vector(1 downto 0);
			Bus2_Sel: out std_logic_vector(1 downto 0)
		);
	end component;

	-------------------------------
	-- Signals
	-------------------------------

begin
	-------------------------------
	-- Component Implementations
	-------------------------------

	-------------------------------
	-- Module Implementation
	-------------------------------
	-- TODO: Implement the Control Unit test bench

end control_unit_tb_arch;
