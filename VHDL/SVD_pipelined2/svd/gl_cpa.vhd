library IEEE;
	 use IEEE.std_logic_1164.all;
         use ieee.std_logic_signed.all;


entity gl_cpa    is
	GENERIC(n : integer);
	Port (	A1 : In std_logic_vector (n downto 0);
		A2 : In std_logic_vector (n downto 0);
		S : Out std_logic_vector (n downto 0) );
end gl_cpa;

architecture BEHAVIORAL of gl_cpa is

 begin
process(A1, A2)
	variable p : std_logic_vector (n downto 0) ;
	variable g : std_logic_vector (n downto 0) ;
	variable c : std_logic_vector (n downto 0) ;
	variable i : integer;
begin

  S <= A1 + A2;

end process;
end BEHAVIORAL;

configuration CFG_gl_cpa_BEHAVIORAL of gl_cpa    is
	 for BEHAVIORAL
	 end for;
end CFG_gl_cpa_BEHAVIORAL;
