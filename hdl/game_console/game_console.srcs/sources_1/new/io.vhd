-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 11/25/2023 02:46:44 PM
-- Design Name: Input/Output Ports
-- Module Name: io - io_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This module handles the I/O ports of the system
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


entity io is
	generic (
		START_ADDRESS: integer := 16#0000#;
		IO_DIR: std_logic_vector(15 downto 0)
	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		state : in t_Bus_State;
		addr : in std_logic_vector (15 downto 0);
		data : inout std_logic_vector (7 downto 0);
		io_ports: inout t_Digital_IO(15 downto 0)(7 downto 0)
	);
end io;

architecture io_arch of io is
	-------------------------------
	-- Functions
	-------------------------------

	-------------------------------
	-- Types
	-------------------------------

	-------------------------------
	-- Constants
	-------------------------------
	constant END_ADDRESS: integer := START_ADDRESS + 15;

	-------------------------------
	-- Components
	-------------------------------

	-------------------------------
	-- Signals
	-------------------------------
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
		to_integer(unsigned(addr)) > END_ADDRESS) else
		io_ports((to_integer(unsigned(addr)) - START_ADDRESS));

	ENABLE: process (addr)
	begin
		if (to_integer(unsigned(addr)) >= START_ADDRESS and
				to_integer(unsigned(addr)) <= END_ADDRESS) then
			EN <= '1';
		else
			EN <= '0';
		end if;
	end process;

	IO_PROC: process (clk, rst)
	begin
		if (rst = '0' or state = OFF) then
			data <= BUS_HIGH_Z;
			io_ports <= (others => BUS_HIGH_Z);
		else
			if (rising_edge(clk)) then
				if (state = WRITE and EN = '1' and
						IO_DIR(to_integer(unsigned(addr)) - START_ADDRESS) = '1') then
					io_ports(to_integer(unsigned(addr)) - START_ADDRESS) <= data_rx;
				end if;
				data <= data_tx when (state = READ and EN = '1') else BUS_HIGH_Z;
			end if;
		end if;
	end process;

end io_arch;
