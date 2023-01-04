--=================================================================
-------------------------------------------------------------------
--   Orhan YILMAZ
--   VGA-Controler
--   Testbench
--   www.mafgom.com
-------------------------------------------------------------------
--=================================================================
LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
 
LIBRARY work_top;
use work_top.pkg_vga_component.all;
use work_top.pkg_vga_top_component.all;
 
entity test is
end entity;
 
architecture TESTBENCH_VGA of test is
 
signal clk     : std_logic := '0';
signal rst_n   : std_logic := '0';
signal RGB     : std_logic_vector(29 downto 0);
signal VSYNC   : std_logic;
signal HSYNC   : std_logic;
signal de      : std_logic;
signal clk_pix : std_logic;
 
begin
--Generated Clock Signal
clk <= not clk after 20ns;
 
--Generated Reset Signal
rst_n <= '1' after 1000ns;
 
--
--VGA_1: vga_control
--	port map(
--            --Clock,Reset Signal's ports
--            clk       => clk,
--            rst_n     => rst_n,
--
--            --Input RGB Signal's ports
--            i_red     => "1001010101",
--            i_green   => "0010101001",
--            i_blue    => "1010101010",
--
--            --Output RGB Signal's ports
--            o_red     => RGB(29 downto 20),
--            o_green   => RGB(19 downto 10),
--            o_blue    => RGB( 9 downto  0),
--
--            --Output Synchronous Signal's pins
--            o_vs      => VSYNC,
--            o_hs      => HSYNC,
--            o_de      => de
--          );
--
 
vga_test : vga_top
      port map(
         --Clock,Reset Signal's ports
         clk       => clk, -- 50 MHZ
         rst_n     => rst_n, 
 
         -- Input Switch RGB value
         i_rgb     => "100111100000000",
 
         --Output RGB Signal's ports
         o_red     => RGB(29 downto 20),
         o_green   => RGB(19 downto 10),
         o_blue    => RGB( 9 downto  0),
 
         --Output Synchronous Signal's pins
         o_vs      => VSYNC,
         o_hs      => HSYNC,
         o_clk_pix => clk_pix,
         o_de      => de
        ); 
 
end TESTBENCH_VGA;
