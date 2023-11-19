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
			PC_Load: in std_logic;
			PC_Inc: in std_logic;
			A_Load: in std_logic;
			B_Load: in std_logic;
			X_Load: in std_logic;
			Y_Load: in std_logic;
			ALU_Sel: in std_logic_vector(2 downto 0);
			Status_Result: out std_logic_vector(3 downto 0);
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

begin
	-------------------------------
	-- Component Implementations
	-------------------------------

	-------------------------------
	-- Module Implementation
	-------------------------------
	-- TODO: Implement the Data Path test bench

	ALU_UUT: alu_tb;
	REG_UUT: reg_tb;

end data_path_tb_arch;
