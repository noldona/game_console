-------------------------------------------------------------------------------
-- Engineer: Ronald Jones
--
-- Create Date: 10/11/2023 07:28:48 PM
-- Design Name: VGA Resolutions
-- Project Name: Game Console
-- Target Devices: Digilent Cmod S7 Development Board
-- Description: This defines the values for the different resolutions
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

package vga_types is
	-----------------------------------------------
	-- Type Definitions
	-----------------------------------------------
	type t_Sync is record
		active: integer;
		front_porch: integer;
		sync_pulse: integer;
		back_porch: integer;
		total: integer;
	end record t_Sync;

	type t_VGA is record
		hsync: t_Sync;
		vsync: t_Sync;
		pixel_freq: integer;
	end record t_VGA;

	-----------------------------------------------
	-- Constant Definitions
	-----------------------------------------------

	-----------------------------------------------
	-- 640 x 350
	-----------------------------------------------

	-- VGA 640x350@70 Hz (pixel clock 25.175 MHz)
	constant VGA_640_350_70: t_VGA := (
		hsync => (
			active => 640,
			front_porch => 16,
			sync_pulse => 96,
			back_porch => 48,
			total => 800
		),
		vsync => (
			active => 350,
			front_porch => 37,
			sync_pulse => 2,
			back_porch => 60,
			total => 449
		),
		pixel_freq => 25175e3
	);


	-----------------------------------------------
	-- 640 x 400
	-----------------------------------------------

	-- VGA 640x400@70 Hz (pixel clock 25.175 MHz)
	constant VGA_640_400_70: t_VGA := (
		hsync => (
			active => 640,
			front_porch => 16,
			sync_pulse => 96,
			back_porch => 48,
			total => 800
		),
		vsync => (
			active => 400,
			front_porch => 12,
			sync_pulse => 2,
			back_porch => 35,
			total => 449
		),
		pixel_freq => 25175e3
	);


	-----------------------------------------------
	-- 640 x 480
	-----------------------------------------------

	-- VGA 640x480@60 Hz Industry standard (pixel clock 25.175 MHz)
	constant VGA_640_480_60: t_VGA := (
		hsync => (
			active => 640,
			front_porch => 16,
			sync_pulse => 96,
			back_porch => 48,
			total => 800
		),
		vsync => (
			active => 480,
			front_porch => 10,
			sync_pulse => 2,
			back_porch => 33,
			total => 525
		),
		pixel_freq => 25175e3
	);


	-----------------------------------------------
	-- 800 x 600
	-----------------------------------------------

	-- SVGA 800x600@60 Hz (pixel clock 40.0 MHz)
	constant SVGA_800_600_60: t_VGA := (
		hsync => (
			active => 800,
			front_porch => 40,
			sync_pulse => 128,
			back_porch => 88,
			total => 1056
		),
		vsync => (
			active => 600,
			front_porch => 1,
			sync_pulse => 4,
			back_porch => 23,
			total => 628
		),
		pixel_freq => 40e6
	);

	-----------------------------------------------
	-- Function Definitions
	-----------------------------------------------

	-----------------------------------------------
	-- Procedure Definitions
	-----------------------------------------------

end package;
