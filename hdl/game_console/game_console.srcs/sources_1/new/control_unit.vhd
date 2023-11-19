-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/29/2023 11:24:47 AM
-- Design Name: Control Unit
-- Module Name: control_unit - control_unit_arch
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description:
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


entity control_unit is
	 port (
	 	clk: in std_logic;
	 	rst: in std_logic;
	 	state: out t_Bus_State;
	 	IR_Load: out std_logic;
	 	IR: in std_logic_vector(7 downto 0);
	 	MAR_Load: out std_logic;
	 	PC_Load: out std_logic;
	 	PC_Inc: out std_logic;
	 	A_Load: out std_logic;
	 	B_Load: out std_logic;
	 	ALU_Sel: out std_logic_vector(2 downto 0);
	 	CCR_Result: in std_logic_vector(3 downto 0);
	 	CCR_Load: out std_logic;
	 	Bus1_Sel: out std_logic_vector(1 downto 0);
	 	Bus2_Sel: out std_logic_vector(1 downto 0)
	 );
end control_unit;

architecture control_unit_arch of control_unit is
	-------------------------------
	-- Functions
	-------------------------------

	-------------------------------
	-- Types
	-------------------------------
	type t_States is (
		S_FETCH_0,  -- Opcode fetch states
		S_FETCH_1,
		S_FETCH_2,

		S_DECODE_3,  -- Opcode decode state

		S_LDA_IMM_4,  -- Load A (Immediate) states
		S_LDA_IMM_5,
		S_LDA_IMM_6,

		S_LDA_DIR_4,  -- Load A (Direct) states
		S_LDA_DIR_5,
		S_LDA_DIR_6,
		S_LDA_DIR_7,
		S_LDA_DIR_8,

		S_STA_DIR_4,  -- Store A (Direct) states
		S_STA_DIR_5,
		S_STA_DIR_6,
		S_STA_DIR_7,

		S_LDB_IMM_4,  -- Load B (Immediate) states
		S_LDB_IMM_5,
		S_LDB_IMM_6,

		S_LDB_DIR_4,  -- Load B (Direct) states
		S_LDB_DIR_5,
		S_LDB_DIR_6,
		S_LDB_DIR_7,
		S_LDB_DIR_8,

		S_STB_DIR_4,  -- Store B (Direct) states
		S_STB_DIR_5,
		S_STB_DIR_6,
		S_STB_DIR_7,

		S_ADD_AB_4,  -- A <= A + B

		S_SUB_AB_4,  -- A <= A - B

		S_AND_AB_4,  -- A <= A & B

		S_OR_AB_4,  -- A <= A | B

		S_INCA_4,  -- A <= A + 1

		S_DECA_4,  -- A <= A - 1

		S_INCB_4,  -- B <= B + 1

		S_DECB_4,  -- B <= B - 1

		S_BRA_4,  -- Branch Always
		S_BRA_5,
		S_BRA_6,

		S_BEQ_4,  -- Branch if Z = 1
		S_BEQ_5,
		S_BEQ_6,
		S_BEQ_7
	);

	-------------------------------
	-- Constants
	-------------------------------
	-- Load Register A with Immediate Addressing
	constant LDA_IMM: std_logic_vector(7 downto 0) := x"86";
	-- Load Register A with Direct Addressing
	constant LDA_DIR: std_logic_vector(7 downto 0) := x"87";
	-- Load Register B with Immediate Address
	constant LDB_IMM: std_logic_vector(7 downto 0) := x"88";
	-- Load Register B with Direct Addressing
	constant LDB_DIR: std_logic_vector(7 downto 0) := x"89";
	-- Store Register A to memory (RAM or I/O)
	constant STA_DIR: std_logic_vector(7 downto 0) := x"96";
	-- Store Register B to memory (RAM or I/O)
	constant STB_DIR: std_logic_vector(7 downto 0) := x"97";
	constant ADD_AB: std_logic_vector(7 downto 0) := x"42";  -- A <= A + B
	constant SUB_AB: std_logic_vector(7 downto 0) := x"43";  -- A <= A - B
	constant AND_AB: std_logic_vector(7 downto 0) := x"44";  -- A <= A & B
	constant OR_AB: std_logic_vector(7 downto 0) := x"45";  -- A <= A | B
	constant INCA: std_logic_vector(7 downto 0) := x"46";  -- A <= A + 1
	constant INCB: std_logic_vector(7 downto 0) := x"47";  -- B <= B + 1
	constant DECA: std_logic_vector(7 downto 0) := x"48";  -- A <= A - 1
	constant DECB: std_logic_vector(7 downto 0) := x"49";  -- B <= B - 1
	constant BRA: std_logic_vector(7 downto 0) := x"20";  -- Branch Always
	constant BMI: std_logic_vector(7 downto 0) := x"21";  -- Branch if N = 1
	constant BPL: std_logic_vector(7 downto 0) := x"22";  -- Branch if N = 0
	constant BEQ: std_logic_vector(7 downto 0) := x"23";  -- Branch if Z = 1
	constant BNE: std_logic_vector(7 downto 0) := x"24";  -- Branch if Z = 0
	constant BVS: std_logic_vector(7 downto 0) := x"25";  -- Branch if V = 1
	constant BVC: std_logic_vector(7 downto 0) := x"26";  -- Branch if V = 0
	constant BCS: std_logic_vector(7 downto 0) := x"27";  -- Branch if C = 1
	constant BCC: std_logic_vector(7 downto 0) := x"28";  -- Branch if C = 0

	-------------------------------
	-- Components
	-------------------------------

	-------------------------------
	-- Signals
	-------------------------------
	signal current_state: t_States;
	signal next_state: t_States;

