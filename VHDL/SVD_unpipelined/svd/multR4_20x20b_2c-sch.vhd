-- ---------------------------------------------------------------
-- DSPVLSI : VHDL code
-- ---------------------------------------------------------------
-- Project  : multgen - Multiplier Builder
-- Designer : VHDL Builder (build_mult)
-- Design Unit Name : multR4_20x20b_2c
-- Purpose :
--
-- ---------------------------------------------------------------
-- File Name : multR4_20x20b_2c-sch.vhd
-- Date Created : 21/03/2018 at 15:29:02
-- ---------------------------------------------------------------

library IEEE;
	 use IEEE.std_logic_1164.all;

entity multR4_20x20b_2c is
	Port (	X : In std_logic_vector (19 downto 0);
		Y : In std_logic_vector (19 downto 0);
		Z : Out std_logic_vector (39 downto 0) );
end multR4_20x20b_2c;

architecture SCHEMATIC of multR4_20x20b_2c is

component PARTPROD_2c
	GENERIC(n : integer);
	 Port (   X : In std_logic_vector(n-1 downto 0);
		  Y : In std_logic_vector(2 downto 0);
		NEG : Out std_logic;
		  P : Out std_logic_vector(n downto 0) );
end component;

component tree_11t2_40b
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
		Y : Out std_logic_vector (39 downto 0) );
end component;

component gl_cpa
  GENERIC(n : integer);
   Port (  A1 : In std_logic_vector(n downto 0);
       A2 : In std_logic_vector(n downto 0);
        S : Out std_logic_vector(n downto 0) );
end component;

	signal P0 : std_logic_vector(20 downto 0);
	signal P1 : std_logic_vector(20 downto 0);
	signal P2 : std_logic_vector(20 downto 0);
	signal P3 : std_logic_vector(20 downto 0);
	signal P4 : std_logic_vector(20 downto 0);
	signal P5 : std_logic_vector(20 downto 0);
	signal P6 : std_logic_vector(20 downto 0);
	signal P7 : std_logic_vector(20 downto 0);
	signal P8 : std_logic_vector(20 downto 0);
	signal P9 : std_logic_vector(20 downto 0);
	signal P10 : std_logic_vector(19 downto 0);
	signal  C : std_logic_vector(9 downto 0);
	signal Y0 : std_logic_vector(2 downto 0);
	signal PS : std_logic_vector(39 downto 0);
	signal PC : std_logic_vector(39 downto 0);
	signal ZARRAY : std_logic_vector(19 downto 0);
	signal ZERO : std_logic;


begin

ZERO <= '0';

ZARRAY <=  (others => '0');

Y0(0) <= '0'; Y0(2 downto 1)<=Y(1 downto 0);

PPG_0 : PARTPROD_2c Generic Map(n=>20)
	Port Map ( X=>X, Y=>Y0, NEG=>c(0), P=>P0 );
PPG_1 : PARTPROD_2c Generic Map(n=>20)
	Port Map ( X=>X, Y=>Y(3 downto 1), NEG=>c(1), P=>P1 );
PPG_2 : PARTPROD_2c Generic Map(n=>20)
	Port Map ( X=>X, Y=>Y(5 downto 3), NEG=>c(2), P=>P2 );
PPG_3 : PARTPROD_2c Generic Map(n=>20)
	Port Map ( X=>X, Y=>Y(7 downto 5), NEG=>c(3), P=>P3 );
PPG_4 : PARTPROD_2c Generic Map(n=>20)
	Port Map ( X=>X, Y=>Y(9 downto 7), NEG=>c(4), P=>P4 );
PPG_5 : PARTPROD_2c Generic Map(n=>20)
	Port Map ( X=>X, Y=>Y(11 downto 9), NEG=>c(5), P=>P5 );
PPG_6 : PARTPROD_2c Generic Map(n=>20)
	Port Map ( X=>X, Y=>Y(13 downto 11), NEG=>c(6), P=>P6 );
PPG_7 : PARTPROD_2c Generic Map(n=>20)
	Port Map ( X=>X, Y=>Y(15 downto 13), NEG=>c(7), P=>P7 );
PPG_8 : PARTPROD_2c Generic Map(n=>20)
	Port Map ( X=>X, Y=>Y(17 downto 15), NEG=>c(8), P=>P8 );
PPG_9 : PARTPROD_2c Generic Map(n=>20)
	Port Map ( X=>X, Y=>Y(19 downto 17), NEG=>c(9), P=>P9 );

I_tree : tree_11t2_40b
	Port Map ( P0=>P0, P1=>P1, P2=>P2, P3=>P3, P4=>P4, P5=>P5, 
		P6=>P6, P7=>P7, P8=>P8, P9=>P9, 
		 neg=>c, Z=>PS, Y=>PC );

I_cpa : gl_cpa Generic Map(n=>39)
  Port Map ( A1 => PS, A2  => PC, S => Z );

end SCHEMATIC;

-- rtl_synthesis off
configuration CFG_multR4_20x20b_2c_SCHEMATIC of multR4_20x20b_2c is
  for SCHEMATIC
      for PPG_0 : PARTPROD_2c
		use configuration WORK.CFG_PARTPROD_2c_BEHAVIORAL;
      end for;
      for PPG_1 : PARTPROD_2c
		use configuration WORK.CFG_PARTPROD_2c_BEHAVIORAL;
      end for;
      for PPG_2 : PARTPROD_2c
		use configuration WORK.CFG_PARTPROD_2c_BEHAVIORAL;
      end for;
      for PPG_3 : PARTPROD_2c
		use configuration WORK.CFG_PARTPROD_2c_BEHAVIORAL;
      end for;
      for PPG_4 : PARTPROD_2c
		use configuration WORK.CFG_PARTPROD_2c_BEHAVIORAL;
      end for;
      for PPG_5 : PARTPROD_2c
		use configuration WORK.CFG_PARTPROD_2c_BEHAVIORAL;
      end for;
      for PPG_6 : PARTPROD_2c
		use configuration WORK.CFG_PARTPROD_2c_BEHAVIORAL;
      end for;
      for PPG_7 : PARTPROD_2c
		use configuration WORK.CFG_PARTPROD_2c_BEHAVIORAL;
      end for;
      for PPG_8 : PARTPROD_2c
		use configuration WORK.CFG_PARTPROD_2c_BEHAVIORAL;
      end for;
      for PPG_9 : PARTPROD_2c
		use configuration WORK.CFG_PARTPROD_2c_BEHAVIORAL;
      end for;
      for I_tree : tree_11t2_40b
		use configuration WORK.CFG_tree_11t2_40b_SCHEMATIC;
      end for;
      for I_cpa : gl_cpa
        use configuration WORK.CFG_gl_cpa_BEHAVIORAL;
      end for;
  end for;
end CFG_multR4_20x20b_2c_SCHEMATIC;
-- rtl_synthesis on

