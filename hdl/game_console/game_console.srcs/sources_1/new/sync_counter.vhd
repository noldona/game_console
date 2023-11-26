-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/14/2023 02:28:42 PM
-- Design Name: Video Card Sync Counter
-- Module Name: sync_counter - sync_counter_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: Counter for the video card sync signals
--
-- Dependencies:
-- 		VGA Types
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

use WORK.VGA_TYPES.ALL;
use WORK.CONSOLE_UTILS.ALL;


entity sync_counter is
	generic (
		RESOLUTION: t_VGA := VGA_640_480_60;
		DIR: std_logic := '0'  -- '0' = Horizontal, '1' = Vertical
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		sync: out std_logic;
		blank: out std_logic;
		addr: out std_logic_vector(15 downto 0);
		carry: out std_logic
	);
end sync_counter;

architecture sync_counter_arch of sync_counter is
	-------------------------------
	-- Functions
	-------------------------------
	-- Inline If-Then-Else function
	function ite(b: boolean; x, y: t_Sync) return t_Sync is
	begin
		if (b) then
			return x;
		else
			return y;
		end if;
	end function ite;

	-------------------------------
	-- Types
	-------------------------------

	-------------------------------
	-- Constants
	-------------------------------
	constant SYNC_VALS: t_Sync := ite((DIR = '0'), RESOLUTION.hsync,
		RESOLUTION.vsync);
	constant SYNC_START: integer := SYNC_VALS.active + SYNC_VALS.front_porch;
	constant SYNC_STOP: integer := SYNC_START + SYNC_VALS.sync_pulse;

	-------------------------------
	-- Components
	-------------------------------

	-------------------------------
	-- Signals
	-------------------------------
	signal cnt: unsigned(15 downto 0) := x"0000";

begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	SYNC_COUNTER: process (clk, rst)
	begin
		-- Counter
		if (rst = '0') then
			-- If reset
			cnt <= x"0000";
			sync <= '1';
			blank <= '1';
		else
			-- Blanking
			if (cnt > SYNC_VALS.active) then
				blank <= '1';
			else
				blank <= '0';
			end if;

			-- Sync Pulse
			if (cnt > SYNC_START and cnt <= SYNC_STOP) then
				sync <= '0';
			else
				sync <= '1';
			end if;

			if (rising_edge(clk)) then
				if (cnt = SYNC_VALS.total) then
					-- If reached total
					cnt <= x"0000";
					carry <= '1';
				else
					-- Else, increment count
					cnt <= cnt + 1;
					carry <= '0';
				end if;
			end if;
		end if;
	end process;

	-------------------------------
	-- Module Implementation
	-------------------------------
	addr <= std_logic_vector(cnt);

end sync_counter_arch;
