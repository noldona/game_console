-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/29/2023 11:24:47 AM
-- Design Name: Data Path
-- Module Name: data_path - data_path_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This handles the internal routing of the processor to the
-- 		various registers and the ALU
--
-- Dependencies:
-- 		Game Console Utilities
-- 		Arithmetic Logic Unit
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


entity data_path is
	port (
		clk: in std_logic;
		rst: in std_logic;
		data: inout std_logic_vector(7 downto 0);
		addr: out std_logic_vector(15 downto 0);
		IR_Load: in std_logic;
		IR: out std_logic_vector(7 downto 0);
		MAR_Load: in std_logic;
		MAR_Byte: in std_logic;
		PC_Load: in std_logic;
		PC_Inc: in std_logic;
		PC_Byte: in std_logic;
		A_Load: in std_logic;
		B_Load: in std_logic;
		X_Load: in std_logic;
		Y_Load: in std_logic;
		ALU_Sel: in std_logic_vector(2 downto 0);
		Status_Result: out std_logic_vector(7 downto 0);
		Status_Load: in std_logic;
		Bus1_Sel: in std_logic_vector(1 downto 0);
		Bus2_Sel: in std_logic_vector(1 downto 0)
	);
end data_path;

architecture data_path_arch of data_path is
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
	component alu
		port (
			a: in std_logic_vector(7 downto 0);
			b: in std_logic_vector(7 downto 0);
			sel: in std_logic_vector(2 downto 0);
			result: out std_logic_vector(7 downto 0);
			status: out std_logic_vector(7 downto 0)
		);
	end component;

	component reg
		generic (
			SIZE: integer := 8
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			load: in std_logic;
			data_rx: in std_logic_vector(SIZE - 1 downto 0);
			data_tx: out std_logic_vector(SIZE - 1 downto 0)
		);
	end component;

	-------------------------------
	-- Signals
	-------------------------------
	-- External Bus signals
	signal data_tx: std_logic_vector(7 downto 0);
	signal data_rx: std_logic_vector(7 downto 0);

	-- Internal Bus signals
	signal Bus1: std_logic_vector(7 downto 0);
	signal Bus2: std_logic_vector(7 downto 0);

	-- Registers
	signal A: std_logic_vector(7 downto 0);  -- Accumulator
	signal B: std_logic_vector(7 downto 0);  -- General Purpose Register
	signal X: std_logic_vector(7 downto 0);  -- Index Register
	signal Y: std_logic_vector(7 downto 0);  -- Index Register
	-- TODO: Implement the stack
	signal SP: std_logic_vector(7 downto 0);  -- Stack Pointer Low-Byte, High-Byte is always x"01"
	signal PC: std_logic_vector(15 downto 0);  -- Program Counter
	signal MAR: std_logic_vector(15 downto 0);  -- Memory Address Register
	-- Processor Flags, NV-BDIZC
	-- Negative (N), Overflow (V), reserved, Break (B), Decimal (D),
	-- Interrupt Disabled (I), Zero (Z), Carry (C)
	signal status: std_logic_vector(7 downto 0);
	signal status_out: std_logic_vector(7 downto 0);

	-- Others
	signal ALU_Result: std_logic_vector(7 downto 0);
	signal PC_uns: unsigned(15 downto 0);


begin
	-------------------------------
	-- Component Implementations
	-------------------------------
	INSTRUCTION_REGISTER: reg
		generic map (
			SIZE => 8
		)
		port map (
			clk => clk,
			rst => rst,
			load => IR_Load,
			data_rx => Bus2,
			data_tx => IR
		);

	A_REGISTER: reg
		generic map (
			SIZE => 8
		)
		port map (
			clk => clk,
			rst => rst,
			load => A_Load,
			data_rx => Bus2,
			data_tx => A
		);

	B_REGISTER: reg
		generic map (
			SIZE => 8
		)
		port map (
			clk => clk,
			rst => rst,
			load => B_Load,
			data_rx => Bus2,
			data_tx => B
		);

	X_REGISTER: reg
		generic map (
			SIZE => 8
		)
		port map (
			clk => clk,
			rst => rst,
			load => X_Load,
			data_rx => Bus2,
			data_tx => X
		);

	Y_REGISTER: reg
		generic map (
			SIZE => 8
		)
		port map (
			clk => clk,
			rst => rst,
			load => Y_Load,
			data_rx => Bus2,
			data_tx => Y
		);

	STATUS_REGISTER: reg
		generic map (
			SIZE => 8
		)
		port map (
			clk => clk,
			rst => rst,
			load => Status_Load,
			data_rx => status,
			data_tx => Status_Result
		);

	ALU_1: alu
		port map (
			a => B,
			b => Bus1,
			sel => ALU_Sel,
			result => ALU_Result,
			status => status
		);

	-------------------------------
	-- Module Implementation
	-------------------------------
	data_rx <= data;
	data_tx <= Bus1;
	addr <= MAR;

	MUX_BUS1: process (Bus1_Sel, PC, A, B)
	begin
		case (Bus1_Sel) is
			when "00" => Bus1 <= PC(7 downto 0);
			when "01" => Bus1 <= PC(15 downto 8);
			when "10" => Bus1 <= A;
			when "11" => Bus1 <= B;
			when others => Bus1 <= x"00";
		end case;
	end process;

	MUX_BUS2: process (Bus2_Sel, ALU_Result, Bus1, data_rx)
	begin
		case (Bus2_Sel) is
			when "00" => Bus2 <= ALU_Result;
			when "01" => Bus2 <= Bus1;
			when "10" => Bus2 <= data_rx;
			when others => Bus2 <= x"00";
		end case;
	end process;

	-- TODO: Update this to use a counter register with 16 bits
	PROGRAM_COUNTER: process (clk, rst)
	begin
		if (rst = '0') then
			-- TODO: Change this to use reset vector x"FFFC"-x"FFFD"
			PC_uns <= x"4020";
			data <= BUS_HIGH_Z;
		elsif (rising_edge(clk)) then
			if (PC_Load = '1') then
				if (PC_Byte = '0') then
					PC_uns(7 downto 0) <= unsigned(Bus2);  -- Low Byte
				else
					PC_uns(15 downto 8) <= unsigned(Bus2);  -- High Byte
				end if;
			elsif (PC_Inc = '1') then
				PC_uns <= PC_uns + 1;
			end if;
		end if;
	end process;

	-- TODO: Update this to use register with 16 bits
	MEMORY_ADDRESS_REGISTER: process (clk, rst)
	begin
		if (rst = '0') then
			MAR <= x"0000";
		elsif (rising_edge(clk)) then
			if (MAR_Load = '1') then
				if (MAR_Byte = '0') then
					MAR(7 downto 0) <= Bus2;  -- Low Byte
				else
					MAR(15 downto 8) <= Bus2;  -- High Byte
				end if;
			end if;
		end if;
	end process;

	PC <= std_logic_vector(PC_uns);

end data_path_arch;
