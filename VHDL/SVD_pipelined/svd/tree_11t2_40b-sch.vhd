-- ---------------------------------------------------------------
-- DSPVLSI : VHDL code
-- ---------------------------------------------------------------
-- Project  : multgen - Multiplier Builder
-- Designer : VHDL Builder (build_tree)
-- Design Unit Name : tree_11t2_40b
-- Purpose :
--
-- ---------------------------------------------------------------
-- File Name : tree_11t2_40b-sch.vhd
-- Date Created : 21/03/2018 at 15:29:02
-- ---------------------------------------------------------------

library IEEE;
	 use IEEE.std_logic_1164.all;

entity tree_11t2_40b is
	Port (	NEG : In std_logic_vector (9 downto 0);
		P0 : In std_logic_vector (20 downto 0);
		P1 : In std_logic_vector (20 downto 0);
		P2 : In std_logic_vector (20 downto 0);
		P3 : In std_logic_vector (20 downto 0);
		P4 : In std_logic_vector (20 downto 0);
		P5 : In std_logic_vector (20 downto 0);
		P6 : In std_logic_vector (20 downto 0);
		P7 : In std_logic_vector (20 downto 0);
		P8 : In std_logic_vector (20 downto 0);
		P9 : In std_logic_vector (20 downto 0);
		Z : Out std_logic_vector (39 downto 0);
		Y : Out std_logic_vector (39 downto 0);
		clk  : in std_logic;
        reset  : in std_logic
		 );
end tree_11t2_40b;

architecture SCHEMATIC of tree_11t2_40b is

	signal a0 : std_logic_vector(39 downto 0);
	signal a1 : std_logic_vector(39 downto 0);
	signal a2 : std_logic_vector(39 downto 0);
	signal a3 : std_logic_vector(39 downto 0);
	signal a4 : std_logic_vector(39 downto 0);
	signal a5 : std_logic_vector(39 downto 0);
	signal a6 : std_logic_vector(39 downto 0);
	signal a7 : std_logic_vector(39 downto 0);
	signal a8 : std_logic_vector(39 downto 0);
	signal a9 : std_logic_vector(39 downto 0);
	signal a10 : std_logic_vector(39 downto 0);
	signal p1l0, p1l1, p1l2, p1l3, p1l4, p1l5, p1l6, p1l7 : std_logic_vector(39 downto 0);
	signal p2l0, p2l1, p2l2, p2l3, p2l4, p2l5, p2l6, p2l7 : std_logic_vector(39 downto 0);
	signal p3l0, p3l1, p3l2, p3l3, p3l4, p3l5, p3l6, p3l7 : std_logic_vector(39 downto 0);
	signal zero : std_logic;

   component gl_csa42 is
        GENERIC(n : integer);
        Port (  A : In std_logic_vector (n downto 0);
                B : In std_logic_vector (n downto 0);
                C : In std_logic_vector (n downto 0);
                D : In std_logic_vector (n downto 0);
                Z : Out std_logic_vector (n downto 0);
                Y : Out std_logic_vector (n downto 0) );
   end component;
   component gl_csa32 is
        GENERIC(n : integer);
        Port (  A : In std_logic_vector (n downto 0);
                B : In std_logic_vector (n downto 0);
                C : In std_logic_vector (n downto 0);
                Cin : In std_logic;
                Z : Out std_logic_vector (n downto 0);
                Y : Out std_logic_vector (n downto 0) );
   end component;
   
   -- Pipe register 0 signals:
    signal a0_reg: std_logic_vector(39 downto 0);
    signal a1_reg: std_logic_vector(39 downto 0);
    signal a2_reg: std_logic_vector(39 downto 0);
    signal a3_reg: std_logic_vector(39 downto 0);
    signal a4_reg: std_logic_vector(39 downto 0);
    signal a5_reg: std_logic_vector(39 downto 0);
    signal a6_reg: std_logic_vector(39 downto 0);
    signal a7_reg: std_logic_vector(39 downto 0);
    signal a8_reg: std_logic_vector(39 downto 0);
    signal a9_reg: std_logic_vector(39 downto 0);
    signal a10_reg: std_logic_vector(39 downto 0);
    signal a0_next: std_logic_vector(39 downto 0);
    signal a1_next: std_logic_vector(39 downto 0);
    signal a2_next: std_logic_vector(39 downto 0);
    signal a3_next: std_logic_vector(39 downto 0);
    signal a4_next: std_logic_vector(39 downto 0);
    signal a5_next: std_logic_vector(39 downto 0);
    signal a6_next: std_logic_vector(39 downto 0);
    signal a7_next: std_logic_vector(39 downto 0);
    signal a8_next: std_logic_vector(39 downto 0);
    signal a9_next: std_logic_vector(39 downto 0);
    signal a10_next: std_logic_vector(39 downto 0);
  
