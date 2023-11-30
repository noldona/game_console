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
-- 		Video Card Sync Counter
-- 		Random Access Memory
-- 		Register
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
		REG_ADDR_MIN: integer;
		REG_ADDR_MAX: integer
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		data: inout std_logic_vector(7 downto 0);
		addr: in std_logic_vector(15 downto 0);
		state: in t_Bus_States;
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
	-- Inline If-Then-Else function
	function ite(b: boolean; x, y: integer) return integer is
		begin
			if (b) then
				return x;
			else
				return y;
			end if;
		end function ite;

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
			RESOLUTION: t_VGA := VGA_640_480_60;
			DIR: std_logic := '0'  -- '0' = Horizontal, '1' = Vertical
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

	component ram
		generic (
			START_ADDRESS: integer := 16#0000#;
			END_ADDRESS: integer := 16#FFFF#;
			INIT_FILE: string := "";
			READ_ONLY: std_logic := '0'  -- 0: RAM, 1: ROM
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			state: in t_Bus_States;
			addr: in std_logic_vector(15 downto 0);
			data: inout std_logic_vector(7 downto 0)
		);
	end component;

	component reg
		generic (
			SIZE: integer := 8
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			load: in std_logic;
			data_rx: in std_logic_vector(SIZE - 1 downto 0);
			data_tx: out std_logic_vector(SIZE - 1 downto 0)
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

	-- Address Signals
	signal addr_x: std_logic_vector(15 downto 0) := x"0000";
	signal addr_y: std_logic_vector(15 downto 0) := x"0000";
	signal temp: std_logic_vector(31 downto 0);

	-- VRAM Signals
	signal ram_addr: std_logic_vector(15 downto 0) := x"0000";
	signal ram_data: std_logic_vector(7 downto 0) := BUS_HIGH_Z;

	-- VREG Signals
	signal data_rx: std_logic_vector(7 downto 0);
	signal data_tx: std_logic_vector(7 downto 0);
	signal EN: std_logic;
	signal load: std_logic;

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	-- Sync Counter for the Hortizontal
	HSYNC_COUNTER: sync_counter
		generic map (
			RESOLUTION => RESOLUTION,
			DIR => '0'  -- Horizontal
		)
		port map (
			clk => clk,
			rst => rst,
			sync => hsync,
			blank => hblank,
			addr => addr_x,
			carry => hcarry
		);

	-- Sync Counter for the Vertical
	VSYNC_COUNTER: sync_counter
		generic map (
			RESOLUTION => RESOLUTION,
			DIR => '1'  -- Vertical
		)
		port map (
			clk => hcarry,
			rst => rst,
			sync => vsync,
			blank => vblank,
			addr => addr_y,
			carry => vcarry
		);

	VRAM_1: ram
		generic map (
			START_ADDRESS => 16#0000#,
			END_ADDRESS => 16#7FFF#,
			INIT_FILE => "image_1.mif",
			READ_ONLY => '1'
		)
		port map (
			clk => clk,
			rst => rst,
			state => READ,
			addr => ram_addr,
			data => ram_data
		);

	VRAM_2: ram
		generic map (
			START_ADDRESS => 16#8000#,
			END_ADDRESS => 16#FFFF#,
			INIT_FILE => "image_2.mif",
			READ_ONLY => '1'
		)
		port map (
			clk => clk,
			rst => rst,
			state => READ,
			addr => ram_addr,
			data => ram_data
		);

	VGA_REG: reg
		generic map (
			SIZE => 8
		)
		port map (
			clk => clk,
			rst => rst,
			load => load,
			data_rx => data_rx,
			data_tx => data_tx
		);

	-------------------------------
	-- Module Implementation
	-------------------------------
	ENABLE: process (addr)
	begin
		if ((to_integer(unsigned(addr)) >= REG_ADDR_MIN) and
				(to_integer(unsigned(addr)) <= REG_ADDR_MAX)) then
			EN <= '1';
		else
			EN <= '0';
		end if;
	end process;

	REG_LOAD: process (EN)
	begin
		if (EN = '1' and state = WRITE) then
			load <= '1';
		else
			load <= '0';
		end if;
	end process;

	data_rx <= data;
	data <= data_tx when (state = READ AND EN = '1') else BUS_HIGH_Z;

	temp <= std_logic_vector(
		((unsigned(addr_y) / Y_DIV) * RESOLUTION.hsync.active) +
		((unsigned(addr_x)) / X_DIV) +
		(to_unsigned(ite((data_tx = x"80"), 16#8000#, 16#0000#), 16)));
	ram_addr <= temp(15 downto 0);

	vgaRed <= "000" when (vblank = '1' or hblank = '1') else ram_data(7 downto 5);
	vgaGreen <= "000" when (vblank = '1' or hblank = '1') else ram_data(4 downto 2);
	vgaBlue <= "00" when (vblank = '1' or hblank = '1') else ram_data(1 downto 0);

end video_card_arch;
