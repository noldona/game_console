-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/19/2023 03:55:39 PM
-- Design Name: Random Access Memory Test bench
-- Module Name: ram_tb - ram_tb_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a test bench for the Random Accesss Memory module
--
-- Dependencies:
-- 		Game Console Utilities
-- 		Test Utilities
-- 		Random Access Memory
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
use WORK.TEST_UTILS.ALL;


entity ram_tb is
	--  port ();
end ram_tb;

architecture ram_tb_arch of ram_tb is
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
	constant CLK_PERIOD: time := 1 sec / CLK_HZ;

	-------------------------------
	-- Components
	-------------------------------
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
	-- RAM Signals
	signal ram_clk: std_logic := '0';
	signal ram_rst: std_logic := '0';
	signal ram_state: t_Bus_State := OFF;
	signal ram_addr: std_logic_vector(15 downto 0) := x"0000";
	signal ram_data: std_logic_vector(7 downto 0) := BUS_HIGH_Z;

	-- ROM Signals
	signal rom_clk: std_logic := '0';
	signal rom_rst: std_logic := '0';
	signal rom_state: t_Bus_State := OFF;
	signal rom_addr: std_logic_vector(15 downto 0) := x"0000";
	signal rom_data: std_logic_vector(7 downto 0) := BUS_HIGH_Z;

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	UUT_RAM: ram
		generic map (
			START_ADDRESS => 16#0000#,
			END_ADDRESS => 16#00FF#,
			INIT_FILE => "",
			READ_ONLY => '0'
		)
		port map (
			clk => ram_clk,
			rst => ram_rst,
			state => ram_state,
			addr => ram_addr,
			data => ram_data
		);

	UUT_ROM: ram
		generic map (
			START_ADDRESS => 16#0000#,
			END_ADDRESS => 16#00FF#,
			INIT_FILE => "test.mif",
			READ_ONLY => '1'
		)
		port map (
			clk => rom_clk,
			rst => rom_rst,
			state => rom_state,
			addr => rom_addr,
			data => rom_data
		);

	-------------------------------
	-- Module Implementation
	-------------------------------
	RAM_CLK_PROC: process
	begin
		wait for CLK_PERIOD / 2;
		if (ram_clk = '1') then
			ram_clk <= '0';
		else
			ram_clk <= '1';
		end if;
	end process;

	ROM_CLK_PROC: process
	begin
		wait for CLK_PERIOD / 2;
		if (rom_clk = '1') then
			rom_clk <= '0';
		else
			rom_clk <= '1';
		end if;
	end process;

	RAM_TEST: process
	begin
		-- Test Reset State
		report "RAM Module: Reset Test: Begin" severity note;
			wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
			assert_equals(ram_data, BUS_HIGH_Z, "RAM Module", "Reset Test", "ram_data");
			assert ram_data = BUS_HIGH_Z
				report "RAM Test: Reset Test - Invalid 'data' value, " &
					"Expected: 'ZZZZZZZZ' but got '" &
					to_hstring(ram_data) &
					"'"
				severity error;
			ram_rst <= '1';  -- Take out of reset mode
			wait for CLK_PERIOD;  -- Wait 1 clock cycle before changing data
			report "RAM Module: Reset Test: End" severity note;

			-- Test Writing/Reading
			report "RAM Module: Write/Read Test: Begin" severity note;
			-- Set the data
			ram_state <= WRITE;  -- Put in WRITE mode
			ram_addr <= x"0088";  -- Set address to write to
			ram_data <= x"FF";  -- Set data to write
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
			ram_data <= BUS_HIGH_Z;  -- Reset data for prepartion of the next assert
			ram_state <= READ;  -- Put into READ mode
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be read
			assert_equals(ram_data, x"FF", "RAM Module", "Write/Read Test", "ram_data");
		report "RAM Module: Write/Read Test: End" severity note;

		-- Test Index Out of Range
		report "RAM Module: Index Out of Range Test: Begin" severity note;
			ram_addr <= x"0100";  -- Set address out of range
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
			assert_equals(ram_data, BUS_HIGH_Z, "RAM Module", "Index Out of Range Test", "ram_data");
			report "RAM Module: Index Out of Range Test: End" severity note;

			-- Test Off State
			report "RAM Module: Off Test: Begin" severity note;
			ram_state <= OFF;  -- Set state to OFF mode
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for output to update
			assert_equals(ram_data, BUS_HIGH_Z, "RAM Module", "Off Test", "ram_data");
		report "RAM Module: Off Test: End" severity note;

		wait;
	end process;

	ROM_TEST: process
	begin
		-- Test Reset State
		report "ROM Module: Reset Test: Begin" severity note;
			wait for CLK_PERIOD * 5;  -- Wait 5 clock cycles
			assert_equals(rom_data, BUS_HIGH_Z, "ROM Module", "Reset Test", "rom_data");
			rom_rst <= '1';  -- Take out of reset mode
			report "ROM Module: Reset Test: End" severity note;

			-- Test Writing/Reading
			report "ROM Module: Write/Read Test: Begin" severity note;
			wait for CLK_PERIOD;  -- Wait 1 clock cycle before changing data
			-- Set the data
			rom_state <= WRITE;  -- Put in WRITE mode
			rom_addr <= x"0088";  -- Set address to write to
			rom_data <= x"FF";  -- Set data to write
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be written
			rom_data <= BUS_HIGH_Z;  -- Reset data for prepartion of the next assert
			rom_state <= READ;  -- Put into READ mode
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for data to be read
			assert_equals(rom_data, x"88", "ROM Module", "Write/Read Test", "rom_data");
		report "ROM Module: Write/Read Test: End" severity note;

		-- Test Off State
		report "ROM Module: Off Test: Begin" severity note;
			rom_state <= OFF;  -- Set state to OFF mode
			wait for CLK_PERIOD;  -- Wait 1 clock cycle for output to update
			assert_equals(rom_data, BUS_HIGH_Z, "ROM Module", "Off Test", "rom_data");
		report "ROM Module: Off Test: End" severity note;

		-- Test File Load
		report "ROM Module: File Load Test: Begin" severity note;
			wait for CLK_PERIOD;
			for i in 0 to 255 loop
				rom_state <= READ;
				rom_addr <= std_logic_vector(to_unsigned(i, 16));
				wait for CLK_PERIOD;
				assert_equals(rom_data, std_logic_vector(to_unsigned(i, 8)), "ROM Module", "File Load Test", "rom_data");
			end loop;
		report "ROM Module: File Load Test: End" severity note;

		wait;
	end process;

end ram_tb_arch;