begin
	-------------------------------
	-- Component Implementations
	-------------------------------

	-------------------------------
	-- Module Implementation
	-------------------------------
	STATE_MEMORY: process (clk, rst)
	begin
		if (rst = '0') then
			current_state <= S_FETCH_0;
		elsif (rising_edge(clk)) then
			current_state <= next_state;
		end if;
	end process;

	NEXT_STATE_LOGIC: process (current_state, IR, CCR_RESULT)
	begin
		case (current_state) is
			-- Opcode Fetch
			when S_FETCH_0 =>
				next_state <= S_FETCH_1;
			when S_FETCH_1 =>
				next_state <= S_FETCH_2;
			when S_FETCH_2 =>
				next_state <= S_DECODE_3;
			-- Opcode Decode
			when S_DECODE_3 =>
				-- Handle the different opcodes
				case (IR) is
					when LDA_IMM =>  -- Load A (Immediate)
						next_state <= S_LDA_IMM_4;
					when LDA_DIR =>  -- Load A (Direct)
						next_state <= S_LDA_DIR_4;
					when STA_DIR =>  -- Store A (Direct)
						next_state <= S_STA_DIR_4;
					when LDB_IMM =>  -- Load B (Immediate)
						next_state <= S_LDB_IMM_4;
					when LDB_DIR =>  -- Load B (Direct)
						next_state <= S_LDB_DIR_4;
					when STB_DIR =>  -- Store B (Direct)
						next_state <= S_STB_DIR_4;
					when ADD_AB =>  -- A <= A + B
						next_state <= S_ADD_AB_4;
					when OR_AB =>  -- A <= A | B
						next_state <= S_OR_AB_4;
					when INCA =>  -- A <= A + 1
						next_state <= S_INCA_4;
					when DECA =>  -- A <= A - 1
						next_state <= S_DECA_4;
					when INCB =>  -- B <= B + 1
						next_state <= S_INCB_4;
					when DECB =>  -- B <= B - 1
						next_state <= S_DECB_4;
					when BRA =>  -- Branch Always
						next_state <= S_BRA_4;
					when BEQ =>  -- Branch Equals
						if (CCR_Result(2) = '1') then  -- N = 1
							next_state <= S_BEQ_4;
						else
							next_state <= S_BEQ_7;
						end if;
					when others =>
						next_state <= S_FETCH_0;
				end case;

			-- Load A (Immediate) Instructions
			when S_LDA_IMM_4 =>
				next_state <= S_LDA_IMM_5;
			when S_LDA_IMM_5 =>
				next_state <= S_LDA_IMM_6;
			when S_LDA_IMM_6 =>
				next_state <= S_FETCH_0;

			-- Load A (Direct) Instructions
			when S_LDA_DIR_4 =>
				next_state <= S_LDA_DIR_5;
			when S_LDA_DIR_5 =>
				next_state <= S_LDA_DIR_6;
			when S_LDA_DIR_6 =>
				next_state <= S_LDA_DIR_7;
			when S_LDA_DIR_7 =>
				next_state <= S_LDA_DIR_7;
			when S_LDA_DIR_8 =>
				next_state <= S_FETCH_0;

			-- Store A (Direct) Instructions
			when S_STA_DIR_4 =>
				next_state <= S_STA_DIR_5;
			when S_STA_DIR_5 =>
				next_state <= S_STA_DIR_6;
			when S_STA_DIR_6 =>
				next_state <= S_STA_DIR_7;
			when S_STA_DIR_7 =>
				next_state <= S_FETCH_0;

			-- Load B (Immediate) Instructions
			when S_LDB_IMM_4 =>
				next_state <= S_LDB_IMM_5;
			when S_LDB_IMM_5 =>
				next_state <= S_LDB_IMM_6;
			when S_LDB_IMM_6 =>
				next_state <= S_FETCH_0;

			-- Load B (Direct) Instructions
			when S_LDB_DIR_4 =>
				next_state <= S_LDB_DIR_5;
			when S_LDB_DIR_5 =>
				next_state <= S_LDB_DIR_6;
			when S_LDB_DIR_6 =>
				next_state <= S_LDB_DIR_7;
			when S_LDB_DIR_7 =>
				next_state <= S_LDB_DIR_7;
			when S_LDB_DIR_8 =>
				next_state <= S_FETCH_0;

			-- Store B (Direct) Instructions
			when S_STB_DIR_4 =>
				next_state <= S_STB_DIR_5;
			when S_STB_DIR_5 =>
				next_state <= S_STB_DIR_6;
			when S_STB_DIR_6 =>
				next_state <= S_STB_DIR_7;
			when S_STB_DIR_7 =>
				next_state <= S_FETCH_0;

			-- A <= A + B
			when S_ADD_AB_4 =>
				next_state <= S_FETCH_0;

			-- Branch Always
			when S_BRA_4 =>
				next_state <= S_BRA_5;
			when S_BRA_5 =>
				next_state <= S_BRA_6;
			when S_BRA_6 =>
				next_state <= S_FETCH_0;

			-- Branch Z = 1
			when S_BEQ_4 =>
				next_state <= S_BEQ_5;
			when S_BEQ_5 =>
				next_state <= S_BEQ_6;
			when S_BEQ_6 =>
				next_state <= S_FETCH_0;

			-- Branch Z = 0
			when S_BEQ_7 =>
				next_state <= S_FETCH_0;

			when others =>
				next_state <= S_FETCH_0;
		end case ;
	end process;

	OUTPUT_LOGIC: process (current_state)
	begin
		case (current_state) is
			-- Put PC onto MAR to provice address of opcode
			when S_FETCH_0 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "01";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Increment PC, Opcode will be available next state
			when S_FETCH_1 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '1';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;
			-- Put opcode into IR
			when S_FETCH_2 =>
				IR_Load <= '1';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '1';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- No outputs, machine is decoding IR to decide which state
			-- to go to next
			when S_DECODE_3 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;

			-------------------------------
			-- Load A (Immediate)
			-------------------------------
			-- Put PC into MAR to provide address of operand
			when S_LDA_IMM_4 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "01";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Increment PC, Operand will be available next state
			when S_LDA_IMM_5 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '1';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;
			-- Operand is available, latch into A
			when S_LDA_IMM_6 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '1';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;

			-------------------------------
			-- Load A (Direct)
			-------------------------------
			-- Put PC into MAR to provide address of operand
			when S_LDA_DIR_4 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "01";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Prepare to receive operand from memory, increment PC
			when S_LDA_DIR_5 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '1';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;
			-- Put operand into MAR (Leave Bus2 = Memory)
			when S_LDA_DIR_6 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Wait for memory to respond
			when S_LDA_DIR_7 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;
			-- Put data arriving on bus into A
			when S_LDA_DIR_8 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '1';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;

			-------------------------------
			-- Store A (Direct)
			-------------------------------
			-- Put PC into MAR to provide address of operand
			when S_STA_DIR_4 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "01";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Prepare to receive operand from memory, increment PC
			when S_STA_DIR_5 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '1';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "01";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;
			-- Put operand into MAR (Leave Bus2 = Memory)
			when S_STA_DIR_6 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Put A onto Bus2, which is connected to Memory, assert write
			when S_STA_DIR_7 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "01";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= WRITE;

			-------------------------------
			-- Load B (Immediate)
			-------------------------------
			-- Put PC into MAR to provide address of operand
			when S_LDB_IMM_4 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "01";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Increment PC, Operand will be available next state
			when S_LDB_IMM_5 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '1';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;
			-- Operand is available, latch into B
			when S_LDB_IMM_6 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '1';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;

			-------------------------------
			-- Load B (Direct)
			-------------------------------
			-- Put PC into MAR to provide address of operand
			when S_LDB_DIR_4 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "01";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Prepare to receive operand from memory, increment PC
			when S_LDB_DIR_5 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '1';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;
			-- Put operand into MAR (Leave Bus2 = Memory)
			when S_LDB_DIR_6 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Wait for memory to respond
			when S_LDB_DIR_7 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;
			-- Put data arriving on bus into B
			when S_LDB_DIR_8 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '1';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;

			-------------------------------
			-- Store B (Direct)
			-------------------------------
			-- Put PC into MAR to provide address of operand
			when S_STB_DIR_4 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "01";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Prepare to receive operand from memory, increment PC
			when S_STB_DIR_5 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '1';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "01";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;
			-- Put operand into MAR (Leave Bus2 = Memory)
			when S_STB_DIR_6 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Put B onto Bus2, which is connected to Memory, assert write
			when S_STB_DIR_7 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "10";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= WRITE;

			-------------------------------
			-- A <= A + B
			-------------------------------
			-- Assert control signals to perform addition
			when S_ADD_AB_4 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '1';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '1';
				Bus1_Sel <= "01";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;

			-------------------------------
			-- Branch Always
			-------------------------------
			-- Put PC into MAR to provide address of operand
			when S_BRA_4 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "01";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Prepare to receive operand from memory
			when S_BRA_5 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;
			-- Put operand into PC (Leave Bus2 = Memory)
			when S_BRA_6 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '1';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;

			-------------------------------
			-- Branch if Z = 1
			-------------------------------
			-- Put PC into MAR to provide address of operand
			when S_BEQ_4 =>
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "01";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;
			-- Prepare to receive operand from memory
			when S_BEQ_5 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;
			-- Put operand into PC (Leave Bus2 = Memory)
			when S_BEQ_6 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '1';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "10";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;

			-------------------------------
			-- Branch if Z = 0
			-------------------------------
			-- Z = 0, so just increment PC
			when S_BEQ_7 =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '1';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= READ;

			-------------------------------
			-- Others
			-------------------------------
			when others =>
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00";  -- "00" = PC, "01" = A, "10" = B
				Bus2_Sel <= "00";  -- "00" = ALU, "01" = Bus1, "10" = Memory
				state <= OFF;
		end case;
	end process;

end control_unit_arch;