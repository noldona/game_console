-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/14/2023 04:14:28 PM
-- Design Name: Video Card Memory Mapper
-- Module Name: memory_mapper - memory_mapper_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This will map the addr_x and addr_y values to appropriate
-- 		memory locations with possible offset for the VRAM
--
-- Dependencies:
-- 		Game Console Utilities
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


entity memory_mapper is
	generic (
		OFFSET: integer := 0;
		X_MAX: integer := 16#640#;
		Y_MAX: integer := 16#480#;
		X_DIV: integer := 2;
		Y_DIV: integer := 2
	);
	port (
		clk: in std_logic;
		addr_x: in std_logic_vector(15 downto 0);
		addr_y: in std_logic_vector(15 downto 0);
		hblank: in std_logic;
		vblank: in std_logic;
		rdy: in std_logic;
		addr: out std_logic_vector(15 downto 0)
	);
end memory_mapper;

architecture memory_mapper_arch of memory_mapper is
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

	-------------------------------
	-- Signals
	-------------------------------
	signal temp: std_logic_vector(31 downto 0);

begin
	-------------------------------
	-- Component Implementations
	-------------------------------

	-------------------------------
	-- Module Implementation
	-------------------------------
	temp <= std_logic_vector((((unsigned(addr_y) / Y_DIV) * (x_max)) + ((unsigned(addr_x) - 1) / X_DIV) + OFFSET));
	addr <= temp(15 downto 0);

end memory_mapper_arch;
