-- ---------------------------------------------------------------
-- DSPVLSI : VHDL code
-- ---------------------------------------------------------------
-- Project  : multgen - Multiplier Builder
-- Designer : VHDL Builder (vhdlBuilder_simTB_mult)
-- Design Unit Name : tb_multR4_20x20b_2c
-- Purpose :
--
-- ---------------------------------------------------------------
-- File Name : tb_multR4_20x20b_2c.vhd
-- Date Created : 21/03/2018 at 15:29:02
-- ---------------------------------------------------------------

library IEEE;
	 use IEEE.std_logic_1164.all;
	 use IEEE.std_logic_signed.all;
	 use IEEE.std_logic_textio.all;
	 use STD.textio.all;

entity E is
end E;

architecture A of E is

	signal     X : std_logic_vector(19 downto 0);
	signal     Y : std_logic_vector(19 downto 0);
	signal     Z : std_logic_vector(39 downto 0);

   component multR4_20x20b_2c
	Port (	X : In std_logic_vector (19 downto 0);
		Y : In std_logic_vector (19 downto 0);
		Z : Out std_logic_vector (39 downto 0) );
   end component;

begin

   UUT : multR4_20x20b_2c
	 Port Map ( X, Y, Z );

   TB : block
   begin
   process
	CONSTANT CYCLE : time := 10 ns;
	file cmdfile : TEXT;
	variable line_in, line_out : Line;
	variable good : boolean;
	variable c : integer;
	variable ok : std_logic;
	variable A : std_logic_vector(19 downto 0);
	variable B : std_logic_vector(19 downto 0);
	variable Q : std_logic_vector(39 downto 0);
	variable P : std_logic_vector(39 downto 0);
   begin

	FILE_OPEN(cmdfile,"tv_mul20x20b_2c.in",READ_MODE);

	Q(39 downto 0) := (others => '0');
	c := 1;

  loop
    if endfile(cmdfile) then  -- Check EOF
      write(line_out, string'("--------- END SIMULATION  ------------------"));
        writeline(OUTPUT,line_out);
        assert false
           report "End of file encountered; exiting."
           severity NOTE;
        exit;
    end if;
    readline(cmdfile,line_in);
    next when line_in'length = 0;
    hread(line_in,A,good);
    assert good report "Text I/O read error" severity ERROR;
    hread(line_in,B,good);
    assert good report "Text I/O read error" severity ERROR;
    hread(line_in,P,good);
    assert good report "Text I/O read error" severity ERROR;

	X  <= A(19 downto 0);
	Y  <= B(19 downto 0);
	wait for CYCLE;

	Q(39 downto 0) := Z;
	if (P(39 downto 0) = Z) then
		ok := '1';
	else
		ok := '0';
	end if;
	write(line_out, string'("Test "));
	write(line_out,c);
	if (ok = '1') then
		write(line_out, string'(" passed: "));
		hwrite(line_out,A,RIGHT,5);
		write(line_out, string'(" x "));
		hwrite(line_out,B,RIGHT,5);
		write(line_out, string'(" -> "));
		hwrite(line_out,Q,RIGHT,10);
		writeline(OUTPUT,line_out);
	else
		write(line_out, string'(" FAILED: "));
		hwrite(line_out,A,RIGHT,5);
		write(line_out, string'(" x "));
		hwrite(line_out,B,RIGHT,5);
		write(line_out, string'(" -> "));
		hwrite(line_out,Q,RIGHT,10);
		write(line_out, string'(" <> "));
		hwrite(line_out,P,RIGHT,10);
		writeline(OUTPUT,line_out);
		assert (ok = '1') report "Z does not match in pattern" severity error;
	end if;
	c := c + 1;
	end loop;
write(line_out, string'("--------- END SIMULATION  ------------------"));
	writeline(OUTPUT,line_out);

   end process;
 end block;
end A;

configuration CFG_TB_multR4_20x20b_2c_BEHAVIORAL of E is
   for A
	 for UUT : multR4_20x20b_2c
	   use configuration WORK.CFG_multR4_20x20b_2c_SCHEMATIC;
	 end for;

	 for TB
	 end for;

   end for;
end CFG_TB_multR4_20x20b_2c_BEHAVIORAL;
