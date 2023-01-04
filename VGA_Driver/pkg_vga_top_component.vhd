-------------------------------------------------------------------
--   Orhan YILMAZ
--   VGA-Controler
--   www.mafgom.com
-------------------------------------------------------------------
--=================================================================
LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.ALL;
 
package pkg_vga_top_component is
 
    component vga_top is
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
        );    end component;
 
end package;
