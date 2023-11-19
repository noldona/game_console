-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/29/2023 11:24:47 AM
-- Design Name: Memory
-- Module Name: memory - memory_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This handles the connecting all of the various memory addresses
--
-- Dependencies:
-- 		Game Console Utilities
--
-- Revision: 0.1.0
-- Revision 0.1.0 - File Created
-- Additional Comments:
-- 		Memory Map
-- 		+--------------------------------------------------------------------+
-- 		|   Address Range   |   Size   |  Device                             |
-- 		+--------------------------------------------------------------------+
-- 		|  0x0000 - 0x00FF  |  0x0100  |  Zero Page RAM                      |
-- 		+--------------------------------------------------------------------+
-- 		|  0x0100 - 0x01FF  |  0x0100  |  Stack RAM                          |
-- 		+--------------------------------------------------------------------+
-- 		|  0x0200 - 0x1FFF  |  0x1E00  |  Working RAM                        |
-- 		+--------------------------------------------------------------------+
-- 		|  0x2000 - 0x3FFF  |  0x2000  |  Video Card Register                |
-- 		+--------------------------------------------------------------------+
-- 		|  0x4000 - 0x401F  |  0x0020  |  APU and I/O Registers              |
-- 		+--------------------------------------------------------------------+
-- 		|  0x4020 - 0xFFFF  |  0xBFE0  | Cartigate Space: PRG ROM, PRG RAM,  |
-- 		|                   |          | Mapper Registers                    |
-- 		+--------------------------------------------------------------------+
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use WORK.CONSOLE_UTILS.ALL;


entity memory is
	port (
		clk: in std_logic;
		rst: in std_logic;
		data: inout std_logic_vector(7 downto 0);
		addr: in std_logic_vector(15 downto 0);
		state: in t_Bus_State;
		io: inout t_Digital_IO(0 to 15)(7 downto 0)
	);
end memory;

architecture memory_arch of memory is
	-------------------------------
	-- Functions
	-------------------------------

	-------------------------------
	-- Types
	-------------------------------

	-------------------------------
	-- Constants
	-------------------------------
	constant RAM_ADDR_MIN: integer := 16#0000#;
	constant RAM_ADDR_MAX: integer := 16#1FFF#;
	constant VC_REG_MIN: integer := 16#2000#;
	constant VC_REG_MAX: integer := 16#3FFF#;
	constant APU_REG_MIN: integer := 16#4000#;
	constant APU_REG_MAX: integer := 16#401F#;
	constant CART_ADDR_MIN: integer := 16#4020#;
	constant CART_ADDR_MAX: integer := 16#FFFF#;

	-------------------------------
	-- Components
	-------------------------------
	component ram
		generic (
			START_ADDRESS: integer := 16#0000#;
			END_ADDRESS: integer := 16#FFFFF#;
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
	signal io_dir: std_logic_vector(0 to 15);
	signal io_data_tx: t_Digital_IO(0 to 15)(7 downto 0);
	signal io_data_rx: t_Digital_IO(0 to 15)(7 downto 0);
	signal rom_data: std_logic_vector(7 downto 0);
	signal ram_data: std_logic_vector(7 downto 0);
	signal data_tx: std_logic_vector(7 downto 0);
	signal data_rx: std_logic_vector(7 downto 0);

	signal int_addr: integer;

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	RAM_1: ram
		generic map (
			START_ADDRESS => RAM_ADDR_MIN,
			END_ADDRESS => RAM_ADDR_MAX,
			INIT_FILE => "",
			READ_ONLY => '0'
		)
		port map (
			clk => clk,
			rst => rst,
			state => state,
			addr => addr,
			data => ram_data
		);

	CART_1: ram
		generic map (
			START_ADDRESS => CART_ADDR_MIN,
			END_ADDRESS => CART_ADDR_MAX,
			INIT_FILE => "prg.bin",
			READ_ONLY => '1'
		)
		port map (
			clk => clk,
			rst => rst,
			state => state,
			addr => addr,
			data => ram_data
		);

	-------------------------------
	-- Module Implementation
	-------------------------------
	int_addr <= to_integer(unsigned(addr));

--	-- Handle output on the IO Ports
--	IO_PROC: process (clk, rst)
--	begin
--		if (rst = '0') then
--			io <= (others => x"00");
--		elsif (rising_edge(clk)) then
--			if ((int_addr >= IO_ADDR_MIN) and
--					(int_addr <= IO_ADDR_MAX) and
--					dir = '1') then
--				io(int_addr - IO_ADDR_MIN) <= data_rx when (io_dir(int_addr - IO_ADDR_MIN) = '1') else
--					"ZZZZZZZZ";
--			end if;
--		end if;
--	end process;

--	-- Handle putting data on the bus from various sources
--	DATA_PROC: process (addr, rom_data, ram_data, io)
--	begin
--		-- If in ROM memory addresses
--		if ((to_integer(unsigned(addr)) >= PRG_ADDR_MIN) and
--				(to_integer(unsigned(addr)) <= PRG_ADDR_MAX)) then
--			data_tx <= rom_data;
--		-- If in RAM memory addresses
--		elsif ((to_integer(unsigned(addr)) >= RAM_ADDR_MIN) and
--				(to_integer(unsigned(addr)) <= RAM_ADDR_MAX)) then
--			data_tx <= ram_data;
--		-- If in IO Port addresses
--		elsif ((to_integer(unsigned(addr)) >= IO_ADDR_MIN) and
--				(to_integer(unsigned(addr)) <= IO_ADDR_MAX)) then
--			data_tx <= io(to_integer(unsigned(addr)) - IO_ADDR_MIN);
--		else
--			data_tx <= "ZZ";
--		end if;
--	end process;

end memory_arch;
