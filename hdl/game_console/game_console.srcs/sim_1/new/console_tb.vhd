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
-- 		Test Utilities
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
use WORK.TEST_UTILS.ALL;


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
	constant CLK_12MHZ: integer := 12e6;  -- 12 MHz
	constant CLK_12MHz_PERIOD: time := 1 sec / CLK_12MHZ;
	constant CLK_25MHz: integer := 25178570;  -- 25.17857 MHz
	constant CLK_25MHz_PERIOD: time := 1 sec / CLK_25MHz;

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
			hsync: out std_logic;
			vsync: out std_logic;

			-- Memory Ports
			-- TODO: Add ports for controllers
			toggle_btn: in std_logic

			-- Sound Card Ports
			-- TODO: Add ports for audio out
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
	signal clk: std_logic := '0';
	signal rst_btn: std_logic := '0';
	signal vgaRed: std_logic_vector(2 downto 0);
	signal vgaGreen: std_logic_vector(2 downto 0);
	signal vgaBlue: std_logic_vector(1 downto 0);
	signal hsync: std_logic;
	signal vsync: std_logic;
	signal toggle_btn: std_logic;

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	UUT: console
		port map (
			clk_12MHz => clk,
			rst_btn => rst_btn,
			vgaRed => vgaRed,
			vgaGreen => vgaGreen,
			vgaBlue => vgaBlue,
			hsync => hsync,
			vsync => vsync,
			toggle_btn => toggle_btn
		);

	-- Submodule Test Benches
	-- Commented in case of interference
	-- CPU_UUT: cpu_tb;
	-- VGA_UUT: video_card_tb;
	-- MEM_UUT: memory_tb;
	-- APU_UUT: sound_card_tb;

	-------------------------------
	-- Module Implementation
	-------------------------------
	CLK_PROC: process
	begin
		wait for CLK_12MHz_PERIOD / 2;
		if (clk = '1') then
			clk <= '0';
		else
			clk <= '1';
		end if;
	end process;

	CONSOLE_TEST: process
		alias UUT_clk is <<signal UUT.clk: std_logic>>;
		alias UUT_current_state is <<signal UUT.current_state: t_Console_States>>;
		alias UUT_next_state is <<signal UUT.next_state: t_Console_States>>;
		alias UUT_rst is <<signal UUT.rst: std_logic>>;
		alias UUT_addr_bus is <<signal UUT.addr_bus: std_logic_vector(15 downto 0)>>;
		alias UUT_data_bus is <<signal UUt.data_bus: std_logic_vector(7 downto 0)>>;
		alias UUT_state is <<signal UUT.state: t_Bus_States>>;
	begin
		-- Test Reset State
		report "Console Module: Reset Test: Begin" severity note;
			wait until falling_edge(UUT_clk);
			assert_equals(UUT_current_state, RESET, "Console Module", "Reset Test", "UUT_current_state");
			assert_equals(UUT_rst, '1', "Console Module", "Execute Test", "UUT_rst");
			assert_equals(UUT_next_state, START, "Console Module", "Reset Test", "UUT_next_state");
			wait until falling_edge(UUT_clk);
		report "Console Module: Reset Test: End" severity note;

		report "Console Module: Startup Test: Begin" severity note;
			assert_equals(UUT_current_state, START, "Console Module", "Startup Test", "UUT_current_state");
			assert_equals(UUT_next_state, START, "Console Module", "Startup Test", "UUT_next_state");
			wait until falling_edge(UUT_clk);
			assert_equals(UUT_current_state, START, "Console Module", "Startup Test", "UUT_current_state");
			assert_equals(UUT_next_state, START, "Console Module", "Startup Test", "UUT_next_state");
			wait until falling_edge(UUT_clk);
			assert_equals(UUT_current_state, START, "Console Module", "Startup Test", "UUT_current_state");
			assert_equals(UUT_next_state, EXECUTE, "Console Module", "Startup Test", "UUT_next_state");
			wait until falling_edge(UUT_clk);
		report "Console Module: Startup Test: End" severity note;

		report "Console Module: Execute Test: Begin" severity note;
			assert_equals(UUT_current_state, EXECUTE, "Console Module", "Execute Test", "UUT_current_state");
			assert_equals(UUT_next_state, EXECUTE, "Console Module", "Execute Test", "UUT_next_state");
			wait for CLK_25MHz_PERIOD * (17 + 9 + 6 + 15);  -- Run through the program once without toggle
			assert_equals(UUT_addr_bus, x"4020", "Console Module", "Execute Test", "UUT_addr_bus");
			toggle_btn <= '1';
			wait for CLK_25MHz_PERIOD * (17 + 9 + 6 + 7 + 9 + 16 + 15);  -- RUn through the program again with toggle
			assert_equals(UUT_addr_bus, x"4020", "Console Module", "Execute Test", "UUT_addr_bus");
		report "Console Module: Execute Test: End" severity note;

		report "Console Module: Shutdown Test: Begin" severity note;
			rst_btn <= '1';
			wait for 100ns;  -- Wait for button press to get detected
			rst_btn <= '0';
			assert_equals(UUT_next_state, SHUTDOWN, "Console Module", "Shutdown Test", "UUT_next_state");
			wait until falling_edge(UUT_clk);
			wait until falling_edge(UUT_clk);
			wait until falling_edge(UUT_clk);
			assert_equals(UUT_current_state, RESET, "Console Module", "Shutdown Test", "UUT_current_state");
			assert_equals(UUT_rst, '0', "Console Module", "Shutdown Test", "UUT_rst");
			assert_equals(UUT_next_state, RESET, "Console Module", "Shutdown Test", "UUT_next_state");
		report "Console Module: Shutdown Test: End" severity note;

		wait;
	end process;

end console_tb_arch;
