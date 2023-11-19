----------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/14/2023 02:13:08 PM
-- Design Name: VGA Video Card Test Bench
-- Module Name: video_card_tb - video_card_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the VGA Video Card module
--
-- Dependencies: VGA Video Card
--
-- Revision: 0.1.0
-- Revision 0.1.0 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity video_card_tb is
	-- Port ();
end video_card_tb;

architecture video_card_tb_arch of video_card_tb is
	constant clk_hz: integer := 100e6;
	constant clk_period: time := 1 sec / clk_hz;

	component video_card is
		port(
			clk: in std_logic;
			vgaRed : out std_logic_vector(3 downto 0);
			vgaGreen : out std_logic_vector(3 downto 0);
			vgaBlue : out std_logic_vector(3 downto 0);
			hsync : out std_logic;
			vsync : out std_logic
		);
	end component;

	signal clk: std_logic := '0';
	signal vgaRed: std_logic_vector(3 downto 0);
	signal vgaGreen: std_logic_vector(3 downto 0);
	signal vgaBlue: std_logic_vector(3 downto 0);
	signal hsync: std_logic;
	signal vsync: std_logic;
begin
	UUT: video_card port map(
		clk => clk,
		vgaRed => vgaRed,
		vgaGreen => vgaGreen,
		vgaBlue => vgaBlue,
		hsync => hsync,
		vsync => vsync
	);

	CLK_PROC: process begin
		wait for clk_period / 2;
		if (clk = '1') then
			clk <= '0';
		else
			clk <= '1';
		end if;
	end process;
end video_card_tb_arch;
