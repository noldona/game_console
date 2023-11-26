-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/29/2023 11:24:47 AM
-- Design Name: Game Console Utilities
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This defines some utilities for use in the project
--
-- Dependencies: None
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
use STD.TEXTIO.ALL;


package console_utils is
	-----------------------------------------------
	-- Type Definitions
	-----------------------------------------------
	type t_Digital_IO is array(natural range <>) of std_logic_vector;
	type t_Ram_Array is array(natural range <>) of std_logic_vector;
	type t_Bus_State is (OFF, READ, WRITE);

	-----------------------------------------------
	-- Constant Definitions
	-----------------------------------------------
	-- I/O Port Definitions
	constant CONTROLLER_1_UP: integer := 0;
	constant CONTROLLER_1_DOWN: integer := 1;
	constant CONTROLLER_1_LEFT: integer := 2;
	constant CONTROLLER_1_RIGHT: integer := 3;
	constant CONTROLLER_1_BUTTON_1: integer := 4;
	constant CONTROLLER_1_BUTTON_2: integer := 5;
	constant CONTROLLER_1_X_AXIS: integer := 6;
	constant CONTROLLER_1_Y_AXIS: integer := 7;
	constant CONTROLLER_2_UP: integer := 8;
	constant CONTROLLER_2_DOWN: integer := 9;
	constant CONTROLLER_2_LEFT: integer := 10;
	constant CONTROLLER_2_RIGHT: integer := 11;
	constant CONTROLLER_2_BUTTON_1: integer := 12;
	constant CONTROLLER_2_BUTTON_2: integer := 13;
	constant CONTROLLER_2_X_AXIS: integer := 14;
	constant CONTROLLER_2_Y_AXIS: integer := 15;

	-- Memory Map Constants
	constant RAM_ADDR_MIN: integer := 16#0000#;
	constant RAM_ADDR_MAX: integer := 16#1FFF#;
	constant VC_REG_MIN: integer := 16#2000#;
	-- Temporarily using this till more registers are implemented for
	-- the video card
	constant VC_REG_MAX: integer := 16#2000#;
	-- constant VC_REG_MAX: integer := 16#3FFF#;
	constant APU_REG_MIN: integer := 16#4000#;
	constant APU_REG_MAX: integer := 16#401F#;
	constant CART_ADDR_MIN: integer := 16#4020#;
	constant CART_ADDR_MAX: integer := 16#FFFF#;

	-- Bus Constants
	constant BUS_HIGH_Z: std_logic_vector(7 downto 0) := "ZZZZZZZZ";

	-----------------------------------------------
	-- Function Definitions
	-----------------------------------------------
	impure function init_ram_hex(start: integer; stop: integer; filename: string) return t_Ram_Array;
	impure function init_ram_from_file_or_zeros(start: integer; stop: integer; filename: string) return t_Ram_Array;

end package;

package body console_utils is
	-------------------------------
	-- Functions
	-------------------------------
	impure function init_ram_hex(start: integer; stop: integer; filename: string) return t_Ram_Array is
		file text_file: text open read_mode is filename;
		variable text_line: line;
		variable ram_content: t_Ram_Array(start to stop)(7 downto 0);
		variable ram_depth: integer := stop - start;
	begin
		report "'" & filename & "'" severity note;
		for i in 0 to ram_depth loop
			readline(text_file, text_line);
			hread(text_line, ram_content(i + start));
		end loop;

		return ram_content;
	end function;

	impure function init_ram_from_file_or_zeros(start: integer; stop: integer; filename: string) return t_Ram_Array is
		variable ram: t_Ram_Array(start to stop)(7 downto 0);
	begin
		if (filename = "") then
			ram := (others => x"00");
			return ram;
		else
			return init_ram_hex(start, stop, filename);
		end if;
	end function;

end package body console_utils;
