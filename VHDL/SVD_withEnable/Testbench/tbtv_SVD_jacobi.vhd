--------------------------------------------------------------------------------
-- Entity: tbtv_SVD_jacobi
-- Date:2018-04-18  
-- Author: Michael Mortensen     
--
-- Description: Testbench for top SVD doing jacobi from testvector
--------------------------------------------------------------------------------
library IEEE;
     use IEEE.std_logic_1164.all;
     use IEEE.std_logic_signed.all;
     use IEEE.std_logic_textio.all;
     use STD.textio.all;

 ENTITY tbtv_SVD_jacobi IS  
 END tbtv_SVD_jacobi;  

 ARCHITECTURE behavior OF tbtv_SVD_jacobi IS  
   -- Component Declaration for the Unit Under Test (UUT)  
   COMPONENT SVD  
   port  (
        x   : in std_logic_vector(19 downto 0); -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and allowed range [-1.0;1.0]
        y   : in std_logic_vector(19 downto 0); -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and allowed range [-1.0;1.0]
        w   : in std_logic_vector(19 downto 0); -- cos() -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and allowed range [-1.0;1.0]
        v   : in std_logic_vector(19 downto 0); -- sin() -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and allowed range [-1.0;1.0]
        s   : out std_logic_vector(19 downto 0); -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and range ]-2.0;2.0[
        d   : out std_logic_vector(19 downto 0);  -- 20bit fixed point Q1.18 format (S|I|FFFFFFFFFFFFFFFFFF) and range ]-2.0;2.0[
        s_en: in std_logic;
        d_en: in std_logic;
        clk  : in std_logic;
        reset  : in std_logic 
   );
   END COMPONENT;  

   --Inputs  
    signal clk    : std_logic;
    signal reset  : std_logic;
    signal test_s_en : std_logic;
    signal test_d_en : std_logic;
    signal test_x : std_logic_vector(19 downto 0); 
    signal test_y : std_logic_vector(19 downto 0); 
    signal test_w : std_logic_vector(19 downto 0);
    signal test_v : std_logic_vector(19 downto 0); 
    signal test_s : std_logic_vector(19 downto 0);
    signal test_d : std_logic_vector(19 downto 0);
    
    
 BEGIN  
   -- Instantiate the Unit Under Test (UUT)  
   uut: SVD PORT MAP(  
     x => test_x,  
     y => test_y,  
     w => test_w,  
     v => test_v,  
     s => test_s,  
     d => test_d,
     s_en => test_s_en,  
     d_en => test_d_en,
     clk => clk,
     reset => reset
   );  

   process
   begin        
        -- Clock the clock
        clk <= '0'; wait for 5 ns;
        clk <= '1'; wait for 5 ns;
   end process;

   simulation : process
   
    file file_VECTORS : TEXT;
    variable line_in, line_out : Line;
    variable var_SPACE  : character;
    variable var_s_en : std_logic;
    variable var_d_en : std_logic;
    variable var_x : std_logic_vector(19 downto 0); 
    variable var_y : std_logic_vector(19 downto 0); 
    variable var_w : std_logic_vector(19 downto 0);
    variable var_v : std_logic_vector(19 downto 0); 
    variable var_s_expected : std_logic_vector(19 downto 0);
    variable var_d_expected : std_logic_vector(19 downto 0);
    variable hasError : boolean := false;
    
    begin
        
        --FILE_OPEN(file_VECTORS, "testvec_jacobi.txt", READ_MODE);
        FILE_OPEN(file_VECTORS, "testvec_s.txt", READ_MODE);
        --FILE_OPEN(file_VECTORS, "testvec_d.txt", READ_MODE);

        readline(file_VECTORS, line_in); -- read the first comment line
        readline(file_VECTORS, line_in); -- read the second comment line

        reset <= '1';
        wait for 5 ns;
        reset <= '0';

        while not endfile(file_VECTORS) loop
            readline(file_VECTORS, line_in);
            read(line_in, var_s_en);     -- read binary value s_en
            read(line_in, var_SPACE);    -- read in the space character
            read(line_in, var_d_en);     -- read binary value d_en
            read(line_in, var_SPACE);    -- read in the space character
            hread(line_in, var_x);        -- read binary value x
            read(line_in, var_SPACE);    -- read in the space character
            hread(line_in, var_w);        -- read binary value w
            read(line_in, var_SPACE);    -- read in the space character
            hread(line_in, var_y);        -- read binary value y
            read(line_in, var_SPACE);    -- read in the space character
            hread(line_in, var_v);        -- read binary value v
            read(line_in, var_SPACE);    -- read in the space character
            hread(line_in, var_s_expected); -- read binary value s_expected
            read(line_in, var_SPACE);      -- read in the space character
            hread(line_in, var_d_expected); -- read binary value s_expected
 
            -- Pass the variables to the signals
            test_s_en <= var_s_en;
            test_d_en <= var_d_en;
            test_x <= var_x(19 downto 0);
            test_y <= var_y(19 downto 0);
            test_w <= var_w(19 downto 0);
            test_v <= var_v(19 downto 0);
            
            --checkSVD(test_s_en, test_d_en, test_x, test_y, test_w, test_v, var_s_expected, var_d_expected);
            hasError := false;
            for i in 0 to 19 loop
                if (test_s(i) /= var_s_expected(i) or test_d(i) /= var_d_expected(i)) then
                    hasError := true;
                end if;
            end loop;
        
            if (hasError) then
                write(line_out, string'("FAILED: "));
                hwrite(line_out, test_x, RIGHT, 5);
                write(line_out, string'(" "));
                hwrite(line_out, test_y, RIGHT, 5);
                write(line_out, string'(" "));
                hwrite(line_out, test_w, RIGHT, 5);
                write(line_out, string'(" "));
                hwrite(line_out, test_v, RIGHT, 5);
                write(line_out, string'(" | "));
                hwrite(line_out, test_s, RIGHT, 5);
                write(line_out, string'(" /= "));
                hwrite(line_out, var_s_expected, RIGHT, 5);
                write(line_out, string'(" | "));
                hwrite(line_out, test_d, RIGHT, 5);
                write(line_out, string'(" /= "));
                hwrite(line_out, var_d_expected, RIGHT, 5);
                writeline(OUTPUT,line_out);
            end if;
                
            assert not hasError -- If there is an error
                report "Fail."
                severity note;
            assert hasError     -- If there is no error
                report "Success."
                severity note;
    
            wait for 10 ns;

        end loop;
       
        file_close(file_VECTORS);       

        wait;
        
    end process simulation;
      
 END;  
