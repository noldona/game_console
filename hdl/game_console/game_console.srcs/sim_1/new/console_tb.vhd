-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/19/2023 03:55:39 PM
-- Design Name: Game Console Test Bench
-- Module Name: console_tb - console_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the Game Console module
--
-- Dependencies:
-- 		VGA Types
-- 		Game Console Utilities
-- 		Game Console
-- 		Central Processing Unit Test Bench
-- 		Video Card Test Bench
-- 		Memory Test Bench
-- 		Sound Card Test Bench
--
-- Revision: 0.1.0
-- Revision 0.1.0 - File Created
-- Additional Comments:
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use WORK.VGA_TYPES.ALL;
use WORK.CONSOLE_UTILS.ALL;


entity console_tb is
	--  port ();
end console_tb;

architecture console_tb_arch of console_tb is
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
	component console
		port (
			clk_12MHz: in std_logic;
			rst_btn: in std_logic;

			-- CPU Ports

			-- VGA Ports
			vgaRed: out std_logic_vector(2 downto 0);
			vgaGreen: out std_logic_vector(2 downto 0);
			vgaBlue: out std_logic_vector(1 downto 0);
			hysnc: out std_logic;
			vsync: out std_logic

			-- Memory Ports
			-- TODO: Add ports for controllers
		);
	end component;

	component cpu_tb
		--  port ();
	end component;

	component video_card_tb
		-- port ();
	end component;

	component memory_tb
		-- port();
	end component;

	component sound_card_tb
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
	-- TODO: Implement the Game Console test bench

	CPU_UUT: cpu_tb;
	VGA_UUT: video_card_tb;
	MEM_UUT: memory_tb;
	APU_UUT: sound_card_tb;

end console_tb_arch;
