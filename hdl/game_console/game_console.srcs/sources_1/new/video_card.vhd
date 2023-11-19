-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/12/2023 03:35:04 PM
-- Design Name: VGA Video Card
-- Module Name: video_card - video_card_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This will generate the required signals for a VGA connection
--		It will supply 4-bits per color at the selected screen resolution
--		Screen resolution options are the following:
--			640 x 350
--				VGA 640x350@70 Hz (pixel clock 25.175 MHz)
--			640 x 400
--				VGA 640x400@70 Hz (pixel clock 25.175 MHz)
--			640 x 480
--				VGA 640x480@60 Hz Industry standard (pixel clock 25.175 MHz)
--			800 x 600
--				SVGA 800x600@60 Hz (pixel clock 40.0 MHz)
--
-- Dependencies:
-- 		VGA Types
-- 		Game Console Utilities
-- 		Sync Counter
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


entity video_card is
	generic (
		RESOLUTION: t_VGA := VGA_640_480_60;
		X_DIV: integer := 2;
		Y_DIV: integer := 2;
		MEM_OFFSET: integer := 0
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		data: in std_logic_vector(7 downto 0);
		addr: out std_logic_vector(15 downto 0);
		rdy: in std_logic;
		vgaRed: out std_logic_vector(2 downto 0);
		vgaGreen: out std_logic_vector(2 downto 0);
		vgaBlue: out std_logic_vector(1 downto 0);
		hsync: out std_logic;
		vsync: out std_logic
	);
end video_card;

architecture video_card_arch of video_card is
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
	component sync_counter
		generic (
			resolution: t_VGA;
			dir: std_logic  -- '0' = Horizontal, '1' = Vertical
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			sync: out std_logic;
			blank: out std_logic;
			addr: out std_logic_vector(15 downto 0);
			carry: out std_logic
		);
	end component;

	-------------------------------
	-- Signals
	-------------------------------
	-- Horizontal Sync Counter Signals
	signal hblank: std_logic := '0';
	signal hcarry: std_logic := '1';

	-- Vertical Sync Counter Signals
	signal vblank: std_logic := '0';
	signal vcarry: std_logic := '1';

	-- Address Lines
	signal addr_x: std_logic_vector(15 downto 0) := x"0000";
	signal addr_y: std_logic_vector(15 downto 0) := x"0000";
	signal temp: std_logic_vector(31 downto 0);


begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	-- Sync Counter for the Hortizontal
	HSYNC_COUNTER: sync_counter
		generic map (
			resolution => RESOLUTION,
			dir => '0'  -- Horizontal
		)
		port map (
			clk => clk,
			rst => '1',
			sync => hsync,
			blank => hblank,
			addr => addr_x,
			carry => hcarry
		);

	-- Sync Counter for the Vertical
	VSYNC_COUNTER: sync_counter
		generic map (
			resolution => RESOLUTION,
			dir => '1'  -- Vertical
		)
		port map (
			clk => hcarry,
			rst => '1',
			sync => vsync,
			blank => vblank,
			addr => addr_y,
			carry => vcarry
		);

	-------------------------------
	-- Module Implementation
	-------------------------------
	temp <= std_logic_vector((((unsigned(addr_y) / Y_DIV) * (RESOLUTION.hsync.active)) + ((unsigned(addr_x) - 1) / X_DIV) + MEM_OFFSET));
	addr <= temp(15 downto 0);

	vgaRed <= "000" when (vblank = '1' or hblank = '1') else data(7 downto 5);
	vgaGreen <= "000" when (vblank = '1' or hblank = '1') else data(4 downto 2);
	vgaBlue <= "00" when (vblank = '1' or hblank = '1') else data(1 downto 0);

end video_card_arch;
