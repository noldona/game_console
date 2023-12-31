-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/29/2023 11:24:47 AM
-- Design Name: Game Console
-- Module Name: console - console_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is the main file for the game conole.
--
-- Dependencies:
-- 		VGA Types
-- 		Game Console Utilities
-- 		Clock Wizard
-- 		Central Processing Unit
-- 		Video Card
-- 		Memory
-- 		Sound Card
--
-- Revision: 0.1.0
-- Revision 0.1.0 - File Created
-- Additional Comments:
-- 		This container connects the CPU, Video Card, Memory, and Sound Cards
-- 		together. It also uses the Clock Wizard IP to generate a 40 MHz and
-- 		a 25.17857 MHz clock. As the required clock signals for the possible
-- 		VGA signals are 40MHz and 25.175MHz, these are the closest signals
-- 		that the development board can generate.
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use WORK.VGA_TYPES.ALL;
use WORK.CONSOLE_UTILS.ALL;


entity console is
	port (
		clk_12MHz: in std_logic;
		rst_btn: in std_logic;

		-- CPU Ports

		-- VGA Ports
		vgaRed: out std_logic_vector(2 downto 0);
		vgaGreen: out std_logic_vector(2 downto 0);
		vgaBlue: out std_logic_vector(1 downto 0);
		hsync: out std_logic;
		vsync: out std_logic;

		-- Memory Ports
		-- TODO: Add ports for controllers
		toggle_btn: in std_logic

		-- Sound Card Ports
		-- TODO: Add ports for audio out
	);
end console;

architecture console_arch of console is
	-------------------------------
	-- Functions
	-------------------------------

	-------------------------------
	-- Types
	-------------------------------

	-------------------------------
	-- Constants
	-------------------------------
	-- Using 640x480 resolution, so we can output 320x240 resolution
	-- This is the biggest resolution that fits within 32k of memory
	-- at a byte per pixel, giving up 256 colors
	constant RESOLUTION: t_VGA := VGA_640_480_60;
	-- constant RESOLUTION: t_VGA := SVGA_800_600_60;

	-------------------------------
	-- Components
	-------------------------------
	component clk_wiz_0
		port (
			-- Clock in ports
			clk_in1: std_logic;
			-- Clock out ports
			clk_40MHz: out std_logic;
			clk_25MHz: out std_logic;
			-- Statu and control signals
			resetn: in std_logic
		);
	end component;

	component cpu
		port (
			clk: in std_logic;
			rst: in std_logic;
			data: inout std_logic_vector(7 downto 0);
			addr: out std_logic_vector(15 downto 0);
			state: out t_Bus_States;
			rdy: out std_logic
		);
	end component;

	component video_card
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
	end component;

	component memory
		generic (
			IO_DIR: std_logic_vector(15 downto 0) := x"0000"
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			data: inout std_logic_vector(7 downto 0);
			addr: in std_logic_vector(15 downto 0);
			state: in t_Bus_States;
			io_ports: inout t_Digital_IO(15 downto 0)(7 downto 0)
		);
	end component;

	component sound_card
		-- port ();
	end component;

	-------------------------------
	-- Signals
	-------------------------------
	-- Clock Signal
	signal clk_40MHz: std_logic := '0';  -- 40 MHz clock
	signal clk_25MHz: std_logic := '0';  -- 25.17857 MHz clock
	signal clk: std_logic := '0';

	-- Bus signals
	signal data_bus: std_logic_vector(7 downto 0);
	signal addr_bus: std_logic_vector(15 downto 0);
	signal state: t_Bus_States;

	-- I/O signals
	signal io_ports: t_Digital_IO(15 downto 0)(7 downto 0) := (others => x"00");

	-- Other signals
	signal rdy: std_logic;
	signal rst: std_logic := '0';

	-- State
	signal current_state: t_Console_States := RESET;
	signal next_state: t_Console_States;

begin
	-- Configure which VGA clock we are using based upon the selected
	-- resolution
	with RESOLUTION.pixel_freq select
		clk <= clk_25MHz when 25175e3,
			clk_40MHz when 40e6,
			'0' when others;

	-------------------------------
	-- Component Implementations
	-------------------------------
	CLK_WIZ: clk_wiz_0
		port map (
			-- Clock in ports
			clk_in1 => clk_12MHz,
			-- Clock out ports
			clk_40MHz => clk_40MHz,
			clk_25MHz => clk_25MHz,
			-- Statu and control signals
			resetn => rst
		);

	CPU_1: cpu
		port map (
			clk => clk,
			rst => rst,
			data => data_bus,
			addr => addr_bus,
			state => state,
			rdy => rdy
		);

	VGA_CARD: video_card
		generic map (
			RESOLUTION => VGA_640_480_60,
			X_DIV => 2,
			Y_DIV => 2,
			REG_ADDR_MIN => VC_REG_MIN,
			REG_ADDR_MAX => VC_REG_MAX
		)
		port map (
			clk => clk,
			rst => rst,
			data => data_bus,
			addr => addr_bus,
			state => state,
			rdy => rdy,
			vgaRed => vgaRed,
			vgaGreen => vgaGreen,
			vgaBlue => vgaBlue,
			hsync => hsync,
			vsync => vsync
		);

	MEM: memory
		generic map (
			IO_DIR => x"0000"
		)
		port map (
			clk => clk,
			rst => rst,
			data => data_bus,
			addr => addr_bus,
			state => state,
			io_ports => io_ports
		);

	APU: sound_card;

	-------------------------------
	-- Module Implementation
	-------------------------------
	io_ports(0)(0) <= toggle_btn;

	STATE_MEMORY: process (clk, rst)
	begin
		if (rst = '0') then
			current_state <= RESET;
		elsif (rising_edge(clk)) then
			current_state <= next_state;
		end if;
	end process;

	CONSOLE_PROC: process (current_state, clk, rst_btn)
		variable cnt: integer := 0;
	begin
		if (rising_edge(clk)) then
			if (rst_btn = '1') then
				next_state <= SHUTDOWN;
			else
				case (current_state) is
					when RESET =>
						rst <= '1';
						cnt := 0;
						next_state <= START;
					when START =>
						cnt := cnt + 1;
						if (cnt >= 2) then
							next_state <= EXECUTE;
						else
							next_state <= START;
						end if;
					when EXECUTE =>
						cnt := 0;
						next_state <= EXECUTE;
					when SHUTDOWN =>
						cnt := cnt + 1;
						if (cnt >= 2) then
							rst <= '0';
							next_state <= RESET;
						else
							next_state <= SHUTDOWN;
						end if;
					when others =>
						next_state <= RESET;
				end case;
			end if;
		end if;
	end process;

end console_arch;
