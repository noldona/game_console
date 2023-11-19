// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Sun Nov 12 16:00:58 2023
// Host        : LAPTOP-JRMFS4PA running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/dyrge/Documents/EEL4744/game_console/hdl/game_console/game_console.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s25csga225-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_40Mhz, clk_25MHz, resetn, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="resetn,clk_in1" */
/* synthesis syn_force_seq_prim="clk_40Mhz" */
/* synthesis syn_force_seq_prim="clk_25MHz" */;
  output clk_40Mhz /* synthesis syn_isclock = 1 */;
  output clk_25MHz /* synthesis syn_isclock = 1 */;
  input resetn;
  input clk_in1;
endmodule
