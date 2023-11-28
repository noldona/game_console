@echo off
REM ****************************************************************************
REM Vivado (TM) v2023.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Mon Nov 27 18:10:09 -0500 2023
REM SW Build 3865809 on Sun May  7 15:05:29 MDT 2023
REM
REM IP Build 3864474 on Sun May  7 20:36:21 MDT 2023
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
REM elaborate design
echo "xelab --debug typical --relax --mt 2 -L xil_defaultlib -L dist_mem_gen_v8_0_13 -L lib_pkg_v1_0_2 -L lib_cdc_v1_0_2 -L lib_srl_fifo_v1_0_2 -L fifo_generator_v13_2_8 -L lib_fifo_v1_0_17 -L axi_lite_ipif_v3_0_4 -L interrupt_control_v3_1_4 -L axi_quad_spi_v3_2_27 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot data_path_tb_behav xil_defaultlib.data_path_tb xil_defaultlib.glbl -log elaborate.log"
call xelab  --debug typical --relax --mt 2 -L xil_defaultlib -L dist_mem_gen_v8_0_13 -L lib_pkg_v1_0_2 -L lib_cdc_v1_0_2 -L lib_srl_fifo_v1_0_2 -L fifo_generator_v13_2_8 -L lib_fifo_v1_0_17 -L axi_lite_ipif_v3_0_4 -L interrupt_control_v3_1_4 -L axi_quad_spi_v3_2_27 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot data_path_tb_behav xil_defaultlib.data_path_tb xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
