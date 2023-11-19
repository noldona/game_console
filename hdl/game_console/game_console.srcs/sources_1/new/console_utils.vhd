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
--
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
	constant PORT_00: integer := 0;
	constant PORT_01: integer := 1;
	constant PORT_02: integer := 2;
	constant PORT_03: integer := 3;
	constant PORT_04: integer := 4;
	constant PORT_05: integer := 5;
	constant PORT_06: integer := 6;
	constant PORT_07: integer := 7;
	constant PORT_08: integer := 8;
	constant PORT_09: integer := 9;
	constant PORT_10: integer := 10;
	constant PORT_11: integer := 11;
	constant PORT_12: integer := 12;
	constant PORT_13: integer := 13;
	constant PORT_14: integer := 14;
	constant PORT_15: integer := 15;

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
		for i in 0 to ram_depth - 1 loop
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
