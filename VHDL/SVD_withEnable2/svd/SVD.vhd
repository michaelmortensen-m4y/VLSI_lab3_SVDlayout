--------------------------------------------------------------------------------
-- Entity: SVD
-- Date:2018-04-16   
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
        d   : out std_logic_vector(19 downto 0);  -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and range ]-2.0;2.0[
	    s_en: in std_logic;
	    d_en: in std_logic;
	    clk : in std_logic;
       reset: in std_logic
	);
end SVD;

architecture arch of SVD is

component multR4_20x20b_2c is
    port (  X : In std_logic_vector(19 downto 0);
            Y : In std_logic_vector(19 downto 0);
            Z : Out std_logic_vector(39 downto 0); -- 40bit fixed point Q3.36 format
            clk  : in std_logic;
            reset  : in std_logic
         );
end component;

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
    
    -- And gates outputs signals:
    signal andOut_xs: std_logic_vector(19 downto 0);
    signal andOut_ws: std_logic_vector(19 downto 0);
    signal andOut_ys: std_logic_vector(19 downto 0);
    signal andOut_vs: std_logic_vector(19 downto 0);
    
    signal andOut_xd: std_logic_vector(19 downto 0);
    signal andOut_wd: std_logic_vector(19 downto 0);
    signal andOut_yd: std_logic_vector(19 downto 0);
    signal andOut_vd: std_logic_vector(19 downto 0);
    
    -- Multiplier outputs signals:
    signal xw40: std_logic_vector(39 downto 0);
    signal yv40: std_logic_vector(39 downto 0);
    signal yw40: std_logic_vector(39 downto 0);
    signal xv40: std_logic_vector(39 downto 0);
    
    signal xw20: std_logic_vector(19 downto 0);
    signal yv20: std_logic_vector(19 downto 0);
    signal yw20: std_logic_vector(19 downto 0);
    signal xv20: std_logic_vector(19 downto 0);
    
    signal xv20neg: std_logic_vector(19 downto 0);
    
    -- Pipe register 0 signals:
    signal x_reg : std_logic_vector(19 downto 0);
    signal x_next: std_logic_vector(19 downto 0);
    signal y_reg : std_logic_vector(19 downto 0);
    signal y_next: std_logic_vector(19 downto 0);
    signal w_reg : std_logic_vector(19 downto 0);
    signal w_next: std_logic_vector(19 downto 0);
    signal v_reg : std_logic_vector(19 downto 0);
    signal v_next: std_logic_vector(19 downto 0);

begin

    -- Pipe register 0:
    process(clk, reset)
    begin
        if (reset = '1') then
            x_reg <= (others => '0');
            y_reg <= (others => '0');
            w_reg <= (others => '0');
            v_reg <= (others => '0');
        elsif rising_edge(clk) then
            x_reg <= x_next;
            y_reg <= y_next;
            w_reg <= w_next;
            v_reg <= v_next;
        end if;
    end process;
    
    -- Connect with register
    x_next <= x;
    y_next <= y;
    w_next <= w;
    v_next <= v;
    
    -- And gates for enabling s and d calculations
    process (s_en, d_en, x_reg, w_reg, y_reg, v_reg)
    begin
        for i in 19 downto 0 loop
            andOut_xs(i) <= x_reg(i) AND s_en;
            andOut_ws(i) <= w_reg(i) AND s_en;
            andOut_ys(i) <= y_reg(i) AND s_en;
            andOut_vs(i) <= v_reg(i) AND s_en;
            
            andOut_xd(i) <= x_reg(i) AND d_en;
            andOut_wd(i) <= w_reg(i) AND d_en;
            andOut_yd(i) <= y_reg(i) AND d_en;
            andOut_vd(i) <= v_reg(i) AND d_en;
        end loop;
    end process;
    
    -- Convert signed Q3.36 to signed Q1.18
    xw20 <= xw40(39) & xw40(36 downto 18);
    yv20 <= yv40(39) & yv40(36 downto 18);
    yw20 <= yw40(39) & yw40(36 downto 18);
    xv20 <= xv40(39) & xv40(36 downto 18);
    
    -- To substract xv20 we invert all its bits and set Cin to 1 for the carry look ahead adder
    xv20neg <= NOT xv20;

    mul0: multR4_20x20b_2c
        port map(X => andOut_xs, Y => andOut_ws, Z => xw40, clk => clk, reset => reset);
        
    mul1: multR4_20x20b_2c
        port map(X => andOut_ys, Y => andOut_vs, Z => yv40, clk => clk, reset => reset);
        
    mul2: multR4_20x20b_2c
        port map(X => andOut_yd, Y => andOut_wd, Z => yw40, clk => clk, reset => reset);
      
    mul3: multR4_20x20b_2c
        port map(X => andOut_xd, Y => andOut_vd, Z => xv40, clk => clk, reset => reset);
        
    adder: carryLookAheadAdder
        generic map(n => 20)
        port map(x_in => xw20, y_in => yv20, carry_in => '0', sum => s, carry_out => open);
        
    subber: carryLookAheadAdder
        generic map(n => 20)
        port map(x_in => yw20, y_in => xv20neg, carry_in => '1', sum => d, carry_out => open);

end arch;

