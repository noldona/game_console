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
	generic (
		IO_DIR: std_logic_vector(0 to 15) := x"0000"
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		data: inout std_logic_vector(7 downto 0);
		addr: in std_logic_vector(15 downto 0);
		state: in t_Bus_State;
		io_ports: inout t_Digital_IO(15 downto 0)(7 downto 0)
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

	component io
		generic (
			START_ADDRESS: integer := 16#0000#;
			IO_DIR: std_logic_vector(0 to 15)
		);
		port (
			clk : in std_logic;
			rst : in std_logic;
			state : in t_Bus_State;
			addr : in std_logic_vector (15 downto 0);
			data : inout std_logic_vector (7 downto 0);
			io_ports: inout t_Digital_IO(15 downto 0)(7 downto 0)
		);
	end component;

	-------------------------------
	-- Signals
	-------------------------------

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
			data => data
		);

	CART_1: ram
		generic map (
			START_ADDRESS => CART_ADDR_MIN,
			END_ADDRESS => CART_ADDR_MAX,
			INIT_FILE => "prg.mif",
			READ_ONLY => '1'
		)
		port map (
			clk => clk,
			rst => rst,
			state => state,
			addr => addr,
			data => data
		);

	IO_1: io
		generic map (
			START_ADDRESS => APU_REG_MIN,
			IO_DIR => IO_DIR
		)
		port map (
			clk => clk,
			rst => rst,
			state => state,
			addr => addr,
			data => data,
			io_ports => io_ports
		);

	-------------------------------
	-- Module Implementation
	-------------------------------

end memory_arch;