-- Pipe register 1 signals: p2l0 p2l1 p2l2 p2l3
    signal p2l0_reg: std_logic_vector(39 downto 0);
    signal p2l1_reg: std_logic_vector(39 downto 0);
    signal p2l2_reg: std_logic_vector(39 downto 0);
    signal p2l3_reg: std_logic_vector(39 downto 0);
    signal p2l0_next: std_logic_vector(39 downto 0);
    signal p2l1_next: std_logic_vector(39 downto 0);
    signal p2l2_next: std_logic_vector(39 downto 0);
    signal p2l3_next: std_logic_vector(39 downto 0);
    
begin

-- Pipe register 0:
    process(clk, reset)
    begin
        if (reset = '1') then
            a0_reg <= (others => '0');
            a1_reg <= (others => '0');
            a2_reg <= (others => '0');
            a3_reg <= (others => '0');
            a4_reg <= (others => '0');
            a5_reg <= (others => '0');
            a6_reg <= (others => '0');
            a7_reg <= (others => '0');
            a8_reg <= (others => '0');
            a9_reg <= (others => '0');
            a10_reg <= (others => '0');
        elsif rising_edge(clk) then
            a0_reg <= a0_next;
            a1_reg <= a1_next;
            a2_reg <= a2_next;
            a3_reg <= a3_next;
            a4_reg <= a4_next;
            a5_reg <= a5_next;
            a6_reg <= a6_next;
            a7_reg <= a7_next;
            a8_reg <= a8_next;
            a9_reg <= a9_next;
            a10_reg <= a10_next;
        end if;
    end process;
    
-- Pipe register 1:
    process(clk, reset)
    begin
        if (reset = '1') then
            p2l0_reg <= (others => '0');
            p2l1_reg <= (others => '0');
            p2l2_reg <= (others => '0');
            p2l3_reg <= (others => '0');
        elsif rising_edge(clk) then
            p2l0_reg <= p2l0_next;
            p2l1_reg <= p2l1_next;
            p2l2_reg <= p2l2_next;
            p2l3_reg <= p2l3_next;
        end if;
    end process;
    
    -- Connect with registers
    a0_next <= a0;
    a1_next <= a1;
    a2_next <= a2;
    a3_next <= a3;
    a4_next <= a4;
    a5_next <= a5;
    a6_next <= a6;
    a7_next <= a7;
    a8_next <= a8;
    a9_next <= a9;
    a10_next <= a10;
    p2l0_next <= p2l0;
    p2l1_next <= p2l1;
    p2l2_next <= p2l2;
    p2l3_next <= p2l3;

zero <= '0';

