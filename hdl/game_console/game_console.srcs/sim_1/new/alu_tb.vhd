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


-- TODO: Implement the Arithmetic Logic Unit test bench
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
	signal sel: std_logic_vector(2 downto 0) := "ZZZ";
	signal result: std_logic_vector(7 downto 0);
	signal status: std_logic_vector(7 downto 0);

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

	end process;

end alu_tb_arch;
