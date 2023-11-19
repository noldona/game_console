-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/14/2023 02:13:08 PM
-- Design Name: VGA Video Card Test Bench
-- Module Name: video_card_tb - video_card_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the VGA Video Card module
--
-- Dependencies:
-- 		VGA Types
-- 		Game Console Utilities
-- 		VGA Video Card
-- 		Sync Counter Test Bench
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


entity video_card_tb is
	-- port ();
end video_card_tb;

architecture video_card_tb_arch of video_card_tb is
	-------------------------------
	-- Functions
	-------------------------------

	-------------------------------
	-- Types
	-------------------------------

	-------------------------------
	-- Constants
	-------------------------------
	constant clk_hz: integer := 100e6;
	constant clk_period: time := 1 sec / clk_hz;

	-------------------------------
	-- Components
	-------------------------------
	component video_card
		port(
			clk: in std_logic;
			vgaRed : out std_logic_vector(3 downto 0);
			vgaGreen : out std_logic_vector(3 downto 0);
			vgaBlue : out std_logic_vector(3 downto 0);
			hsync : out std_logic;
			vsync : out std_logic
		);
	end component;

	component sync_counter_tb
		-- port ();
	end component;

	-------------------------------
	-- Signals
	-------------------------------
	signal clk: std_logic := '0';
	signal vgaRed: std_logic_vector(3 downto 0);
	signal vgaGreen: std_logic_vector(3 downto 0);
	signal vgaBlue: std_logic_vector(3 downto 0);
	signal hsync: std_logic;
	signal vsync: std_logic;
begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	UUT: video_card port map(
		clk => clk,
		vgaRed => vgaRed,
		vgaGreen => vgaGreen,
		vgaBlue => vgaBlue,
		hsync => hsync,
		vsync => vsync
	);

	SYNC_COUNTER_UUT: sync_counter_tb;

	-------------------------------
	-- Module Implementation
	-------------------------------
	CLK_PROC: process begin
		wait for clk_period / 2;
		if (clk = '1') then
			clk <= '0';
		else
			clk <= '1';
		end if;
	end process;

	-- TODO: Implement automated checks for the VGA output

end video_card_tb_arch;
