-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/29/2023 11:24:47 AM
-- Design Name: Random Access Memory
-- Module Name: ram - ram_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This is a single-port RAM
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


entity ram is
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
end ram;

architecture ram_arch of ram is
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
	signal RAM: t_Ram_Array(START_ADDRESS to END_ADDRESS)(7 downto 0)
		:= init_ram_from_file_or_zeros(START_ADDRESS, END_ADDRESS, INIT_FILE);

	signal data_tx: std_logic_vector(7 downto 0);
	signal data_rx: std_logic_vector(7 downto 0);
	signal EN: std_logic;

begin
	-------------------------------
	-- Component Implementations
	-------------------------------

	-------------------------------
	-- Module Implementation
	-------------------------------
	data_rx <= data;
	data_tx <= BUS_HIGH_Z when
		(to_integer(unsigned(addr)) < START_ADDRESS or
		(to_integer(unsigned(addr)) > END_ADDRESS)) else
		RAM(to_integer(unsigned(addr)));

	ENABLE: process (addr)
	begin
		if (to_integer(unsigned(addr)) >= START_ADDRESS and
				to_integer(unsigned(addr)) <= END_ADDRESS) then
			EN <= '1';
		else
			EN <= '0';
		end if;
	end process;

	RAM_PROC: process (clk, rst)
	begin
		if (rst = '0') then
			if (READ_ONLY = '0') then
				RAM <= (others => (others => '0'));
			end if;
			data <= BUS_HIGH_Z;
		elsif (state = OFF) then
			data <= BUS_HIGH_Z;
		else
			if (rising_edge(clk)) then
				if (state = WRITE and READ_ONLY = '0' and EN = '1') then
					RAM(to_integer(unsigned(addr))) <= data_rx;
				end if;
				data <= data_tx when (state = READ and EN = '1') else BUS_HIGH_Z;
			end if;
		end if;
	end process;

end ram_arch;
