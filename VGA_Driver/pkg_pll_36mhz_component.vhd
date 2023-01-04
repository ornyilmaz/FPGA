--Copyright (C) 1991-2011 Altera Corporation
--Your use of Altera Corporation's design tools, logic functions
--and other software and tools, and its AMPP partner logic
--functions, and any output files from any of the foregoing
--(including device programming or simulation files), and any
--associated documentation or information are expressly subject
--to the terms and conditions of the Altera Program License
--Subscription Agreement, Altera MegaCore Function License
--Agreement, or other applicable license agreement, including,
--without limitation, that your use is for the sole purpose of
--programming logic devices manufactured by Altera and sold by
--Altera or its authorized distributors.  Please refer to the
--applicable agreement for further details.
-------------------------------------------EDIT------------------
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Engineer : Orhan YILMAZ    ||  www.mafgom.com   ||
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
 
LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.ALL;
 
package pkg_pll_36mhz_component is
   component pll_36mhz
	   PORT
	   (
	   	areset		: IN STD_LOGIC  := '0';
	   	inclk0		: IN STD_LOGIC  := '0';
	   	c0		: OUT STD_LOGIC ;
	   	locked		: OUT STD_LOGIC
	   );
   end component;
end package;