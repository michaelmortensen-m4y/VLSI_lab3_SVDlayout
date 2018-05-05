--------------------------------------------------------------------------------
-- Entity: SVD
-- Date:2018-04-16  
-- Author: Michael Mortensen et al.  
--
-- Description: The top level of the SVD
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity SVD is
	port  (
		x   : in std_logic_vector(19 downto 0); -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and allowed range [-1.0;1.0]
		y   : in std_logic_vector(19 downto 0); -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and allowed range [-1.0;1.0]
		w   : in std_logic_vector(19 downto 0); -- cos() -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and allowed range [-1.0;1.0]
        v   : in std_logic_vector(19 downto 0); -- sin() -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and allowed range [-1.0;1.0]
        s   : out std_logic_vector(19 downto 0); -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and range ]-2.0;2.0[
        d   : out std_logic_vector(19 downto 0)  -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and range ]-2.0;2.0[
	);
end SVD;

architecture arch of SVD is

component multR4_20x20b_2c is
    port (  X : In std_logic_vector(19 downto 0);
            Y : In std_logic_vector(19 downto 0);
            Z : Out std_logic_vector(39 downto 0) -- 40bit fixed point Q3.36 format
         );
end component;

--component adderWithCin is
--    GENERIC(n : integer);
--    port ( a, b : in std_logic_vector(n-1 downto 0);
--            cin : in std_logic;
--            sum : out std_logic_vector(n-1 downto 0);
--            cout : out std_logic := '0'
--         );
--end component;

component carryLookAheadAdder is
    GENERIC(n : integer);
     PORT(
         x_in      :  IN   STD_LOGIC_VECTOR(n-1 DOWNTO 0);
         y_in      :  IN   STD_LOGIC_VECTOR(n-1 DOWNTO 0);
         carry_in  :  IN   STD_LOGIC;
         sum       :  OUT  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
         carry_out :  OUT  STD_LOGIC
        );
end component;

    signal x_sig: std_logic_vector(19 downto 0);
    signal y_sig: std_logic_vector(19 downto 0);
    signal w_sig: std_logic_vector(19 downto 0);
    signal v_sig: std_logic_vector(19 downto 0);
    
    signal xw40: std_logic_vector(39 downto 0);
    signal yv40: std_logic_vector(39 downto 0);
    signal yw40: std_logic_vector(39 downto 0);
    signal xv40: std_logic_vector(39 downto 0);
    
    signal xw20: std_logic_vector(19 downto 0);
    signal yv20: std_logic_vector(19 downto 0);
    signal yw20: std_logic_vector(19 downto 0);
    signal xv20: std_logic_vector(19 downto 0);
    
    signal xv20neg: std_logic_vector(19 downto 0);

begin

    x_sig <= x;
    y_sig <= y;
    w_sig <= w;
    v_sig <= v;
    
    -- Convert signed Q3.36 to signed Q1.18
    xw20 <= xw40(39) & xw40(36 downto 18);
    yv20 <= yv40(39) & yv40(36 downto 18);
    yw20 <= yw40(39) & yw40(36 downto 18);
    xv20 <= xv40(39) & xv40(36 downto 18);
    
    -- To substract xv20 we invert all its bits and set Cin to 1 for the adder
    xv20neg <= NOT xv20;

    mul0: multR4_20x20b_2c
        port map(X => x_sig, Y => w_sig, Z => xw40);
        
    mul1: multR4_20x20b_2c
        port map(X => y_sig, Y => v_sig, Z => yv40);
        
    mul2: multR4_20x20b_2c
        port map(X => y_sig, Y => w_sig, Z => yw40);
      
    mul3: multR4_20x20b_2c
        port map(X => x_sig, Y => v_sig, Z => xv40);
        
--    adder: adderWithCin
--        generic map(n => 20)
--        port map(a => xw20, b => yv20, cin => '0', sum => s, cout => open);
        
--    subber: adderWithCin
--        generic map(n => 20)
--        port map(a => yw20, b => xv20neg, cin => '1', sum => d, cout => open);
        
    adder: carryLookAheadAdder
        generic map(n => 20)
        port map(x_in => xw20, y_in => yv20, carry_in => '0', sum => s, carry_out => open);
        
    subber: carryLookAheadAdder
        generic map(n => 20)
        port map(x_in => yw20, y_in => xv20neg, carry_in => '1', sum => d, carry_out => open);

end arch;

