--=================================================================
-------------------------------------------------------------------
--   Orhan YILMAZ
--   VGA-Controler
--   www.mafgom.com  --
-------------------------------------------------------------------
--=================================================================
LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.ALL;
 
entity vga_control is
   port(
         --Clock,Reset Signal's ports
         clk       :in  std_logic;
         rst_n     :in  std_logic;
 
         --Input RGB Signal's ports
         i_red     :in  std_logic_vector(9 downto 0);
         i_green   :in  std_logic_vector(9 downto 0);
         i_blue    :in  std_logic_vector(9 downto 0);
 
         --Output RGB Signal's ports
         o_red     :out std_logic_vector(9 downto 0);
         o_green   :out std_logic_vector(9 downto 0);
         o_blue    :out std_logic_vector(9 downto 0);
 
         --Output Position value
         o_pos_x   :out std_logic_vector(10 downto 0);
         o_pos_y   :out std_logic_vector( 9 downto 0);
 
         --Output Synchronous Signal's pins
         o_vs      :out std_logic;
         o_hs      :out std_logic;
         o_clk_pix :out std_logic;
         o_de      :out std_logic
        );
end entity;
 
architecture RTL_VGA of vga_control is
 
signal      count_h        : std_logic_vector(10 downto 0):= (OTHERS =>'0'); --MAX "10000000000"(1024)
signal      count_v        : std_logic_vector( 9 downto 0):= (OTHERS =>'0'); --MAX "1001110001"(625)
 
constant    h_active       : std_logic_vector( 9 downto 0):= "1100100000";   --800
constant    h_front_porch  : std_logic_vector( 4 downto 0):= "11000";        --24
constant    h_sync         : std_logic_vector( 6 downto 0):= "1001000";      --72
constant    h_back_porch   : std_logic_vector( 7 downto 0):= "10000000";     --128
constant    h_total        : std_logic_vector( 9 downto 0):= "1111111111";  --1024
 
constant    v_active       : std_logic_vector( 9 downto 0):= "1100100000";   --600
constant    v_front_porch  : std_logic                    := '1';            --1
constant    v_sync         : std_logic_vector( 1 downto 0):= "10";           --2
constant    v_back_porch   : std_logic_vector( 4 downto 0):= "10110";        --22
constant    v_total        : std_logic_vector( 9 downto 0):= "1001110000";   --625
 
signal      count_de_depth : std_logic_vector(10 downto 0):= (OTHERS => '0');
signal      de             : std_logic := '0';
signal      h_blank        : std_logic_vector(7 downto 0):= (OTHERS => '0');
signal      v_blank        : std_logic_vector(4 downto 0):= (OTHERS => '0');
signal      vs             : std_logic := '1';
 
begin
 
h_blank <= h_sync + h_back_porch;
v_blank <= v_sync + v_back_porch;
 
--Vertical Counter Generated
count_v_p:process(clk,rst_n)
begin
   if(rst_n = '0') then
	   count_v <= (OTHERS=>'0');
   elsif(clk = '1' and clk'event) then
	   if(count_v < v_total) then
         if(count_h = h_total) then
            count_v <= count_v + '1';
         end if;
      else
         count_v <= (OTHERS=>'0');
	   end if;
   end if;
end process;
 
--Horizontal Counter Generated
count_h_p:process(clk,rst_n)
begin
   if(rst_n = '0') then
	   count_h <= (OTHERS=>'0');
   elsif(clk = '1' and clk'event) then
 	   if(count_h < h_total) then
	      count_h <= count_h + '1';
      else
         count_h <= (OTHERS=>'0');
      end if;
   end if;
end process;
 
--VS Generated
vs_p:process(clk,rst_n)
begin
   if(rst_n = '0') then
      vs <= '1';
   elsif(clk = '1' and clk'event) then
      if(count_v = "0") then --(v_front_porch - '1')) then
         if(count_h = h_front_porch + h_sync -"10") then
            vs <= '0';
         end if;
	   elsif(count_v = v_front_porch + v_sync - '1') then
         if(count_h = h_front_porch + h_sync - "10") then
	         vs <= '1';
         end if;
	   end if;
   end if;
end process;
 
--VSYNC Generated
vs_o_p:process(clk,rst_n)
begin
   if(rst_n = '0') then
      o_vs <= '1';
   elsif(clk = '1' and clk'event) then
      o_vs <= vs;
   end if;
end process;
 
--HSYNC Generated
hs_o_p:process(clk,rst_n)
begin
   if(rst_n = '0') then
	   o_hs <= '1';
   elsif(clk = '1' and clk'event) then
	   if(count_h = h_front_porch - '1')then
	      o_hs <= '0';
      elsif(count_h = h_front_porch + h_sync - '1') then
         o_hs <= '1';
      end if;
   end if;
end process;
 
--Output Data Enable Generated
de_o_p:process(clk,rst_n)
begin
   if(rst_n = '0') then
      o_de <= '0';
   elsif(clk = '1' and clk'event) then
      if(vs = '1') then
         if(count_h = h_back_porch + h_sync - '1') then
            o_de <= '1';
         elsif(count_h = h_total - h_front_porch) then
            o_de <= '0';
         end if;
      else
         o_de <= '0';
      end if;
   end if;
end process;
 
--Data Enable Generated
de_p:process(clk,rst_n)
begin
   if(rst_n = '0') then
      de <= '0';
   elsif(clk = '1' and clk'event) then
      if( vs = '1') then
         if(count_h = h_back_porch + h_sync - '1') then
            de <= '1';
         elsif(count_h = h_total - h_front_porch) then
            de<='0';
         end if;
      else
         de <= '0';
      end if;
   end if;
end process;
 
--Data Enable Depth counter
count_de_depth_p:process(clk,rst_n)
begin
   if(rst_n = '0') then
      count_de_depth <= (OTHERS => '0');
   elsif(clk = '1' and clk'event) then
      if(de = '1') then
         count_de_depth <= count_de_depth + '1';
      else
         count_de_depth <= (OTHERS => '0');
      end if;
   end if;
end process;
 
-- Output RGB Signas
o_red    <= i_red    when de = '1' else (OTHERS => '0');
o_green  <= i_green  when de = '1' else (OTHERS => '0');
o_blue   <= i_blue   when de = '1' else (OTHERS => '0');
 
--Output Pixel Clock
o_clk_pix <=  clk when rst_n = '1' else '0';
 
--Output Position Value
o_pos_x <= (count_h - h_blank) when de = '1' and count_h >= h_blank else (OTHERS => '0');
o_pos_y <= (count_v - "10"   ) when de = '1' and count_v >= "10"    else (OTHERS => '0');
 
end RTL_VGA;