-- sign extension  width reduction and correction
a0(39 downto 23)<=(others => '0');
a0(22)<= (not P0(20));
a0(21)<= P0(20);
a0(20)<= P0(20);
a0(20 downto  0)<= P0(20 downto 0);
-- ---------------------------------------
a1(39 downto 24)<=(others => '0');
a1(23)<= '1';
a1(22)<= (not P1(20));
a1(21 downto  2)<= P1(19 downto 0);
a1( 1)<='0'; a1( 0)<=NEG( 0);
-- ---------------------------------------
a2(39 downto 26)<=(others => '0');
a2(25)<= '1';
a2(24)<= (not P2(20));
a2(23 downto  4)<= P2(19 downto 0);
a2( 3)<='0'; a2( 2)<=NEG( 1);
a2( 1 downto 0)<=(others => '0');
-- ---------------------------------------
a3(39 downto 28)<=(others => '0');
a3(27)<= '1';
a3(26)<= (not P3(20));
a3(25 downto  6)<= P3(19 downto 0);
a3( 5)<='0'; a3( 4)<=NEG( 2);
a3( 3 downto 0)<=(others => '0');
-- ---------------------------------------
a4(39 downto 30)<=(others => '0');
a4(29)<= '1';
a4(28)<= (not P4(20));
a4(27 downto  8)<= P4(19 downto 0);
a4( 7)<='0'; a4( 6)<=NEG( 3);
a4( 5 downto 0)<=(others => '0');
-- ---------------------------------------
a5(39 downto 32)<=(others => '0');
a5(31)<= '1';
a5(30)<= (not P5(20));
a5(29 downto 10)<= P5(19 downto 0);
a5( 9)<='0'; a5( 8)<=NEG( 4);
a5( 7 downto 0)<=(others => '0');
-- ---------------------------------------
a6(39 downto 34)<=(others => '0');
a6(33)<= '1';
a6(32)<= (not P6(20));
a6(31 downto 12)<= P6(19 downto 0);
a6(11)<='0'; a6(10)<=NEG( 5);
a6( 9 downto 0)<=(others => '0');
-- ---------------------------------------
a7(39 downto 36)<=(others => '0');
a7(35)<= '1';
a7(34)<= (not P7(20));
a7(33 downto 14)<= P7(19 downto 0);
a7(13)<='0'; a7(12)<=NEG( 6);
a7(11 downto 0)<=(others => '0');
-- ---------------------------------------
a8(39 downto 38)<=(others => '0');
a8(37)<= '1';
a8(36)<= (not P8(20));
a8(35 downto 16)<= P8(19 downto 0);
a8(15)<='0'; a8(14)<=NEG( 7);
a8(13 downto 0)<=(others => '0');
-- ---------------------------------------
-- MS-digit  ---------------------------------------
a9(39)<= '1';
a9(38)<= (not P9(20));
a9(37 downto 18)<= P9(19 downto 0);
a9(17)<='0'; a9(16)<=NEG( 8);
a9(15 downto 0)<=(others => '0');
-- ---------------------------------------
a10(39 downto 20)<= (others => '0'); a10(19)<='0';
a10(18)<=NEG( 9); a10(17 downto 0)<=(others => '0');

-- CSA 4:2 ----------------------------------------------
A_10 : gl_csa42 Generic Map(n=>39)
	Port Map ( A=> a0_reg, B=> a1_reg, C=> a2_reg, D=> a3_reg, Z=>p1l0 , Y=>p1l1 );
-- CSA 4:2 ----------------------------------------------
A_14 : gl_csa42 Generic Map(n=>39)
	Port Map ( A=> a4_reg, B=> a5_reg, C=> a6_reg, D=> a7_reg, Z=>p1l2 , Y=>p1l3 );
-- CSA 3:2 ----------------------------------------------
A_18 : gl_csa32 Generic Map(n=>39)
	Port Map ( A=> a8_reg, B=> a9_reg, C=> a10_reg, Cin=> ZERO, Z=>p1l4 , Y=>p1l5 );
-- CSA 3:2 ----------------------------------------------
A_20 : gl_csa32 Generic Map(n=>39)
	Port Map ( A=> p1l0, B=> p1l1, C=> p1l2, Cin=> ZERO, Z=>p2l0 , Y=>p2l1 );
-- CSA 3:2 ----------------------------------------------
A_23 : gl_csa32 Generic Map(n=>39)
	Port Map ( A=> p1l3, B=> p1l4, C=> p1l5, Cin=> ZERO, Z=>p2l2 , Y=>p2l3 );
-- CSA 4:2 ----------------------------------------------
A_30 : gl_csa42 Generic Map(n=>39)
	Port Map ( A=> p2l0_reg, B=> p2l1_reg, C=> p2l2_reg, D=> p2l3_reg, Z=>p3l0 , Y=>p3l1 );

Z <= p3l0; Y <= p3l1;

end SCHEMATIC;
-- rtl_synthesis off
configuration CFG_tree_11t2_40b_SCHEMATIC of tree_11t2_40b is
	for SCHEMATIC
      for A_10 : gl_csa42
		use configuration WORK.CFG_gl_csa42_BEHAVIORAL;
      end for;
      for A_14 : gl_csa42
		use configuration WORK.CFG_gl_csa42_BEHAVIORAL;
      end for;
      for A_18 : gl_csa32
		use configuration WORK.CFG_gl_csa32_BEHAVIORAL;
      end for;
      for A_20 : gl_csa32
		use configuration WORK.CFG_gl_csa32_BEHAVIORAL;
      end for;
      for A_23 : gl_csa32
		use configuration WORK.CFG_gl_csa32_BEHAVIORAL;
      end for;
      for A_30 : gl_csa42
		use configuration WORK.CFG_gl_csa42_BEHAVIORAL;
      end for;
	end for;
end CFG_tree_11t2_40b_SCHEMATIC;
-- rtl_synthesis on
