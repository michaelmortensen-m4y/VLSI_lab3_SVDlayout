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
        d   : out std_logic_vector(19 downto 0);  -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and range ]-2.0;2.0[
	   clk  : in std_logic;
       reset  : in std_logic
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

--component pipeRegister is
--    GENERIC(n : integer);
--    PORT(
--        d   : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--        --enable  : IN STD_LOGIC; -- enable.
--        clear : IN STD_LOGIC; -- async. clear.
--        clk : IN STD_LOGIC; -- clock.
--        q   : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) -- output
--    );
--end component;

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
    
    -- Pipe register 3 signals:
    signal xw20_reg: std_logic_vector(19 downto 0);
    signal yv20_reg: std_logic_vector(19 downto 0);
    signal yw20_reg: std_logic_vector(19 downto 0);
    signal xv20neg_reg: std_logic_vector(19 downto 0);
    signal xw20_next: std_logic_vector(19 downto 0);
    signal yv20_next: std_logic_vector(19 downto 0);
    signal yw20_next: std_logic_vector(19 downto 0);
    signal xv20neg_next: std_logic_vector(19 downto 0);
    
    -- Pipe register 4 signals:
    signal s_reg: std_logic_vector(19 downto 0);
    signal d_reg: std_logic_vector(19 downto 0);
    signal s_next: std_logic_vector(19 downto 0);
    signal d_next: std_logic_vector(19 downto 0);

begin

    -- Pipe register 3:
    process(clk, reset)
    begin
        if (reset = '1') then
            xw20_reg <= (others => '0');
            yv20_reg <= (others => '0');
            yw20_reg <= (others => '0');
            xv20neg_reg <= (others => '0');
        elsif falling_edge(clk) then
            xw20_reg <= xw20_next;
            yv20_reg <= yv20_next;
            yw20_reg <= yw20_next;
            xv20neg_reg <= xv20neg_next;
        end if;
    end process;
    
    -- Pipe register 4:
    process(clk, reset)
    begin
        if (reset = '1') then
            s_reg <= (others => '0');
            d_reg <= (others => '0');
        elsif rising_edge(clk) then
            s_reg <= s_next;
            d_reg <= d_next;
        end if;
    end process;

    x_sig <= x;
    y_sig <= y;
    w_sig <= w;
    v_sig <= v;
    
    -- Convert signed Q3.36 to signed Q1.18
    xw20 <= xw40(39) & xw40(36 downto 18);
    yv20 <= yv40(39) & yv40(36 downto 18);
    yw20 <= yw40(39) & yw40(36 downto 18);
    xv20 <= xv40(39) & xv40(36 downto 18);
    
    -- To substract xv20 we invert all its bits and set Cin to 1 for the carry look ahead adder
    xv20neg <= NOT xv20;
    
    -- Connect with registers
    xw20_next <= xw20;
    yv20_next <= yv20;
    yw20_next <= yw20;
    xv20neg_next <= xv20neg;
    s <= s_reg;
    d <= d_reg;

    mul0: multR4_20x20b_2c
        port map(X => x_sig, Y => w_sig, Z => xw40, clk => clk, reset => reset);
        
    mul1: multR4_20x20b_2c
        port map(X => y_sig, Y => v_sig, Z => yv40, clk => clk, reset => reset);
        
    mul2: multR4_20x20b_2c
        port map(X => y_sig, Y => w_sig, Z => yw40, clk => clk, reset => reset);
      
    mul3: multR4_20x20b_2c
        port map(X => x_sig, Y => v_sig, Z => xv40, clk => clk, reset => reset);
        
    adder: carryLookAheadAdder
        generic map(n => 20)
        port map(x_in => xw20_reg, y_in => yv20_reg, carry_in => '0', sum => s_next, carry_out => open);
        
    subber: carryLookAheadAdder
        generic map(n => 20)
        port map(x_in => yw20_reg, y_in => xv20neg_reg, carry_in => '1', sum => d_next, carry_out => open);

end arch;

