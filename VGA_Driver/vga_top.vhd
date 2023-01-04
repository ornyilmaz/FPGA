--=================================================================
-------------------------------------------------------------------
--   Orhan YILMAZ
--   VGA-Top Module
--   www.mafgom.com
-------------------------------------------------------------------
--=================================================================
LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.ALL;
 
LIBRARY work;
use work.pkg_vga_component.all;
use work.pkg_pll_36mhz_component.all;
use work.pkg_rgb_array_component.all;
 
entity vga_top is
port(
         --Clock,Reset Signal's ports
         clk       :in  std_logic; -- 50 MHZ
         rst_n     :in  std_logic; 
 
         -- Input Switch RGB value
         i_rgb     :in std_logic_vector(14 downto 0);
 
         --Output RGB Signal's ports
         o_red     :out std_logic_vector(9 downto 0);
         o_green   :out std_logic_vector(9 downto 0);
         o_blue    :out std_logic_vector(9 downto 0);
 
         --Output Synchronous Signal's pins
         o_vs      :out std_logic;
         o_hs      :out std_logic;
         o_clk_pix :out std_logic;
         o_de      :out std_logic
        );
end entity;
 
architecture RTL_top of vga_top is
 
signal rst              : std_logic := '1';
signal clk_36mhz        : std_logic := '0';
signal rgb              : std_logic_vector(29 downto 0); 
 
signal pos_x            : std_logic_vector(10 downto 0);
signal pos_y            : std_logic_vector( 9 downto 0);
 
signal de               : std_logic := '0';
signal rst_vga_cont     : std_logic := '0';
signal locked_pll_clk   : std_logic := '0';
signal rgb_addr         : std_logic_vector(16 downto 0);
signal rgb_data         : std_logic_vector(29 downto 0);
 
begin
 
rst <= not rst_n;
rst_vga_cont <= rst_n and locked_pll_clk;
 
pll_36mhz_inst : pll_36mhz
	PORT MAP
	        (
	   	   areset	=> rst,
                   inclk0	=> clk,
	   	   c0		=> clk_36mhz,
	   	   locked	=> locked_pll_clk
	        );
 
vga_cont : vga_control
	port map(
            --Clock,Reset Signal's ports
            clk       => clk_36mhz,
            rst_n     => rst_vga_cont,
 
            --Input RGB Signal's ports
            i_red     => rgb(29 downto 20),
            i_green   => rgb(19 downto 10),
            i_blue    => rgb( 9 downto  0),
 
            --Output RGB Signal's ports
            o_red     => o_red,
            o_green   => o_green,
            o_blue    => o_blue,
 
            --Output Position value
            o_pos_x   => pos_x,
            o_pos_y   => Pos_y,
 
            --Output Synchronous Signal's pins
            o_vs      => o_vs,
            o_hs      => o_hs,
            o_clk_pix => o_clk_pix,
            o_de      => de
          );
 
rgb_data_array: rgb_array
   port map(
            clk         => clk,
            rst_n       => rst_n,
            i_rgb_addr  => rgb_addr,
            i_de        => de,
            o_rgb       => rgb_data
          );
 
rgb(29 downto 20) <= (i_rgb(11)&"11"&i_rgb(10)&"11"&i_rgb(9)&"11"&i_rgb(8)) when i_rgb(14) = '1' else (OTHERS => '0');
rgb(19 downto 10) <= (i_rgb(7)&"11"&i_rgb(6)&"11"&i_rgb(5)&"11"&i_rgb(4))   when i_rgb(13) = '1' else (OTHERS => '0');
rgb( 9 downto  0) <= (i_rgb(3)&"11"&i_rgb(2)&"11"&i_rgb(1)&"11"&i_rgb(0))   when i_rgb(12) = '1' else (OTHERS => '0');
o_de <=  de;
 
end RTL_top;
