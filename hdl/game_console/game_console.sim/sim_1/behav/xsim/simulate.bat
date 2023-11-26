@echo off
REM ****************************************************************************
REM Vivado (TM) v2023.1 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Sun Nov 26 12:07:05 -0500 2023
REM SW Build 3865809 on Sun May  7 15:05:29 MDT 2023
REM
REM IP Build 3864474 on Sun May  7 20:36:21 MDT 2023
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim memory_tb_behav -key {Behavioral:sim_1:Functional:memory_tb} -tclbatch memory_tb.tcl -view C:/Users/dyrge/Documents/EEL4744/game_console/hdl/game_console/video_card_tb_behav.wcfg -view C:/Users/dyrge/Documents/EEL4744/game_console/hdl/game_console/memory_tb_behav.wcfg -view C:/Users/dyrge/Documents/EEL4744/game_console/hdl/game_console/ram_tb_behav.wcfg -view C:/Users/dyrge/Documents/EEL4744/game_console/hdl/game_console/reg_tb_behav.wcfg -view C:/Users/dyrge/Documents/EEL4744/game_console/hdl/game_console/io_tb_behav.wcfg -log simulate.log"
call xsim  memory_tb_behav -key {Behavioral:sim_1:Functional:memory_tb} -tclbatch memory_tb.tcl -view C:/Users/dyrge/Documents/EEL4744/game_console/hdl/game_console/video_card_tb_behav.wcfg -view C:/Users/dyrge/Documents/EEL4744/game_console/hdl/game_console/memory_tb_behav.wcfg -view C:/Users/dyrge/Documents/EEL4744/game_console/hdl/game_console/ram_tb_behav.wcfg -view C:/Users/dyrge/Documents/EEL4744/game_console/hdl/game_console/reg_tb_behav.wcfg -view C:/Users/dyrge/Documents/EEL4744/game_console/hdl/game_console/io_tb_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0