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
-- 		Test Utilities
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
use WORK.TEST_UTILS.ALL;


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
	constant CLK_HZ: integer := 25178570;  -- 12.17857 MHz
	constant CLK_PERIOD: time := 1 sec / clk_hz;
	constant RESOLUTION: t_VGA := VGA_640_480_60;
	constant X_DIV: integer := 2;
	constant Y_DIV: integer := 2;

	-------------------------------
	-- Components
	-------------------------------
	component video_card
		generic (
			RESOLUTION: t_VGA := RESOLUTION;
			X_DIV: integer := X_DIV;
			Y_DIV: integer := Y_DIV;
			REG_ADDR_MIN: integer;
			REG_ADDR_MAX: integer
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			data: inout std_logic_vector(7 downto 0);
			addr: in std_logic_vector(15 downto 0);
			state: in t_Bus_State;
			rdy: in std_logic;
			vgaRed: out std_logic_vector(2 downto 0);
			vgaGreen: out std_logic_vector(2 downto 0);
			vgaBlue: out std_logic_vector(1 downto 0);
			hsync: out std_logic;
			vsync: out std_logic
		);
	end component;

	component sync_counter_tb
		-- port ();
	end component;

	component ram_tb
		-- port ();
	end component;

	component reg_tb
		-- port ();
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
			state: in t_Bus_State;
			addr: in std_logic_vector(15 downto 0);
			data: inout std_logic_vector(7 downto 0)
		);
	end component;

	-------------------------------
	-- Signals
	-------------------------------
	-- Video Card Signals
	signal clk: std_logic := '0';
	signal rst: std_logic := '0';
	signal data: std_logic_vector(7 downto 0) := BUS_HIGH_Z;
	signal addr: std_logic_vector(15 downto 0) := x"0000";
	signal state: t_Bus_State := READ;
	signal rdy: std_logic := '1';
	signal vgaRed: std_logic_vector(2 downto 0);
	signal vgaGreen: std_logic_vector(2 downto 0);
	signal vgaBlue: std_logic_vector(1 downto 0);
	signal hsync: std_logic;
	signal vsync: std_logic;

	-- VRAM signals
	signal ram_clk: std_logic := '0';
	signal ram_rst: std_logic := '1';
	signal ram_addr: std_logic_vector(15 downto 0) := x"0000";
	signal ram_data: std_logic_vector(7 downto 0) := BUS_HIGH_Z;

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	UUT: video_card
		generic map (
			RESOLUTION => VGA_640_480_60,
			X_DIV => 2,
			Y_DIV => 2,
			REG_ADDR_MIN => 16#2000#,
			REG_ADDR_MAX => 16#2000#
		)
		port map(
			clk => clk,
			rst => rst,
			data => data,
			addr => addr,
			state => state,
			rdy => rdy,
			vgaRed => vgaRed,
			vgaGreen => vgaGreen,
			vgaBlue => vgaBlue,
			hsync => hsync,
			vsync => vsync
		);

	-- Submodule Test Benches
	SYNC_COUNTER_UUT: sync_counter_tb;
	RAM_UUT: ram_tb;
	REG_UUT: reg_tb;

	VRAM_1: ram
		generic map (
			START_ADDRESS => 16#0000#,
			END_ADDRESS => 16#7FFF#,
			INIT_FILE => "../../sources_1/new/image_1.mif",
			READ_ONLY => '1'
		)
		port map (
			clk => ram_clk,
			rst => ram_rst,
			state => READ,
			addr => ram_addr,
			data => ram_data
		);

	VRAM_2: ram
		generic map (
			START_ADDRESS => 16#8000#,
			END_ADDRESS => 16#FFFF#,
			INIT_FILE => "../../sources_1/new/image_2.mif",
			READ_ONLY => '1'
		)
		port map (
			clk => ram_clk,
			rst => ram_rst,
			state => READ,
			addr => ram_addr,
			data => ram_data
		);

	-------------------------------
	-- Module Implementation
	-------------------------------
	CLK_PROC: process
	begin
		wait for CLK_PERIOD / 2;
		if (clk = '1') then
			clk <= '0';
		else
			clk <= '1';
		end if;
	end process;

	VGA_TEST: process
		variable red: std_logic_vector(2 downto 0);
		variable green: std_logic_vector(2 downto 0);
		variable blue: std_logic_vector(1 downto 0);
		variable blank: std_logic;
	begin
		-- Test Reset State
		report "VGA Module: Reset Test: Begin" severity note;
		wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
		assert_equals(vgaRed, "000", "VGA Module", "Reset Test", "vgaRed");
		assert_equals(vgaGreen, "000", "VGA Module", "Reset Test", "vgaGreen");
		assert_equals(vgaBlue, "00", "VGA Module", "Reset Test", "vgaBlue");
		assert_equals(hsync, '1', "VGA Module", "Reset Test", "hsync");
		assert_equals(vsync, '1', "VGA Module", "Reset Test", "vsync");
		rst <= '1';  -- Take out of reset mode
		wait for CLK_PERIOD;  -- Wait 1 clock cycle before changing data
		report "VGA Module: Reset Test: End" severity note;

		-- Test Register Write/Read
		report "VGA Module: Register Test: Begin" severity note;
		state <= WRITE;  -- Put in WRITE mode
		addr <= x"2000";  -- Set address to Video Card Register
		data <= x"80";  -- Set address to VRAM 2 base address
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		data <= BUS_HIGH_Z;  --Reset data for preparation of the next assert
		state <= READ;  -- Put into READ mode
		wait for CLK_PERIOD;  -- Wait 1 clock cycle data to be read
		assert_equals(data, x"80", "VGA Module", "Register Test", "data");
		report "VGA Module: Register Test: End" severity note;

		-- Test Image 2 Display
		report "VGA Module: Image 2 Test: Begin" severity note;
		rst <= '0';  -- Reset counters back to 0
		state <= WRITE;  -- Put in WRITE mode
		addr <= x"2000";  -- Set address to Video Card Register
		data <= x"80";  -- Set address to VRAM 2 base address
		wait for CLK_PERIOD;  -- Wait 1 clock cycle
		rst <= '1';  -- Take out of reset mode
		for y in 0 to RESOLUTION.vsync.total loop
			for x in 0 to RESOLUTION.hsync.total loop
				-- Set RAM address to current pixel
				blank := '1' when (x > RESOLUTION.hsync.active or y > RESOLUTION.vsync.active) else '0';
				ram_addr <= std_logic_vector(to_unsigned((((y / Y_DIV) * RESOLUTION.hsync.active) +
					(x / X_DIV)  + 16#8000#), 16));
				ram_clk <= '1';  -- Toggle the RAM clock on to load the value
				wait for CLK_PERIOD / 2;
				-- Get color for the pixel
				red := "000" when (blank = '1') else ram_data(7 downto 5);
				green := "000" when (blank = '1') else ram_data(4 downto 2);
				blue := "00" when (blank = '1') else ram_data(1 downto 0);
				ram_clk <= '0';  -- Toggle the RAM clock off for next cycle
				wait for CLK_PERIOD / 2;  -- Wait 1 clock cycle
				assert_equals(vgaRed, red, "VGA Module", "Image 2 Test", "vgaRed");
				assert_equals(vgaGreen, green, "VGA Module", "Image 2 Test", "vgaGreen");
				assert_equals(vgaBlue, blue, "VGA Module", "Image 2 Test", "vgaBlue");
			end loop;
		end loop;
		report "VGA Module: Image 2 Test: End" severity note;

		-- Test Image 2 Display
		report "VGA Module: Image 1 Test: Begin" severity note;
		rst <= '0';  -- Reset counters back to 0
		wait for CLK_PERIOD;  -- Wait 1 clock cycle
		rst <= '1';  -- Take out of reset mode
		wait for CLK_PERIOD;  -- Wait 1 clock cycle before changing data
		state <= WRITE;  -- Put in WRITE mode
		addr <= x"2000";  -- Set address to Video Card Register
		data <= x"80";  -- Set address to VRAM 2 base address
		wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
		rst <= '0';  -- Reset counters back to 0
		wait for CLK_PERIOD;  -- Wait 1 clock cycle
		rst <= '1';  -- Take out of reset mode
		for y in 0 to RESOLUTION.vsync.total loop
			for x in 0 to RESOLUTION.hsync.total loop
				-- Set RAM address to current pixel
				blank := '1' when (x > RESOLUTION.hsync.active or y > RESOLUTION.vsync.active) else '0';
				ram_addr <= std_logic_vector(to_unsigned(((y / Y_DIV) * RESOLUTION.hsync.active) +
					(x / X_DIV), 16));
				ram_clk <= '1';  -- Toggle the RAM clock on to load the value
				wait for CLK_PERIOD / 2;
				-- Get color for the pixel
				red := "000" when (blank = '1') else ram_data(7 downto 5);
				green := "000" when (blank = '1') else ram_data(4 downto 2);
				blue := "00" when (blank = '1') else ram_data(1 downto 0);
				ram_clk <= '0';  -- Toggle the RAM clock off for next cycle
				wait for CLK_PERIOD / 2;  -- Wait 1 clock cycle
				assert_equals(vgaRed, red, "VGA Module", "Image 1 Test", "vgaRed");
				assert_equals(vgaGreen, green, "VGA Module", "Image 1 Test", "vgaGreen");
				assert_equals(vgaBlue, blue, "VGA Module", "Image 1 Test", "vgaBlue");
			end loop;
		end loop;
		report "VGA Module: Image 1 Test: End" severity note;
		wait;
	end process;

end video_card_tb_arch;
